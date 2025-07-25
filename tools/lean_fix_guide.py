#!/usr/bin/env python3
"""
Lean 4 Fix Guide - Comprehensive Error Analysis and Step-by-Step Instructions

This tool combines error analysis with detailed instruction generation to provide
Claude Code with systematic, step-by-step guidance for fixing Lean 4 errors.
"""

import json
import subprocess
from pathlib import Path
from typing import Dict, Any, List
import argparse

from lean_error_analyzer import LeanErrorAnalyzer, LeanError
from instruction_generator import InstructionGenerator, FixStrategy


class LeanFixGuide:
    """Main orchestrator for error analysis and fix instruction generation"""
    
    def __init__(self, project_root: Path = None):
        self.project_root = project_root or Path.cwd()
        self.analyzer = LeanErrorAnalyzer(self.project_root)
        self.instructor = InstructionGenerator()
    
    def generate_complete_guide(self, target: str = None, output_format: str = "text") -> Dict[str, Any]:
        """Generate complete analysis and fix guide"""
        
        # Step 1: Analyze current build errors
        print("🔍 Analyzing build errors...")
        analysis = self.analyzer.analyze_build(target)
        
        if analysis.get("error"):
            return {"error": analysis["error"]}
        
        if analysis["total_errors"] == 0:
            return {
                "status": "success",
                "message": "🎉 No errors found! Build is successful.",
                "analysis": analysis
            }
        
        # Step 2: Generate fix instructions
        print("📝 Generating fix instructions...")
        errors = [self._dict_to_error(err_dict) for err_dict in analysis["errors"]]
        instructions = self.instructor.generate_batch_instructions(errors, analysis)
        
        # Step 3: Create comprehensive guide
        guide = {
            "analysis": analysis,
            "instructions": instructions,
            "systematic_approach": self._create_systematic_approach(errors, analysis),
            "claude_commands": self._generate_claude_commands(errors, instructions)
        }
        
        return guide
    
    def _dict_to_error(self, error_dict: Dict[str, Any]) -> LeanError:
        """Convert dictionary back to LeanError object"""
        from lean_error_analyzer import ErrorType, Severity
        
        return LeanError(
            file_path=error_dict["file_path"],
            line=error_dict["line"],
            column=error_dict["column"],
            error_type=ErrorType(error_dict["error_type"]),
            severity=Severity(error_dict["severity"]),
            message=error_dict["message"],
            raw_output=error_dict["message"],
            context_lines=error_dict.get("context_lines"),
            suggested_fixes=error_dict.get("suggested_fixes")
        )
    
    def _create_systematic_approach(self, errors: List[LeanError], analysis: Dict[str, Any]) -> Dict[str, Any]:
        """Create systematic approach for Claude Code to follow"""
        return {
            "philosophy": "Fix errors systematically to avoid cascading failures",
            "workflow": [
                "1. 🔍 Analyze: Understand each error thoroughly before fixing",
                "2. 🛠️ Fix: Apply targeted fix for one error at a time", 
                "3. ✅ Verify: Run lake build after each fix to confirm success",
                "4. 📝 Commit: Git commit each successful fix separately",
                "5. 🔄 Repeat: Move to next error in priority order"
            ],
            "priority_order": analysis.get("fix_order", []),
            "verification_strategy": "Incremental builds prevent compound errors"
        }
    
    def _generate_claude_commands(self, errors: List[LeanError], instructions: Dict[str, Any]) -> Dict[str, Any]:
        """Generate specific commands for Claude Code to execute"""
        commands = {
            "initial_assessment": [
                "# Initial Build Assessment",
                f"lake build {errors[0].file_path.split('.')[0] if errors else ''}",
                "# Review error output and confirm analysis"
            ],
            "systematic_fixes": [],
            "verification_commands": [
                "# After each fix:",
                "lake build [target]",
                "git add .",
                "git commit -m 'Fix: [specific error description]'"
            ]
        }
        
        # Generate specific fix commands for each error
        for i, fix_info in enumerate(instructions.get("individual_fixes", [])):
            strategy: FixStrategy = fix_info["strategy"]
            error_location = f"{fix_info['file']}:{fix_info['line']}"
            
            fix_commands = [
                f"# Fix {i+1}: {strategy.title} ({error_location})",
                f"# {strategy.overview}",
                ""
            ]
            
            for step in strategy.steps:
                fix_commands.append(f"## Step {step.step_number}: {step.action}")
                fix_commands.append(f"# {step.description}")
                fix_commands.append(f"# Verification: {step.verification}")
                
                if step.requires_leanexplore:
                    fix_commands.append("# Use: uv run leanexplore search '[relevant terms]'")
                
                if step.fallback:
                    fix_commands.append(f"# Fallback: {step.fallback}")
                
                fix_commands.append("")
            
            fix_commands.extend([
                f"# Verify fix:",
                strategy.verification_command,
                f"# Success criteria: {strategy.success_criteria}",
                "",
                "# If successful, commit:",
                "git add .",
                f"git commit -m 'Fix: {strategy.title} at {error_location}'",
                "# " + "="*50,
                ""
            ])
            
            commands["systematic_fixes"].extend(fix_commands)
        
        return commands
    
    def print_guide(self, guide: Dict[str, Any]):
        """Print comprehensive guide in human-readable format"""
        if guide.get("error"):
            print(f"❌ Error: {guide['error']}")
            return
        
        if guide.get("status") == "success":
            print(guide["message"])
            return
        
        analysis = guide["analysis"]
        instructions = guide["instructions"]
        approach = guide["systematic_approach"]
        
        # Header
        print("═" * 60)
        print("🔧 LEAN 4 COMPREHENSIVE FIX GUIDE")
        print("═" * 60)
        
        # Analysis Summary
        print(f"\n📊 BUILD ANALYSIS")
        print(f"Total Issues: {analysis['total_errors']}")
        for severity, count in analysis['by_severity'].items():
            if count > 0:
                print(f"  {severity.upper()}: {count}")
        
        print(f"\n📋 ISSUE BREAKDOWN")
        for issue_type, count in analysis['by_type'].items():
            if count > 0:
                print(f"  {issue_type.replace('_', ' ').title()}: {count}")
        
        # Recommendations
        if analysis.get("recommendations"):
            print(f"\n💡 RECOMMENDATIONS")
            for rec in analysis["recommendations"]:
                print(f"  {rec}")
        
        # Systematic Approach
        print(f"\n🎯 SYSTEMATIC APPROACH")
        print(f"Philosophy: {approach['philosophy']}")
        print(f"\nWorkflow:")
        for step in approach['workflow']:
            print(f"  {step}")
        
        # Fix Priority Order
        print(f"\n📋 FIX PRIORITY ORDER")
        for i, fix in enumerate(approach['priority_order'][:5], 1):
            print(f"  {i}. {fix['file']}:{fix['line']} - {fix['type']} ({fix['severity']})")
            print(f"     {fix['summary'][:80]}...")
        
        # Detailed Fix Instructions
        print(f"\n🛠️ DETAILED FIX INSTRUCTIONS")
        print("─" * 60)
        
        for i, fix_info in enumerate(instructions['individual_fixes']):
            strategy: FixStrategy = fix_info['strategy']
            print(f"\n🔹 Fix {i+1}: {strategy.title}")
            print(f"   Location: {fix_info['file']}:{fix_info['line']}")
            print(f"   Overview: {strategy.overview}")
            
            print(f"\n   Steps:")
            for step in strategy.steps:
                print(f"     {step.step_number}. {step.action}")
                print(f"        {step.description}")
                if step.requires_leanexplore:
                    print(f"        📡 Requires LeanExplore verification")
                if step.fallback:
                    print(f"        🔄 Fallback: {step.fallback}")
            
            print(f"\n   ⚠️ Common Pitfalls:")
            for pitfall in strategy.common_pitfalls:
                print(f"     • {pitfall}")
            
            print(f"\n   ✅ Success Criteria: {strategy.success_criteria}")
            print(f"   🔍 Verification: {strategy.verification_command}")
        
        # Claude-Specific Commands
        print(f"\n🤖 CLAUDE CODE EXECUTION GUIDE")
        print("─" * 60)
        commands = guide["claude_commands"]
        
        print("\n📋 Initial Assessment:")
        for cmd in commands["initial_assessment"]:
            if cmd.startswith("#"):
                print(f"  {cmd}")
            else:
                print(f"  $ {cmd}")
        
        print("\n🔧 Systematic Fixes:")
        for cmd in commands["systematic_fixes"][:20]:  # Show first part
            if cmd.startswith("#"):
                print(f"  {cmd}")
            elif cmd.strip():
                print(f"  $ {cmd}")
        
        if len(commands["systematic_fixes"]) > 20:
            print(f"  ... (showing first 20 lines, {len(commands['systematic_fixes']) - 20} more available)")
        
        print("\n✅ Verification Commands:")
        for cmd in commands["verification_commands"]:
            if cmd.startswith("#"):
                print(f"  {cmd}")
            else:
                print(f"  $ {cmd}")
        
        print("\n" + "═" * 60)
        print("🎯 Ready for systematic error resolution!")
        print("═" * 60)


def main():
    """CLI entry point"""
    parser = argparse.ArgumentParser(
        description="Generate comprehensive Lean 4 error fix guide for Claude Code"
    )
    parser.add_argument("target", nargs="?", help="Specific build target (optional)")
    parser.add_argument("--json", action="store_true", help="Output as JSON")
    parser.add_argument("--project-root", type=Path, help="Project root directory")
    parser.add_argument("--output", type=Path, help="Save guide to file")
    
    args = parser.parse_args()
    
    guide_generator = LeanFixGuide(args.project_root)
    guide = guide_generator.generate_complete_guide(args.target)
    
    if args.json:
        # Convert strategy objects to dictionaries for JSON serialization
        def strategy_to_dict(obj):
            if hasattr(obj, '__dict__'):
                result = {}
                for key, value in obj.__dict__.items():
                    if hasattr(value, 'value'):  # Handle Enum
                        result[key] = value.value
                    elif isinstance(value, list):
                        result[key] = [strategy_to_dict(item) for item in value]
                    else:
                        result[key] = value
                return result
            return obj
        
        # Convert the guide to JSON-serializable format
        json_guide = json.loads(json.dumps(guide, default=strategy_to_dict))
        output = json.dumps(json_guide, indent=2)
        
        if args.output:
            with open(args.output, 'w') as f:
                f.write(output)
            print(f"Guide saved to {args.output}")
        else:
            print(output)
    else:
        if args.output:
            # Save human-readable format
            import io
            import sys
            old_stdout = sys.stdout
            sys.stdout = buffer = io.StringIO()
            
            guide_generator.print_guide(guide)
            
            output = buffer.getvalue()
            sys.stdout = old_stdout
            
            with open(args.output, 'w') as f:
                f.write(output)
            print(f"Guide saved to {args.output}")
            print("\nPreview:")
            print(output[:500] + "..." if len(output) > 500 else output)
        else:
            guide_generator.print_guide(guide)


if __name__ == "__main__":
    main()