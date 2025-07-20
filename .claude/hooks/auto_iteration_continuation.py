#!/usr/bin/env python3
"""
Aphrodisiac Problem Auto-Iteration Continuation Hook
==================================================

This project-specific hook automatically continues iterations after each Stop event
to maintain systematic progress toward completing the formal proof of E[τ] = e.

MATHEMATICAL PRIORITY: Continues indefinitely while sorries remain, regardless of session limits.
Session limits only apply when mathematical work is complete (0 sorries).

SAFETY: Only operates within the potion_problem project directory.

ENHANCED FEATURES (2025-07-20):
- Direct build verification: Executes 'lake build' to verify actual build status
- Infinite loop prevention: Tracks attempts on specific sorry configurations
- Strategic guidance: Analyzes sorry difficulty and recommends approaches
- Self-sufficient evidence: Analyzes git commits instead of trusting documentation
- User control: Set source code constants to disable hook when needed

USER CONTROL:
- To disable hook completely: Set HOOK_ENABLED = False in source code
- Default behavior: Hook blocks Stop events while sorries remain
"""

import json
import re
import sys
import os
import subprocess
import datetime
import hashlib
from pathlib import Path

# Project safety verification
PROJECT_NAME = "potion_problem"
MAX_ITERATIONS_PER_SESSION = 3
MIN_SECONDS_BETWEEN_ITERATIONS = 60

# User control flags - Edit these constants to control hook behavior
HOOK_ENABLED = False  # Set to False to disable hook completely

def verify_project_context(cwd: str) -> bool:
    """Ensure we're operating in the correct project directory."""
    return PROJECT_NAME in cwd and cwd.endswith(PROJECT_NAME)

def get_project_root(cwd: str) -> Path:
    """Get the project root directory."""
    return Path(cwd)

def analyze_recent_changes(project_root: Path) -> dict:
    """Analyze recent git changes to assess progress without relying on documentation."""
    try:
        # Get the last commit message and diff
        commit_result = subprocess.run(
            ['git', 'log', '-1', '--pretty=%s\n%b'],
            cwd=str(project_root),
            capture_output=True,
            text=True
        )
        
        diff_result = subprocess.run(
            ['git', 'diff', 'HEAD~1', '--', '*.lean'],
            cwd=str(project_root),
            capture_output=True,
            text=True
        )
        
        commit_message = commit_result.stdout.strip() if commit_result.returncode == 0 else ""
        diff_content = diff_result.stdout if diff_result.returncode == 0 else ""
        
        # Analyze what was attempted
        analysis = {
            "commit_message": commit_message,
            "files_changed": [],
            "lemmas_added": [],
            "sorries_touched": False,
            "build_status": "unknown"  # Will be verified separately
        }
        
        # Check if lean files were modified
        if diff_content:
            # Look for added lemmas/theorems
            lemma_matches = re.findall(r'\+\s*(lemma|theorem)\s+(\w+)', diff_content)
            analysis["lemmas_added"] = [match[1] for match in lemma_matches]
            
            # Check if sorries were modified
            if 'sorry' in diff_content:
                analysis["sorries_touched"] = True
            
            # Extract file names
            file_matches = re.findall(r'diff --git a/(.*\.lean) b/', diff_content)
            analysis["files_changed"] = list(set(file_matches))
        
        # Infer what was accomplished
        if analysis["lemmas_added"]:
            analysis["accomplished"] = f"Added lemmas: {', '.join(analysis['lemmas_added'])}"
        elif analysis["sorries_touched"]:
            analysis["accomplished"] = "Attempted to resolve sorry statements"
        elif analysis["files_changed"]:
            analysis["accomplished"] = f"Modified {len(analysis['files_changed'])} Lean files"
        else:
            analysis["accomplished"] = "No significant Lean changes detected"
        
        return analysis
        
    except Exception as e:
        return {"error": f"Failed to analyze git changes: {e}", "accomplished": "Unable to assess"}

def parse_iteration_history(project_root: Path) -> dict:
    """DEPRECATED: Keeping for compatibility, but prefer analyze_recent_changes()"""
    # Try git-based analysis first
    git_analysis = analyze_recent_changes(project_root)
    if "error" not in git_analysis:
        return git_analysis
    
    # Fallback to old documentation-based approach
    history_file = project_root / "docs" / "state" / "iteration-history.md"
    
    if not history_file.exists():
        return {"error": "iteration-history.md not found", "accomplished": "No history available"}
    
    try:
        with open(history_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Find the latest implementation record
        records = re.findall(r'## Implementation Record \(([^)]+)\)\n(.*?)(?=\n## |$)', content, re.DOTALL)
        
        if not records:
            return {"error": "No implementation records found", "accomplished": "No records"}
        
        latest_date, latest_content = records[-1]
        
        # Parse the latest record
        result = {"date": latest_date}
        
        for line in latest_content.split('\n'):
            line = line.strip()
            if line.startswith('- Agent ID:'):
                result["agent_id"] = line.split(':', 1)[1].strip()
            elif line.startswith('- Attempted:'):
                result["attempted"] = line.split(':', 1)[1].strip()
            elif line.startswith('- Accomplished:'):
                result["accomplished"] = line.split(':', 1)[1].strip()
            elif line.startswith('- Resolved sorries:'):
                result["resolved_sorries"] = line.split(':', 1)[1].strip()
            elif line.startswith('- Mathematical insight:'):
                result["mathematical_insight"] = line.split(':', 1)[1].strip()
            elif line.startswith('- Build status:'):
                result["build_status"] = line.split(':', 1)[1].strip()
        
        return result
        
    except Exception as e:
        return {"error": f"Failed to parse iteration history: {e}", "accomplished": "Parse failed"}

def count_current_sorries(project_root: Path) -> dict:
    """Count remaining sorries in TelescopingSeries.lean."""
    telescoping_file = project_root / "UniformHittingTime" / "TelescopingSeries.lean"
    
    if not telescoping_file.exists():
        return {"error": "TelescopingSeries.lean not found"}
    
    try:
        with open(telescoping_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Count sorry statements
        sorry_count = len(re.findall(r'\bsorry\b', content))
        
        # Find specific sorry locations
        sorry_locations = []
        for i, line in enumerate(content.split('\n'), 1):
            if 'sorry' in line:
                sorry_locations.append(f"L{i}")
        
        # Get file modification time as evidence of recent work
        mtime = os.path.getmtime(telescoping_file)
        modified_ago = datetime.datetime.now().timestamp() - mtime
        
        return {
            "count": sorry_count,
            "locations": sorry_locations,
            "modified_seconds_ago": int(modified_ago),
            "recently_modified": modified_ago < 300  # Modified in last 5 minutes
        }
        
    except Exception as e:
        return {"error": f"Failed to count sorries: {e}"}

def verify_build_status(project_root: Path) -> dict:
    """Directly execute lake build and verify actual build status."""
    try:
        result = subprocess.run(
            ['lake', 'build'],
            cwd=str(project_root),
            capture_output=True,
            text=True,
            timeout=300  # 5 minute timeout
        )
        
        success = result.returncode == 0
        
        # Extract key error information if build failed
        error_summary = ""
        if not success and result.stderr:
            # Look for error patterns in stderr
            lines = result.stderr.strip().split('\n')
            error_lines = [line for line in lines if 'error:' in line.lower()]
            if error_lines:
                error_summary = error_lines[0][:200]  # First error, truncated
        
        return {
            "success": success,
            "stdout": result.stdout[:1000] if result.stdout else "",
            "stderr": result.stderr[:1000] if result.stderr else "",
            "error_summary": error_summary
        }
    except subprocess.TimeoutExpired:
        return {"success": False, "error": "Build timeout after 5 minutes"}
    except Exception as e:
        return {"success": False, "error": f"Failed to run build: {e}"}

def track_sorry_attempts(project_root: Path, sorry_info: dict) -> dict:
    """Track attempts on specific sorries to prevent infinite loops."""
    attempts_file = project_root / ".claude" / "sorry_attempts.json"
    
    # Generate hash of current sorry state (locations + count)
    sorry_state = f"{sorry_info.get('count', 0)}:{','.join(sorry_info.get('locations', []))}"
    sorry_hash = hashlib.md5(sorry_state.encode()).hexdigest()
    
    try:
        # Load existing attempts
        if attempts_file.exists():
            with open(attempts_file, 'r') as f:
                attempts_data = json.load(f)
        else:
            attempts_data = {"attempts": {}, "last_hash": None}
        
        # Check if sorry state changed (progress was made)
        if attempts_data.get("last_hash") != sorry_hash:
            # Reset attempts for new sorry configuration
            attempts_data["attempts"] = {}
            attempts_data["last_hash"] = sorry_hash
        
        # Get current attempt count
        current_attempts = attempts_data["attempts"].get(sorry_hash, 0)
        
        # Check if we've exceeded maximum attempts
        MAX_ATTEMPTS_PER_SORRY = 5
        if current_attempts >= MAX_ATTEMPTS_PER_SORRY:
            return {
                "should_pause": True,
                "attempts": current_attempts,
                "reason": f"Same sorry configuration attempted {current_attempts} times"
            }
        
        # Increment attempt count
        attempts_data["attempts"][sorry_hash] = current_attempts + 1
        
        # Save updated attempts
        attempts_file.parent.mkdir(exist_ok=True)
        with open(attempts_file, 'w') as f:
            json.dump(attempts_data, f, indent=2)
        
        return {
            "should_pause": False,
            "attempts": current_attempts + 1
        }
        
    except Exception as e:
        # Don't block on tracking errors
        return {"should_pause": False, "attempts": 0, "error": str(e)}

def analyze_sorry_context(project_root: Path, sorry_locations: list) -> dict:
    """Analyze the context and difficulty of remaining sorries."""
    if not sorry_locations:
        return {"difficulty": "none", "analysis": "No sorries found"}
    
    telescoping_file = project_root / "UniformHittingTime" / "TelescopingSeries.lean"
    
    try:
        with open(telescoping_file, 'r', encoding='utf-8') as f:
            lines = f.readlines()
        
        analyses = []
        
        for location in sorry_locations:
            # Extract line number from "L686" format
            line_num = int(location[1:]) - 1  # Convert to 0-based index
            
            # Get context around the sorry (10 lines before and after)
            start = max(0, line_num - 10)
            end = min(len(lines), line_num + 11)
            context_lines = lines[start:end]
            context = ''.join(context_lines)
            
            # Analyze difficulty indicators
            indicators = {
                "uses_advanced_tactics": any(tactic in context for tactic in ['simp_all', 'omega', 'ring', 'norm_num']),
                "involves_limits": any(term in context for term in ['limit', 'tendsto', 'Filter', 'atTop']),
                "complex_types": context.count('→') > 3 or 'Finset' in context,
                "nested_proofs": context.count('·') > 2,
                "summation": 'sum' in context.lower() or '∑' in context,
                "factorial": 'factorial' in context or '!' in context
            }
            
            # Calculate difficulty score
            difficulty_score = sum(indicators.values())
            difficulty_levels = ["easy", "medium", "hard", "very_hard"]
            difficulty = difficulty_levels[min(difficulty_score // 2, 3)]
            
            # Extract the specific lemma/theorem name if possible
            theorem_match = re.search(r'(lemma|theorem)\s+(\w+)', context)
            theorem_name = theorem_match.group(2) if theorem_match else "unknown"
            
            analyses.append({
                "location": location,
                "difficulty": difficulty,
                "theorem": theorem_name,
                "indicators": indicators,
                "context_preview": context[:150].replace('\n', ' ')
            })
        
        # Overall assessment
        max_difficulty = max(a["difficulty"] for a in analyses)
        
        return {
            "overall_difficulty": max_difficulty,
            "sorry_analyses": analyses,
            "recommendation": generate_difficulty_recommendation(analyses)
        }
        
    except Exception as e:
        return {"difficulty": "unknown", "error": f"Failed to analyze: {e}"}

def generate_difficulty_recommendation(analyses: list) -> str:
    """Generate strategic recommendation based on sorry difficulty analysis."""
    if not analyses:
        return "No sorries to analyze"
    
    # Sort by difficulty (easy first)
    difficulty_order = {"easy": 0, "medium": 1, "hard": 2, "very_hard": 3}
    sorted_analyses = sorted(analyses, key=lambda x: difficulty_order.get(x["difficulty"], 4))
    
    easiest = sorted_analyses[0]
    
    if easiest["difficulty"] == "easy":
        return f"Start with {easiest['theorem']} at {easiest['location']} - appears straightforward"
    elif easiest["difficulty"] == "medium":
        return f"Focus on {easiest['theorem']} at {easiest['location']} - moderate complexity"
    else:
        # All are hard/very_hard
        if any(a["indicators"]["summation"] for a in analyses):
            return "Consider proving summation helper lemmas first"
        elif any(a["indicators"]["factorial"] for a in analyses):
            return "Consider factorial manipulation lemmas"
        else:
            return "Break down into smaller helper lemmas"

def assess_mathematical_progress(latest_record: dict, sorry_info: dict, build_result: dict = None) -> dict:
    """Clinically assess the mathematical progress made based on concrete evidence."""
    
    # Progress indicators
    indicators = {
        "substantial": False,
        "incremental": False,
        "minimal": False,
        "regressive": False
    }
    
    reasons = []
    
    # NEW: Check if the target file was actually modified recently
    if sorry_info.get("recently_modified", False):
        reasons.append(f"TelescopingSeries.lean modified {sorry_info.get('modified_seconds_ago', 'unknown')}s ago")
    else:
        # If file wasn't touched recently, be skeptical
        indicators["minimal"] = True
        reasons.append("Target file not modified in last 5 minutes")
    
    # Check git evidence for actual changes
    if "lemmas_added" in latest_record and latest_record["lemmas_added"]:
        indicators["substantial"] = True
        reasons.append(f"Git evidence: Added {len(latest_record['lemmas_added'])} lemmas")
    elif "sorries_touched" in latest_record and latest_record["sorries_touched"]:
        indicators["incremental"] = True
        reasons.append("Git evidence: Sorry statements were modified")
    elif "files_changed" in latest_record and latest_record["files_changed"]:
        # Only count as progress if Lean files were actually changed
        lean_files = [f for f in latest_record["files_changed"] if f.endswith('.lean')]
        if lean_files:
            indicators["incremental"] = True
            reasons.append(f"Git evidence: {len(lean_files)} Lean files modified")
    
    # Check build status - this is concrete evidence
    if build_result and "success" in build_result:
        if not build_result["success"]:
            indicators["regressive"] = True
            error_msg = build_result.get("error_summary") or build_result.get("error", "Unknown error")
            reasons.append(f"Build failure: {error_msg}")
        else:
            reasons.append("Build verification passed")
    
    # Determine overall progress level
    if indicators["regressive"]:
        level = "regressive"
    elif indicators["substantial"]:
        level = "substantial" 
    elif indicators["incremental"] and sorry_info.get("recently_modified", False):
        level = "incremental"  # Only incremental if file was actually touched
    else:
        level = "minimal"
        if not any(reasons):
            reasons.append("No concrete evidence of mathematical progress")
    
    return {
        "level": level,
        "reasons": reasons,
        "sorry_count": sorry_info.get("count", "unknown")
    }

def check_session_limits(project_root: Path, sorry_count: int) -> dict:
    """Check if we've hit session iteration limits, but prioritize mathematical completion."""
    state_file = project_root / ".claude" / "iteration_state.json"
    
    try:
        if state_file.exists():
            with open(state_file, 'r') as f:
                state = json.load(f)
        else:
            state = {"iterations": 0, "last_iteration": None}
        
        now = datetime.datetime.now().isoformat()
        
        # MATHEMATICAL PRIORITY: Continue until all sorries are resolved
        if sorry_count > 0:
            # Mathematical work is incomplete - continue regardless of session limits
            state["iterations"] += 1
            state["last_iteration"] = now
            
            # Ensure .claude directory exists
            state_file.parent.mkdir(exist_ok=True)
            
            with open(state_file, 'w') as f:
                json.dump(state, f, indent=2)
            
            return {"blocked": False, "iterations": state["iterations"], "reason": f"Mathematical priority: {sorry_count} sorries remain"}
        
        # Only apply session limits when mathematical work is complete (0 sorries)
        if state["iterations"] >= MAX_ITERATIONS_PER_SESSION:
            return {"blocked": True, "reason": f"Mathematical work complete, session limit reached: {MAX_ITERATIONS_PER_SESSION} iterations"}
        
        # Check time between iterations (only when sorries = 0)
        if state["last_iteration"]:
            last_time = datetime.datetime.fromisoformat(state["last_iteration"])
            time_diff = (datetime.datetime.now() - last_time).total_seconds()
            if time_diff < MIN_SECONDS_BETWEEN_ITERATIONS:
                return {"blocked": True, "reason": f"Mathematical work complete, minimum time limit: {MIN_SECONDS_BETWEEN_ITERATIONS}s between iterations"}
        
        # Update state
        state["iterations"] += 1
        state["last_iteration"] = now
        
        # Ensure .claude directory exists
        state_file.parent.mkdir(exist_ok=True)
        
        with open(state_file, 'w') as f:
            json.dump(state, f, indent=2)
        
        return {"blocked": False, "iterations": state["iterations"]}
        
    except Exception as e:
        return {"blocked": True, "reason": f"Session state error: {e}"}

def generate_continuation_reason(progress: dict, sorry_info: dict, sorry_analysis: dict = None, attempt_info: dict = None) -> str:
    """Generate a clinical continuation reason based on progress assessment."""
    
    sorry_count = sorry_info.get("count", "unknown")
    progress_level = progress["level"]
    reasons = progress["reasons"]
    
    if progress_level == "regressive":
        return f"Halt iteration: {'; '.join(reasons)}. Require manual intervention."
    
    # Check if we should pause due to repeated attempts
    if attempt_info and attempt_info.get("should_pause"):
        return f"Pause iteration: {attempt_info.get('reason')}. Consider alternative approach or external research."
    
    # Build continuation message
    if progress_level == "substantial":
        base_msg = f"Continue iteration: {'; '.join(reasons)}."
    elif progress_level == "incremental":
        base_msg = f"Continue iteration: {'; '.join(reasons)}."
    else:
        base_msg = "Continue iteration: Minimal progress requires mathematical advancement."
    
    # Add specific guidance based on sorry analysis
    if sorry_analysis and "recommendation" in sorry_analysis:
        guidance = f" Strategy: {sorry_analysis['recommendation']}"
    elif sorry_count == 2:
        guidance = " Focus: resolve summable_factorial_diff and factorial_telescoping_sum_one in TelescopingSeries.lean."
    elif sorry_count == 1:
        guidance = " Focus: complete final sorry in TelescopingSeries.lean."
    elif sorry_count == 0:
        guidance = " Focus: integrate completed TelescopingSeries into main theorem."
    else:
        guidance = f" Focus: reduce {sorry_count} sorries in TelescopingSeries.lean."
    
    # Add attempt count if relevant
    if attempt_info and "attempts" in attempt_info and attempt_info["attempts"] > 1:
        guidance += f" (Attempt {attempt_info['attempts']}/5 for current sorry configuration)"
    
    return base_msg + guidance

def update_claude_md_status(project_root: Path, sorry_info: dict) -> None:
    """Update CLAUDE.md with current mathematical reality."""
    claude_md = project_root / "CLAUDE.md"
    
    if not claude_md.exists():
        return
    
    try:
        with open(claude_md, 'r', encoding='utf-8') as f:
            content = f.read()
        
        sorry_count = sorry_info.get("count", "unknown")
        
        # Update sorry count in the progress section
        pattern = r'(- ⚠️ \*\*Core Challenge\*\*: )\d+( mathematical sorries remain in TelescopingSeries\.lean)'
        replacement = f'\\g<1>{sorry_count}\\g<2>'
        
        if re.search(pattern, content):
            content = re.sub(pattern, replacement, content)
            
            with open(claude_md, 'w', encoding='utf-8') as f:
                f.write(content)
    
    except Exception as e:
        # Don't block iteration for documentation update failures
        pass

def main():
    """Main hook logic."""
    try:
        input_data = json.load(sys.stdin)
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON input: {e}", file=sys.stderr)
        sys.exit(1)
    
    # Check if hook is disabled by user
    if not HOOK_ENABLED:
        # User disabled hook - don't block Stop
        sys.exit(0)
    
    # Verify project context
    cwd = input_data.get("cwd", "")
    if not verify_project_context(cwd):
        # Silent exit - we're not in the right project
        sys.exit(0)
    
    project_root = get_project_root(cwd)
    
    # Analyze current state first to get sorry count
    latest_record = parse_iteration_history(project_root)
    if "error" in latest_record:
        sys.exit(0)  # Can't analyze, don't continue
    
    sorry_info = count_current_sorries(project_root)
    if "error" in sorry_info:
        sys.exit(0)  # Can't analyze, don't continue
    
    # NEW: Verify build status directly
    build_result = verify_build_status(project_root)
    
    # NEW: Track sorry attempts to prevent infinite loops
    attempt_info = track_sorry_attempts(project_root, sorry_info)
    if attempt_info.get("should_pause", False):
        # Don't continue - need alternative approach
        output = {
            "decision": "allow",  # Allow stop when stuck
            "reason": attempt_info.get("reason", "Repeated attempts on same sorry")
        }
        print(json.dumps(output))
        sys.exit(0)
    
    # NEW: Analyze sorry difficulty for strategic guidance
    sorry_analysis = None
    if sorry_info.get("locations"):
        sorry_analysis = analyze_sorry_context(project_root, sorry_info["locations"])
    
    # Check session limits with mathematical priority
    sorry_count = sorry_info.get("count", 0)
    session_check = check_session_limits(project_root, sorry_count)
    if session_check.get("blocked", False):
        # Don't continue - session limits reached (only when sorries = 0)
        sys.exit(0)
    
    # Assess progress with build result
    progress = assess_mathematical_progress(latest_record, sorry_info, build_result)
    
    # Don't continue on regressive progress
    if progress["level"] == "regressive":
        sys.exit(0)
    
    # Update documentation
    update_claude_md_status(project_root, sorry_info)
    
    # Generate continuation reason with enhanced context
    reason = generate_continuation_reason(progress, sorry_info, sorry_analysis, attempt_info)
    
    # Return structured decision to continue
    output = {
        "decision": "block",
        "reason": f"execute next iteration\n\n{reason}"
    }
    
    print(json.dumps(output))
    sys.exit(0)

if __name__ == "__main__":
    main()
