#!/usr/bin/env python3
"""
Lean 4 Build Error Analysis and Systematic Correction Tool

This tool parses lake build output, categorizes errors, and provides
step-by-step instructions for Claude Code to systematically fix Lean 4 issues.
"""

import re
import subprocess
import sys
from dataclasses import dataclass
from enum import Enum
from pathlib import Path
from typing import List, Optional, Dict, Any
import json


class ErrorType(Enum):
    """Categories of Lean 4 build errors"""
    TYPE_MISMATCH = "type_mismatch"
    TACTIC_FAILURE = "tactic_failure"
    API_ERROR = "api_error"
    STYLE_WARNING = "style_warning"
    SORRY_DECLARATION = "sorry_declaration"
    IMPORT_ERROR = "import_error"
    SYNTAX_ERROR = "syntax_error"
    UNKNOWN = "unknown"


class Severity(Enum):
    """Error severity levels"""
    CRITICAL = "critical"  # Blocks compilation
    HIGH = "high"         # Affects correctness
    MEDIUM = "medium"     # Style/performance
    LOW = "low"          # Warnings only


@dataclass
class LeanError:
    """Represents a single Lean 4 error or warning"""
    file_path: str
    line: int
    column: int
    error_type: ErrorType
    severity: Severity
    message: str
    raw_output: str
    context_lines: Optional[List[str]] = None
    suggested_fixes: Optional[List[str]] = None


class LeanErrorParser:
    """Parses lake build output and extracts structured error information"""
    
    def __init__(self, project_root: Path):
        self.project_root = project_root
        
        # Regex patterns for different error types
        self.patterns = {
            'location': re.compile(r'([^:]+):(\d+):(\d+):'),
            'type_mismatch': re.compile(r'type mismatch|has type.*but is expected to have type', re.IGNORECASE),
            'tactic_failure': re.compile(r"tactic '([^']+)' failed", re.IGNORECASE),
            'sorry': re.compile(r"declaration uses 'sorry'", re.IGNORECASE),
            'style_warning': re.compile(r'The `([^`]+)` tactic is discouraged|linter\.style\.', re.IGNORECASE),
            'api_error': re.compile(r'unknown identifier|failed to synthesize|function expected', re.IGNORECASE),
            'import_error': re.compile(r'file .*\.lean not found|unknown namespace', re.IGNORECASE),
        }
    
    def parse_build_output(self, output: str) -> List[LeanError]:
        """Parse lake build output and return structured errors"""
        errors = []
        lines = output.split('\n')
        
        i = 0
        while i < len(lines):
            line = lines[i].strip()
            
            # Skip trace and build status lines
            if line.startswith('trace:') or line.startswith('✖') or line.startswith('Some required builds'):
                i += 1
                continue
                
            # Look for error/warning location pattern
            location_match = self.patterns['location'].search(line)
            if location_match:
                error = self._parse_error_at_location(lines, i, location_match)
                if error:
                    errors.append(error)
            
            i += 1
        
        return errors
    
    def _parse_error_at_location(self, lines: List[str], line_idx: int, location_match) -> Optional[LeanError]:
        """Parse a single error starting at the given location"""
        file_path = location_match.group(1)
        line_num = int(location_match.group(2))
        column_num = int(location_match.group(3))
        
        # Gather the full error message
        error_lines = [lines[line_idx]]
        i = line_idx + 1
        
        # Continue reading until we hit another location or empty line
        while i < len(lines) and lines[i].strip():
            next_line = lines[i].strip()
            # Stop if we hit another error location
            if self.patterns['location'].search(next_line):
                break
            error_lines.append(next_line)
            i += 1
        
        message = '\n'.join(error_lines)
        error_type = self._categorize_error(message)
        severity = self._determine_severity(message, error_type)
        
        return LeanError(
            file_path=file_path,
            line=line_num,
            column=column_num,
            error_type=error_type,
            severity=severity,
            message=message.strip(),
            raw_output=message
        )
    
    def _categorize_error(self, message: str) -> ErrorType:
        """Categorize error by analyzing the message content"""
        if self.patterns['sorry'].search(message):
            return ErrorType.SORRY_DECLARATION
        elif self.patterns['type_mismatch'].search(message):
            return ErrorType.TYPE_MISMATCH
        elif self.patterns['tactic_failure'].search(message):
            return ErrorType.TACTIC_FAILURE
        elif self.patterns['style_warning'].search(message):
            return ErrorType.STYLE_WARNING
        elif self.patterns['api_error'].search(message):
            return ErrorType.API_ERROR
        elif self.patterns['import_error'].search(message):
            return ErrorType.IMPORT_ERROR
        elif 'error:' in message.lower():
            return ErrorType.SYNTAX_ERROR
        else:
            return ErrorType.UNKNOWN
    
    def _determine_severity(self, message: str, error_type: ErrorType) -> Severity:
        """Determine severity based on error type and message content"""
        if 'error:' in message.lower():
            return Severity.CRITICAL
        elif error_type == ErrorType.SORRY_DECLARATION:
            return Severity.HIGH
        elif error_type == ErrorType.STYLE_WARNING:
            return Severity.MEDIUM
        elif 'warning:' in message.lower():
            return Severity.LOW
        else:
            return Severity.HIGH


class ContextExtractor:
    """Extracts code context around error locations"""
    
    def __init__(self, project_root: Path):
        self.project_root = project_root
    
    def extract_context(self, error: LeanError, context_lines: int = 5) -> List[str]:
        """Extract context lines around the error location"""
        try:
            file_path = self.project_root / error.file_path
            if not file_path.exists():
                return []
                
            with open(file_path, 'r', encoding='utf-8') as f:
                lines = f.readlines()
            
            start_line = max(0, error.line - context_lines - 1)
            end_line = min(len(lines), error.line + context_lines)
            
            context = []
            for i in range(start_line, end_line):
                prefix = ">>>" if i == error.line - 1 else "   "
                context.append(f"{prefix} {i+1:3d}: {lines[i].rstrip()}")
            
            return context
            
        except Exception as e:
            return [f"Error reading context: {e}"]


class LeanErrorAnalyzer:
    """Main analyzer that coordinates parsing, analysis, and instruction generation"""
    
    def __init__(self, project_root: Path = None):
        self.project_root = project_root or Path.cwd()
        self.parser = LeanErrorParser(self.project_root)
        self.context_extractor = ContextExtractor(self.project_root)
    
    def analyze_build(self, target: str = None) -> Dict[str, Any]:
        """Run lake build and analyze all errors"""
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
            build_output = result.stderr + result.stdout
        except Exception as e:
            return {"error": f"Failed to run lake build: {e}"}
        
        # Parse errors
        errors = self.parser.parse_build_output(build_output)
        
        # Add context to each error
        for error in errors:
            error.context_lines = self.context_extractor.extract_context(error)
        
        # Categorize and prioritize
        analysis = self._analyze_errors(errors)
        analysis["raw_output"] = build_output
        
        return analysis
    
    def _analyze_errors(self, errors: List[LeanError]) -> Dict[str, Any]:
        """Analyze errors and provide systematic correction strategy"""
        # Group by severity and type
        by_severity = {}
        by_type = {}
        by_file = {}
        
        for error in errors:
            # Group by severity
            if error.severity not in by_severity:
                by_severity[error.severity] = []
            by_severity[error.severity].append(error)
            
            # Group by type
            if error.error_type not in by_type:
                by_type[error.error_type] = []
            by_type[error.error_type].append(error)
            
            # Group by file
            if error.file_path not in by_file:
                by_file[error.file_path] = []
            by_file[error.file_path].append(error)
        
        # Generate fix priority order
        fix_order = self._generate_fix_order(errors)
        
        return {
            "total_errors": len(errors),
            "by_severity": {sev.value: len(errs) for sev, errs in by_severity.items()},
            "by_type": {typ.value: len(errs) for typ, errs in by_type.items()},
            "by_file": {file: len(errs) for file, errs in by_file.items()},
            "errors": [self._error_to_dict(err) for err in errors],
            "fix_order": fix_order,
            "recommendations": self._generate_recommendations(errors)
        }
    
    def _generate_fix_order(self, errors: List[LeanError]) -> List[Dict[str, Any]]:
        """Generate recommended fix order based on dependencies and impact"""
        # Sort by severity first, then by type priority
        type_priority = {
            ErrorType.IMPORT_ERROR: 1,
            ErrorType.API_ERROR: 2, 
            ErrorType.TYPE_MISMATCH: 3,
            ErrorType.TACTIC_FAILURE: 4,
            ErrorType.SYNTAX_ERROR: 5,
            ErrorType.STYLE_WARNING: 6,
            ErrorType.SORRY_DECLARATION: 7,
            ErrorType.UNKNOWN: 8
        }
        
        severity_priority = {
            Severity.CRITICAL: 1,
            Severity.HIGH: 2,
            Severity.MEDIUM: 3,
            Severity.LOW: 4
        }
        
        sorted_errors = sorted(
            errors,
            key=lambda e: (
                severity_priority.get(e.severity, 5),
                type_priority.get(e.error_type, 9),
                e.line
            )
        )
        
        return [
            {
                "error_id": i,
                "file": err.file_path,
                "line": err.line,
                "type": err.error_type.value,
                "severity": err.severity.value,
                "summary": err.message.split('\n')[0][:100]
            }
            for i, err in enumerate(sorted_errors)
        ]
    
    def _generate_recommendations(self, errors: List[LeanError]) -> List[str]:
        """Generate high-level recommendations for fixing the errors"""
        recommendations = []
        
        critical_errors = [e for e in errors if e.severity == Severity.CRITICAL]
        if critical_errors:
            recommendations.append(f"🚨 Fix {len(critical_errors)} critical errors first to restore compilation")
        
        type_mismatches = [e for e in errors if e.error_type == ErrorType.TYPE_MISMATCH]
        if type_mismatches:
            recommendations.append(f"🔧 Address {len(type_mismatches)} type mismatch issues (likely coercion problems)")
        
        tactic_failures = [e for e in errors if e.error_type == ErrorType.TACTIC_FAILURE]
        if tactic_failures:
            recommendations.append(f"⚡ Fix {len(tactic_failures)} tactic failures (may need API updates)")
        
        style_warnings = [e for e in errors if e.error_type == ErrorType.STYLE_WARNING]
        if style_warnings:
            recommendations.append(f"✨ Clean up {len(style_warnings)} style warnings when critical issues are resolved")
        
        return recommendations
    
    def _error_to_dict(self, error: LeanError) -> Dict[str, Any]:
        """Convert LeanError to dictionary for JSON serialization"""
        return {
            "file_path": error.file_path,
            "line": error.line,
            "column": error.column,
            "error_type": error.error_type.value,
            "severity": error.severity.value,
            "message": error.message,
            "context_lines": error.context_lines or [],
            "suggested_fixes": error.suggested_fixes or []
        }


def main():
    """CLI entry point"""
    import argparse
    
    parser = argparse.ArgumentParser(description="Analyze Lean 4 build errors systematically")
    parser.add_argument("target", nargs="?", help="Specific build target (optional)")
    parser.add_argument("--json", action="store_true", help="Output as JSON")
    parser.add_argument("--project-root", type=Path, help="Project root directory")
    
    args = parser.parse_args()
    
    analyzer = LeanErrorAnalyzer(args.project_root)
    analysis = analyzer.analyze_build(args.target)
    
    if args.json:
        print(json.dumps(analysis, indent=2))
    else:
        # Human-readable output
        print(f"🔍 Lean 4 Build Analysis")
        print(f"━━━━━━━━━━━━━━━━━━━━━━━━")
        print(f"Total Issues: {analysis['total_errors']}")
        
        if analysis['total_errors'] > 0:
            print(f"\n📊 Breakdown by Severity:")
            for severity, count in analysis['by_severity'].items():
                print(f"  {severity.upper()}: {count}")
            
            print(f"\n📝 Recommendations:")
            for rec in analysis['recommendations']:
                print(f"  {rec}")
            
            print(f"\n🔧 Suggested Fix Order:")
            for i, fix in enumerate(analysis['fix_order'][:5], 1):  # Show top 5
                print(f"  {i}. {fix['file']}:{fix['line']} - {fix['type']} ({fix['severity']})")
                print(f"     {fix['summary']}")


if __name__ == "__main__":
    main()