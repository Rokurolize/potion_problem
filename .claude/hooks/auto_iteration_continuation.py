#!/usr/bin/env python3
"""
Aphrodisiac Problem Auto-Iteration Continuation Hook
==================================================

This project-specific hook automatically continues iterations after each Stop event
to maintain systematic progress toward completing the formal proof of E[τ] = e.

SAFETY: Only operates within the potion_problem project directory.
"""

import json
import re
import sys
import os
import subprocess
import datetime
from pathlib import Path

# Project safety verification
PROJECT_NAME = "potion_problem"
MAX_ITERATIONS_PER_SESSION = 3
MIN_SECONDS_BETWEEN_ITERATIONS = 60

def verify_project_context(cwd: str) -> bool:
    """Ensure we're operating in the correct project directory."""
    return PROJECT_NAME in cwd and cwd.endswith(PROJECT_NAME)

def get_project_root(cwd: str) -> Path:
    """Get the project root directory."""
    return Path(cwd)

def parse_iteration_history(project_root: Path) -> dict:
    """Parse the latest iteration from iteration-history.md."""
    history_file = project_root / "docs" / "state" / "iteration-history.md"
    
    if not history_file.exists():
        return {"error": "iteration-history.md not found"}
    
    try:
        with open(history_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Find the latest implementation record
        records = re.findall(r'## Implementation Record \(([^)]+)\)\n(.*?)(?=\n## |$)', content, re.DOTALL)
        
        if not records:
            return {"error": "No implementation records found"}
        
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
        return {"error": f"Failed to parse iteration history: {e}"}

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
        
        return {
            "count": sorry_count,
            "locations": sorry_locations
        }
        
    except Exception as e:
        return {"error": f"Failed to count sorries: {e}"}

def assess_mathematical_progress(latest_record: dict, sorry_info: dict) -> dict:
    """Clinically assess the mathematical progress made."""
    
    # Progress indicators
    indicators = {
        "substantial": False,
        "incremental": False,
        "minimal": False,
        "regressive": False
    }
    
    reasons = []
    
    # Check for sorry resolution
    if "resolved_sorries" in latest_record:
        resolved = latest_record["resolved_sorries"]
        if "None" not in resolved and resolved.strip():
            indicators["substantial"] = True
            reasons.append("Sorry statement resolved")
    
    # Check for helper lemmas or mathematical structures
    if "accomplished" in latest_record:
        accomplished = latest_record["accomplished"].lower()
        if any(term in accomplished for term in ["lemma", "theorem", "helper", "proven"]):
            indicators["substantial"] = True
            reasons.append("Mathematical lemma/theorem added")
        elif any(term in accomplished for term in ["structure", "documentation", "insight"]):
            indicators["incremental"] = True
            reasons.append("Mathematical structure improved")
    
    # Check build status
    if "build_status" in latest_record:
        build_status = latest_record["build_status"].lower()
        if "fail" in build_status or "error" in build_status:
            indicators["regressive"] = True
            reasons.append("Build failure detected")
        elif "successful" in build_status:
            reasons.append("Build remains stable")
    
    # Determine overall progress level
    if indicators["regressive"]:
        level = "regressive"
    elif indicators["substantial"]:
        level = "substantial"
    elif indicators["incremental"]:
        level = "incremental"
    else:
        level = "minimal"
        reasons.append("Only cosmetic changes detected")
    
    return {
        "level": level,
        "reasons": reasons,
        "sorry_count": sorry_info.get("count", "unknown")
    }

def check_session_limits(project_root: Path) -> dict:
    """Check if we've hit session iteration limits."""
    state_file = project_root / ".claude" / "iteration_state.json"
    
    try:
        if state_file.exists():
            with open(state_file, 'r') as f:
                state = json.load(f)
        else:
            state = {"iterations": 0, "last_iteration": None}
        
        now = datetime.datetime.now().isoformat()
        
        # Check iteration count
        if state["iterations"] >= MAX_ITERATIONS_PER_SESSION:
            return {"blocked": True, "reason": f"Maximum {MAX_ITERATIONS_PER_SESSION} iterations per session reached"}
        
        # Check time between iterations
        if state["last_iteration"]:
            last_time = datetime.datetime.fromisoformat(state["last_iteration"])
            time_diff = (datetime.datetime.now() - last_time).total_seconds()
            if time_diff < MIN_SECONDS_BETWEEN_ITERATIONS:
                return {"blocked": True, "reason": f"Minimum {MIN_SECONDS_BETWEEN_ITERATIONS}s between iterations required"}
        
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

def generate_continuation_reason(progress: dict, sorry_info: dict) -> str:
    """Generate a clinical continuation reason based on progress assessment."""
    
    sorry_count = sorry_info.get("count", "unknown")
    progress_level = progress["level"]
    reasons = progress["reasons"]
    
    if progress_level == "regressive":
        return f"Halt iteration: {'; '.join(reasons)}. Require manual intervention."
    
    # Build continuation message
    if progress_level == "substantial":
        base_msg = f"Continue iteration: {'; '.join(reasons)}."
    elif progress_level == "incremental":
        base_msg = f"Continue iteration: {'; '.join(reasons)}."
    else:
        base_msg = "Continue iteration: Minimal progress requires mathematical advancement."
    
    # Add specific guidance
    if sorry_count == 2:
        guidance = " Focus: resolve summable_factorial_diff and factorial_telescoping_sum_one in TelescopingSeries.lean."
    elif sorry_count == 1:
        guidance = " Focus: complete final sorry in TelescopingSeries.lean."
    elif sorry_count == 0:
        guidance = " Focus: integrate completed TelescopingSeries into main theorem."
    else:
        guidance = f" Focus: reduce {sorry_count} sorries in TelescopingSeries.lean."
    
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
    
    # Verify project context
    cwd = input_data.get("cwd", "")
    if not verify_project_context(cwd):
        # Silent exit - we're not in the right project
        sys.exit(0)
    
    project_root = get_project_root(cwd)
    
    # Check session limits first
    session_check = check_session_limits(project_root)
    if session_check.get("blocked", False):
        # Don't continue - session limits reached
        sys.exit(0)
    
    # Analyze current state
    latest_record = parse_iteration_history(project_root)
    if "error" in latest_record:
        sys.exit(0)  # Can't analyze, don't continue
    
    sorry_info = count_current_sorries(project_root)
    if "error" in sorry_info:
        sys.exit(0)  # Can't analyze, don't continue
    
    # Assess progress
    progress = assess_mathematical_progress(latest_record, sorry_info)
    
    # Don't continue on regressive progress
    if progress["level"] == "regressive":
        sys.exit(0)
    
    # Update documentation
    update_claude_md_status(project_root, sorry_info)
    
    # Generate continuation reason
    reason = generate_continuation_reason(progress, sorry_info)
    
    # Return structured decision to continue
    output = {
        "decision": "block",
        "reason": f"execute next iteration\n\n{reason}"
    }
    
    print(json.dumps(output))
    sys.exit(0)

if __name__ == "__main__":
    main()