#!/usr/bin/env python3
"""
Lean 4 Error Instruction Generator

Provides step-by-step instructions for Claude Code to systematically fix
different types of Lean 4 errors based on error analysis.
"""

from dataclasses import dataclass
from typing import List, Dict, Any, Optional
from enum import Enum
import re

from lean_error_analyzer import LeanError, ErrorType, Severity


@dataclass
class FixStep:
    """Represents a single step in fixing an error"""
    step_number: int
    action: str
    description: str
    verification: str
    fallback: Optional[str] = None
    requires_leanexplore: bool = False


@dataclass
class FixStrategy:
    """Complete strategy for fixing a specific error"""
    error_type: ErrorType
    title: str
    overview: str
    steps: List[FixStep]
    verification_command: str
    common_pitfalls: List[str]
    success_criteria: str


class InstructionGenerator:
    """Generates systematic fix instructions for different error types"""
    
    def __init__(self):
        self.strategies = {
            ErrorType.TYPE_MISMATCH: self._create_type_mismatch_strategy(),
            ErrorType.TACTIC_FAILURE: self._create_tactic_failure_strategy(), 
            ErrorType.STYLE_WARNING: self._create_style_warning_strategy(),
            ErrorType.SORRY_DECLARATION: self._create_sorry_strategy(),
            ErrorType.API_ERROR: self._create_api_error_strategy(),
            ErrorType.IMPORT_ERROR: self._create_import_error_strategy(),
        }
    
    def generate_instructions(self, error: LeanError, context: Dict[str, Any] = None) -> FixStrategy:
        """Generate step-by-step instructions for fixing a specific error"""
        strategy = self.strategies.get(error.error_type)
        if not strategy:
            return self._create_generic_strategy(error)
        
        # Customize strategy based on specific error details
        customized_strategy = self._customize_strategy(strategy, error, context)
        return customized_strategy
    
    def generate_batch_instructions(self, errors: List[LeanError], analysis: Dict[str, Any]) -> Dict[str, Any]:
        """Generate instructions for fixing multiple errors systematically"""
        instructions = {
            "overview": self._generate_batch_overview(errors, analysis),
            "fix_plan": self._generate_fix_plan(errors),
            "individual_fixes": [],
            "verification_strategy": self._generate_verification_strategy(errors)
        }
        
        for i, error in enumerate(errors):
            fix_strategy = self.generate_instructions(error)
            instructions["individual_fixes"].append({
                "error_id": i,
                "file": error.file_path,
                "line": error.line,
                "strategy": fix_strategy
            })
        
        return instructions
    
    def _create_type_mismatch_strategy(self) -> FixStrategy:
        """Strategy for fixing type mismatch errors"""
        return FixStrategy(
            error_type=ErrorType.TYPE_MISMATCH,
            title="Fix Type Mismatch Error",
            overview="Type mismatch errors usually involve coercion issues, wrong types, or casting problems.",
            steps=[
                FixStep(
                    step_number=1,
                    action="analyze_types",
                    description="Examine the 'has type' vs 'expected to have type' in the error message",
                    verification="Identify the specific type difference (e.g., ↑n vs n, ℝ vs ℕ)",
                ),
                FixStep(
                    step_number=2,
                    action="check_coercion",
                    description="Look for coercion issues - often involves ↑ symbols or casting between types",
                    verification="Determine if the issue is with Natural → Real casting or similar",
                ),
                FixStep(
                    step_number=3,
                    action="fix_casting",
                    description="Apply appropriate casting or remove unnecessary casting",
                    verification="Common fixes: use Nat.cast, remove parentheses, change cast order",
                    fallback="If casting doesn't work, try simp_rw or conv tactics"
                ),
                FixStep(
                    step_number=4,
                    action="verify_fix",
                    description="Run lake build to confirm the type mismatch is resolved",
                    verification="lake build should complete without the type mismatch error",
                )
            ],
            verification_command="lake build",
            common_pitfalls=[
                "Mixing ↑(n - 1) with ↑n - 1 - parentheses matter for casting",
                "Using wrong coercion functions",
                "Not handling edge cases in type constraints"
            ],
            success_criteria="Types match exactly and compilation succeeds"
        )
    
    def _create_tactic_failure_strategy(self) -> FixStrategy:
        """Strategy for fixing tactic failures"""
        return FixStrategy(
            error_type=ErrorType.TACTIC_FAILURE,
            title="Fix Tactic Failure",
            overview="Tactic failures often indicate API changes, missing imports, or incorrect usage.",
            steps=[
                FixStep(
                    step_number=1,
                    action="identify_tactic",
                    description="Identify which tactic failed from the error message",
                    verification="Extract tactic name from 'tactic 'X' failed' message",
                ),
                FixStep(
                    step_number=2,
                    action="check_api_availability",
                    description="Verify the tactic/API still exists in current mathlib version",
                    verification="Use LeanExplore to search for the tactic or API function",
                    requires_leanexplore=True
                ),
                FixStep(
                    step_number=3,
                    action="update_or_replace",
                    description="Either update the syntax or replace with modern equivalent",
                    verification="Apply the correct syntax or modern replacement tactic",
                    fallback="Try alternative tactics like simp, rw, apply, exact"
                ),
                FixStep(
                    step_number=4,
                    action="verify_fix",
                    description="Run lake build to confirm tactic works",
                    verification="lake build should complete without tactic failure",
                )
            ],
            verification_command="lake build",
            common_pitfalls=[
                "Using deprecated tactic syntax",
                "Missing required imports for tactics",
                "Wrong tactic for the goal type"
            ],
            success_criteria="Tactic executes successfully and proof progresses"
        )
    
    def _create_style_warning_strategy(self) -> FixStrategy:
        """Strategy for fixing style warnings"""
        return FixStrategy(
            error_type=ErrorType.STYLE_WARNING,
            title="Fix Style Warning",
            overview="Style warnings indicate deprecated or discouraged patterns that should be modernized.",
            steps=[
                FixStep(
                    step_number=1,
                    action="identify_deprecated_pattern",
                    description="Identify the deprecated tactic or pattern from the warning",
                    verification="Look for 'is discouraged' message and suggested replacements",
                ),
                FixStep(
                    step_number=2,
                    action="apply_suggestion",
                    description="Replace deprecated pattern with suggested modern equivalent",
                    verification="Use the exact suggestion from the warning message",
                ),
                FixStep(
                    step_number=3,
                    action="verify_functionality",
                    description="Ensure the replacement works the same way",
                    verification="Build should succeed and proof logic should be unchanged",
                ),
            ],
            verification_command="lake build",
            common_pitfalls=[
                "Changing logic instead of just syntax",
                "Not handling all cases when replacing tactics"
            ],
            success_criteria="Warning disappears and functionality is preserved"
        )
    
    def _create_sorry_strategy(self) -> FixStrategy:
        """Strategy for completing sorry declarations"""
        return FixStrategy(
            error_type=ErrorType.SORRY_DECLARATION,
            title="Complete Sorry Declaration",
            overview="Sorry declarations are incomplete proofs that need mathematical completion.",
            steps=[
                FixStep(
                    step_number=1,
                    action="analyze_goal",
                    description="Understand what needs to be proven at the sorry location",
                    verification="Read the theorem statement and context to understand the goal",
                ),
                FixStep(
                    step_number=2,
                    action="check_mathematical_validity",
                    description="Verify the mathematical statement is actually true",
                    verification="Ensure the theorem makes mathematical sense",
                ),
                FixStep(
                    step_number=3,
                    action="search_existing_lemmas",
                    description="Search for existing lemmas that might complete the proof",
                    verification="Use LeanExplore to find relevant mathlib lemmas",
                    requires_leanexplore=True
                ),
                FixStep(
                    step_number=4,
                    action="implement_proof",
                    description="Implement the actual proof using available tactics and lemmas",
                    verification="Replace sorry with working proof tactics",
                    fallback="If proof is complex, break into smaller helper lemmas"
                ),
                FixStep(
                    step_number=5,
                    action="verify_proof",
                    description="Ensure the proof compiles and is mathematically sound",
                    verification="lake build should succeed without the sorry",
                )
            ],
            verification_command="lake build",
            common_pitfalls=[
                "Attempting to prove false statements",
                "Missing key mathematical insights",
                "Over-complicating simple proofs"
            ],
            success_criteria="Sorry is replaced with complete, valid proof"
        )
    
    def _create_api_error_strategy(self) -> FixStrategy:
        """Strategy for fixing API errors"""
        return FixStrategy(
            error_type=ErrorType.API_ERROR,
            title="Fix API Error",
            overview="API errors indicate missing or changed functions, often due to mathlib updates.",
            steps=[
                FixStep(
                    step_number=1,
                    action="identify_missing_api",
                    description="Identify the specific function or identifier that's not found",
                    verification="Extract the unknown identifier from error message",
                ),
                FixStep(
                    step_number=2,
                    action="search_current_api",
                    description="Search for the current name/location of the API in mathlib",
                    verification="Use LeanExplore to find the correct API name and import",
                    requires_leanexplore=True
                ),
                FixStep(
                    step_number=3,
                    action="update_usage",
                    description="Update the code to use the correct API name and import",
                    verification="Add correct import and update function calls",
                ),
                FixStep(
                    step_number=4,
                    action="verify_fix",
                    description="Ensure the API usage works correctly",
                    verification="lake build should succeed with corrected API usage",
                )
            ],
            verification_command="lake build",
            common_pitfalls=[
                "Using hallucinated API names",
                "Wrong import statements",
                "Incorrect function signatures"
            ],
            success_criteria="API resolves correctly and functionality works"
        )
    
    def _create_import_error_strategy(self) -> FixStrategy:
        """Strategy for fixing import errors"""
        return FixStrategy(
            error_type=ErrorType.IMPORT_ERROR,
            title="Fix Import Error",
            overview="Import errors indicate missing or incorrect import statements.",
            steps=[
                FixStep(
                    step_number=1,
                    action="identify_missing_import",
                    description="Identify what module or namespace is missing",
                    verification="Look for 'not found' or 'unknown namespace' in error",
                ),
                FixStep(
                    step_number=2,
                    action="find_correct_import",
                    description="Find the correct import path for the needed functionality",
                    verification="Use LeanExplore to find correct module name",
                    requires_leanexplore=True
                ),
                FixStep(
                    step_number=3,
                    action="add_import",
                    description="Add the correct import statement",
                    verification="Add import at top of file with correct syntax",
                ),
                FixStep(
                    step_number=4,
                    action="verify_import",
                    description="Ensure import resolves and provides needed functionality",
                    verification="lake build should succeed with new import",
                )
            ],
            verification_command="lake build",
            common_pitfalls=[
                "Wrong module paths",
                "Circular imports",
                "Unnecessary imports"
            ],
            success_criteria="Import resolves and provides needed functionality"
        )
    
    def _create_generic_strategy(self, error: LeanError) -> FixStrategy:
        """Fallback strategy for unknown error types"""
        return FixStrategy(
            error_type=error.error_type,
            title="Fix Unknown Error",
            overview="This error type is not recognized. Manual analysis required.",
            steps=[
                FixStep(
                    step_number=1,
                    action="analyze_error_message",
                    description="Carefully read the error message to understand the issue",
                    verification="Identify key terms and patterns in the error",
                ),
                FixStep(
                    step_number=2,
                    action="research_solution",
                    description="Research the error pattern using available resources",
                    verification="Use documentation, LeanExplore, or community resources",
                    requires_leanexplore=True
                ),
                FixStep(
                    step_number=3,
                    action="implement_fix",
                    description="Apply the researched solution",
                    verification="Make targeted changes based on research",
                ),
                FixStep(
                    step_number=4,
                    action="verify_fix",
                    description="Test the fix thoroughly",
                    verification="lake build should succeed",
                )
            ],
            verification_command="lake build",
            common_pitfalls=["Making changes without understanding the root cause"],
            success_criteria="Error is resolved through careful analysis and research"
        )
    
    def _customize_strategy(self, strategy: FixStrategy, error: LeanError, context: Dict[str, Any] = None) -> FixStrategy:
        """Customize strategy based on specific error details"""
        # Add specific context to steps based on error content
        customized_steps = []
        
        for step in strategy.steps:
            new_step = FixStep(
                step_number=step.step_number,
                action=step.action,
                description=step.description,
                verification=step.verification,
                fallback=step.fallback,
                requires_leanexplore=step.requires_leanexplore
            )
            
            # Add specific details based on error content
            if error.error_type == ErrorType.TYPE_MISMATCH and "cast" in error.message.lower():
                if step.action == "fix_casting":
                    new_step.description += f" (Specific issue: {self._extract_type_mismatch_details(error)})"
            
            if error.error_type == ErrorType.STYLE_WARNING and "cases'" in error.message:
                if step.action == "apply_suggestion":
                    new_step.description += " (Replace 'cases'' with 'obtain', 'rcases', or 'cases')"
            
            customized_steps.append(new_step)
        
        return FixStrategy(
            error_type=strategy.error_type,
            title=strategy.title,
            overview=strategy.overview,
            steps=customized_steps,
            verification_command=strategy.verification_command,
            common_pitfalls=strategy.common_pitfalls,
            success_criteria=strategy.success_criteria
        )
    
    def _extract_type_mismatch_details(self, error: LeanError) -> str:
        """Extract specific details about type mismatch"""
        lines = error.message.split('\n')
        for i, line in enumerate(lines):
            if "has type" in line and i + 2 < len(lines):
                has_type = lines[i + 1].strip()
                expected_type = lines[i + 3].strip() if i + 3 < len(lines) else ""
                return f"Expected '{expected_type}' but got '{has_type}'"
        return "Type casting issue detected"
    
    def _generate_batch_overview(self, errors: List[LeanError], analysis: Dict[str, Any]) -> str:
        """Generate overview for batch error fixing"""
        total = len(errors)
        critical = len([e for e in errors if e.severity == Severity.CRITICAL])
        high = len([e for e in errors if e.severity == Severity.HIGH])
        
        overview = f"📋 Batch Error Fixing Plan ({total} issues)\n\n"
        
        if critical > 0:
            overview += f"🚨 Priority 1: Fix {critical} critical errors that block compilation\n"
        if high > 0:
            overview += f"🔧 Priority 2: Address {high} high-priority issues\n"
        
        overview += "\n💡 Strategy: Fix errors in dependency order to avoid cascading failures"
        return overview
    
    def _generate_fix_plan(self, errors: List[LeanError]) -> List[Dict[str, Any]]:
        """Generate systematic fix plan"""
        plan = []
        
        # Group by file to batch fixes efficiently
        by_file = {}
        for error in errors:
            if error.file_path not in by_file:
                by_file[error.file_path] = []
            by_file[error.file_path].append(error)
        
        for file_path, file_errors in by_file.items():
            # Sort by line number for systematic fixing
            file_errors.sort(key=lambda e: e.line)
            
            plan.append({
                "file": file_path,
                "error_count": len(file_errors),
                "approach": "Fix errors from top to bottom to maintain line number accuracy",
                "errors": [
                    {
                        "line": e.line,
                        "type": e.error_type.value,
                        "severity": e.severity.value
                    }
                    for e in file_errors
                ]
            })
        
        return plan
    
    def _generate_verification_strategy(self, errors: List[LeanError]) -> Dict[str, Any]:
        """Generate verification strategy for batch fixes"""
        return {
            "approach": "Incremental verification after each fix",
            "commands": [
                "lake build [target] - after each individual fix",
                "lake build - full verification after all fixes",
                "git status - track what was actually changed"
            ],
            "rollback_plan": "Use git to rollback if any fix introduces new errors",
            "success_criteria": "All targeted errors eliminated, no new errors introduced"
        }