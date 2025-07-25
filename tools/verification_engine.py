#!/usr/bin/env python3
"""
Lean 4 Verification Engine

Provides incremental build testing, progress tracking, and rollback capabilities
for systematic error fixing in Lean 4 projects.
"""

import subprocess
import time
import json
from pathlib import Path
from dataclasses import dataclass, asdict
from typing import List, Dict, Any, Optional, Tuple
from enum import Enum
import hashlib


class FixResult(Enum):
    """Results of attempting a fix"""
    SUCCESS = "success"
    FAILED = "failed"
    NEW_ERRORS = "new_errors"
    NO_CHANGE = "no_change"


@dataclass
class BuildState:
    """Represents the state of a build"""
    timestamp: float
    success: bool
    error_count: int
    warning_count: int
    errors: List[str]
    warnings: List[str]
    build_time: float
    git_hash: Optional[str] = None


@dataclass
class FixAttempt:
    """Records a fix attempt and its results"""
    attempt_id: str
    target_error: str
    fix_description: str
    timestamp: float
    before_state: BuildState
    after_state: BuildState
    result: FixResult
    git_commit: Optional[str] = None
    rollback_commit: Optional[str] = None


class VerificationEngine:
    """Handles verification of fixes with rollback capability"""
    
    def __init__(self, project_root: Path = None):
        self.project_root = project_root or Path.cwd()
        self.history_file = self.project_root / "tools" / "fix_history.json"
        self.attempts: List[FixAttempt] = []
        self._load_history()
    
    def capture_build_state(self, target: str = None) -> BuildState:
        """Capture current build state for comparison"""
        start_time = time.time()
        
        # Run lake build
        cmd = ["lake", "build"]
        if target:
            cmd.append(target)
        
        try:
            result = subprocess.run(
                cmd,
                cwd=self.project_root,
                capture_output=True,
                text=True,
                check=False
            )
            build_time = time.time() - start_time
            output = result.stderr + result.stdout
            
            # Parse output for errors and warnings
            errors = []
            warnings = []
            
            for line in output.split('\n'):
                line = line.strip()
                if 'error:' in line.lower():
                    errors.append(line)
                elif 'warning:' in line.lower():
                    warnings.append(line)
            
            success = result.returncode == 0 and len(errors) == 0
            
            # Get git commit hash
            git_hash = self._get_git_hash()
            
            return BuildState(
                timestamp=time.time(),
                success=success,
                error_count=len(errors),
                warning_count=len(warnings),
                errors=errors,
                warnings=warnings,
                build_time=build_time,
                git_hash=git_hash
            )
            
        except Exception as e:
            return BuildState(
                timestamp=time.time(),
                success=False,
                error_count=1,
                warning_count=0,
                errors=[f"Build command failed: {e}"],
                warnings=[],
                build_time=0,
                git_hash=self._get_git_hash()
            )
    
    def verify_fix(self, target_error: str, fix_description: str, target: str = None) -> FixAttempt:
        """Verify a fix attempt and record results"""
        attempt_id = self._generate_attempt_id(target_error)
        
        # Capture state before applying fix (should be current state)
        print("📸 Capturing pre-fix build state...")
        before_state = self.capture_build_state(target)
        
        print("⏳ Waiting for fix to be applied...")
        print("   (Apply your fix now, then press Enter to verify)")
        input("   Ready to verify? ")
        
        # Capture state after fix
        print("📸 Capturing post-fix build state...")
        after_state = self.capture_build_state(target)
        
        # Analyze results
        result = self._analyze_fix_result(before_state, after_state, target_error)
        
        # Create attempt record
        attempt = FixAttempt(
            attempt_id=attempt_id,
            target_error=target_error,
            fix_description=fix_description,
            timestamp=time.time(),
            before_state=before_state,
            after_state=after_state,
            result=result
        )
        
        # Handle result
        if result == FixResult.SUCCESS:
            print("✅ Fix successful! Committing changes...")
            commit_hash = self._commit_fix(attempt)
            attempt.git_commit = commit_hash
        elif result == FixResult.NEW_ERRORS:
            print("❌ Fix introduced new errors! Consider rollback...")
            self._offer_rollback(attempt)
        elif result == FixResult.FAILED:
            print("⚠️ Fix did not resolve the target error.")
        else:
            print("ℹ️ No significant change detected.")
        
        # Record attempt
        self.attempts.append(attempt)
        self._save_history()
        
        return attempt
    
    def _analyze_fix_result(self, before: BuildState, after: BuildState, target_error: str) -> FixResult:
        """Analyze the result of a fix attempt"""
        # Check if build went from failing to passing
        if not before.success and after.success:
            return FixResult.SUCCESS
        
        # Check if error count decreased
        if after.error_count < before.error_count:
            # Check if the specific target error is gone
            target_still_present = any(target_error.lower() in error.lower() for error in after.errors)
            if not target_still_present:
                return FixResult.SUCCESS
            else:
                return FixResult.FAILED
        
        # Check if new errors were introduced
        if after.error_count > before.error_count:
            return FixResult.NEW_ERRORS
        
        # Check if the specific error pattern is still present
        before_has_target = any(target_error.lower() in error.lower() for error in before.errors)
        after_has_target = any(target_error.lower() in error.lower() for error in after.errors)
        
        if before_has_target and not after_has_target:
            return FixResult.SUCCESS
        
        return FixResult.NO_CHANGE
    
    def _generate_attempt_id(self, target_error: str) -> str:
        """Generate unique ID for fix attempt"""
        content = f"{target_error}_{time.time()}"
        return hashlib.md5(content.encode()).hexdigest()[:8]
    
    def _get_git_hash(self) -> Optional[str]:
        """Get current git commit hash"""
        try:
            result = subprocess.run(
                ["git", "rev-parse", "HEAD"],
                cwd=self.project_root,
                capture_output=True,
                text=True,
                check=True
            )
            return result.stdout.strip()
        except:
            return None
    
    def _commit_fix(self, attempt: FixAttempt) -> Optional[str]:
        """Commit a successful fix"""
        try:
            # Add all changes
            subprocess.run(
                ["git", "add", "."],
                cwd=self.project_root,
                check=True
            )
            
            # Create commit message
            commit_msg = f"Fix: {attempt.fix_description}\n\nTarget error: {attempt.target_error[:100]}..."
            
            # Commit
            subprocess.run(
                ["git", "commit", "-m", commit_msg],
                cwd=self.project_root,
                check=True
            )
            
            # Get new commit hash
            return self._get_git_hash()
            
        except subprocess.CalledProcessError as e:
            print(f"⚠️ Failed to commit: {e}")
            return None
    
    def _offer_rollback(self, attempt: FixAttempt) -> None:
        """Offer to rollback a problematic fix"""
        print("\n🔄 Fix introduced new errors. Options:")
        print("1. Rollback to previous state")
        print("2. Keep changes and debug manually")
        print("3. Create checkpoint and continue")
        
        choice = input("Choose option (1-3): ").strip()
        
        if choice == "1":
            self.rollback_to_commit(attempt.before_state.git_hash)
        elif choice == "3":
            # Create a checkpoint commit for debugging
            try:
                subprocess.run(
                    ["git", "add", "."],
                    cwd=self.project_root,
                    check=True
                )
                subprocess.run(
                    ["git", "commit", "-m", f"Checkpoint: Attempted fix for {attempt.target_error} (needs debugging)"],
                    cwd=self.project_root,
                    check=True
                )
                attempt.git_commit = self._get_git_hash()
                print("📌 Checkpoint created for debugging")
            except:
                print("⚠️ Failed to create checkpoint")
    
    def rollback_to_commit(self, commit_hash: Optional[str]) -> bool:
        """Rollback to a specific commit"""
        if not commit_hash:
            print("❌ No commit hash provided for rollback")
            return False
        
        try:
            print(f"🔄 Rolling back to {commit_hash[:8]}...")
            subprocess.run(
                ["git", "reset", "--hard", commit_hash],
                cwd=self.project_root,
                check=True
            )
            print("✅ Rollback successful")
            return True
        except subprocess.CalledProcessError as e:
            print(f"❌ Rollback failed: {e}")
            return False
    
    def get_progress_summary(self) -> Dict[str, Any]:
        """Generate progress summary"""
        if not self.attempts:
            return {"message": "No fix attempts recorded yet"}
        
        successful_fixes = [a for a in self.attempts if a.result == FixResult.SUCCESS]
        failed_fixes = [a for a in self.attempts if a.result == FixResult.FAILED]
        problematic_fixes = [a for a in self.attempts if a.result == FixResult.NEW_ERRORS]
        
        # Get latest build state
        latest_attempt = max(self.attempts, key=lambda a: a.timestamp)
        current_state = latest_attempt.after_state
        
        return {
            "total_attempts": len(self.attempts),
            "successful_fixes": len(successful_fixes),
            "failed_fixes": len(failed_fixes),
            "problematic_fixes": len(problematic_fixes),
            "current_build_success": current_state.success,
            "current_error_count": current_state.error_count,
            "current_warning_count": current_state.warning_count,
            "success_rate": len(successful_fixes) / len(self.attempts) * 100,
            "recent_attempts": [
                {
                    "id": a.attempt_id,
                    "description": a.fix_description,
                    "result": a.result.value,
                    "timestamp": a.timestamp
                }
                for a in sorted(self.attempts, key=lambda x: x.timestamp, reverse=True)[:5]
            ]
        }
    
    def _load_history(self) -> None:
        """Load fix history from file"""
        if not self.history_file.exists():
            return
        
        try:
            with open(self.history_file, 'r') as f:
                data = json.load(f)
                
            for attempt_data in data.get('attempts', []):
                # Reconstruct FixAttempt objects
                before_state = BuildState(**attempt_data['before_state'])
                after_state = BuildState(**attempt_data['after_state'])
                
                attempt = FixAttempt(
                    attempt_id=attempt_data['attempt_id'],
                    target_error=attempt_data['target_error'],
                    fix_description=attempt_data['fix_description'],
                    timestamp=attempt_data['timestamp'],
                    before_state=before_state,
                    after_state=after_state,
                    result=FixResult(attempt_data['result']),
                    git_commit=attempt_data.get('git_commit'),
                    rollback_commit=attempt_data.get('rollback_commit')
                )
                self.attempts.append(attempt)
                
        except Exception as e:
            print(f"⚠️ Failed to load history: {e}")
    
    def _save_history(self) -> None:
        """Save fix history to file"""
        try:
            # Ensure tools directory exists
            self.history_file.parent.mkdir(exist_ok=True)
            
            data = {
                "attempts": [asdict(attempt) for attempt in self.attempts],
                "last_updated": time.time()
            }
            
            # Convert enum values to strings for JSON serialization
            for attempt_data in data["attempts"]:
                attempt_data["result"] = attempt_data["result"].value
            
            with open(self.history_file, 'w') as f:
                json.dump(data, f, indent=2)
                
        except Exception as e:
            print(f"⚠️ Failed to save history: {e}")


def main():
    """CLI entry point for verification engine"""
    import argparse
    
    parser = argparse.ArgumentParser(description="Lean 4 Verification Engine")
    parser.add_argument("command", choices=["verify", "status", "rollback"], help="Command to execute")
    parser.add_argument("--target", help="Build target")
    parser.add_argument("--error", help="Target error description for verification")
    parser.add_argument("--description", help="Fix description")
    parser.add_argument("--commit", help="Commit hash for rollback")
    parser.add_argument("--project-root", type=Path, help="Project root directory")
    
    args = parser.parse_args()
    
    engine = VerificationEngine(args.project_root)
    
    if args.command == "verify":
        if not args.error or not args.description:
            print("❌ --error and --description required for verification")
            return
        
        attempt = engine.verify_fix(args.error, args.description, args.target)
        print(f"\n📊 Result: {attempt.result.value}")
        
    elif args.command == "status":
        summary = engine.get_progress_summary()
        print("📊 Fix Progress Summary")
        print("─" * 30)
        for key, value in summary.items():
            if key != "recent_attempts":
                print(f"{key.replace('_', ' ').title()}: {value}")
        
        if "recent_attempts" in summary:
            print("\n🕒 Recent Attempts:")
            for attempt in summary["recent_attempts"]:
                print(f"  {attempt['id']}: {attempt['description']} ({attempt['result']})")
    
    elif args.command == "rollback":
        if not args.commit:
            print("❌ --commit required for rollback")
            return
        
        success = engine.rollback_to_commit(args.commit)
        if success:
            print("✅ Rollback completed")
        else:
            print("❌ Rollback failed")


if __name__ == "__main__":
    main()