#!/usr/bin/env python3
"""
LeanExplore wrapper optimized for LLM usage with context-aware output.

This wrapper provides:
- Minimal output for no/poor results
- Progressive detail levels based on result count
- Clean, parseable output without decorative elements
- Automatic detail level selection
"""

import subprocess
import json
import sys
import re
import os
from pathlib import Path
from typing import Optional, List, Dict, Any
from enum import Enum


class DetailLevel(Enum):
    MINIMAL = "minimal"      # Just IDs and names
    STANDARD = "standard"    # ID, name, signature, file
    DETAILED = "detailed"    # Full info including docstrings


class LLMLeanExplore:
    def __init__(self):
        self.base_cmd = ["uv", "run", "leanexplore"]
        self.non_existent_file = Path(__file__).parent.parent / "list-of-non-existent-mathlib-apis.md"
        
    def _run_command(self, args: List[str]) -> str:
        """Run a leanexplore command and return raw output."""
        try:
            result = subprocess.run(
                self.base_cmd + args,
                capture_output=True,
                text=True,
                check=True
            )
            return result.stdout
        except subprocess.CalledProcessError as e:
            return f"Error: {e.stderr}"
    
    def _parse_search_output(self, output: str) -> Dict[str, Any]:
        """Parse search output into structured data."""
        results = []
        
        # Extract summary info
        summary_match = re.search(r'Showing (\d+) of (\d+) \(out of (\d+) candidates', output)
        if summary_match:
            shown = int(summary_match.group(1))
            total_available = int(summary_match.group(2))
            candidates = int(summary_match.group(3))
        else:
            shown = total_available = candidates = 0
        
        # Extract each result
        result_blocks = re.split(r'─+\s*Result \d+\s*─+', output)[1:]
        
        for block in result_blocks:
            result = {}
            
            # Extract ID
            id_match = re.search(r'ID:\s*(\d+)', block)
            if id_match:
                result['id'] = id_match.group(1)
            
            # Extract name
            name_match = re.search(r'Name:\s*([^\n]+)', block)
            if name_match:
                result['name'] = name_match.group(1).strip()
            
            # Extract file
            file_match = re.search(r'File:\s*([^\n]+)', block)
            if file_match:
                result['file'] = file_match.group(1).strip()
            
            # Extract code
            code_match = re.search(r'╭─+\s*Code\s*─+╮\n│\s*(.+?)╰─+╯', block, re.DOTALL)
            if code_match:
                code_lines = code_match.group(1).strip().split('\n')
                # Remove box drawing characters
                code_lines = [line.strip('│ ').rstrip() for line in code_lines]
                result['code'] = '\n'.join(code_lines).strip()
            
            # Extract docstring
            doc_match = re.search(r'╭─+\s*Docstring\s*─+╮\n│\s*(.+?)╰─+╯', block, re.DOTALL)
            if doc_match:
                doc_lines = doc_match.group(1).strip().split('\n')
                doc_lines = [line.strip('│ ').rstrip() for line in doc_lines]
                result['docstring'] = '\n'.join(doc_lines).strip()
            
            # Extract informal description
            desc_match = re.search(r'╭─+\s*Informal Description\s*─+╮\n│\s*(.+?)╰─+╯', block, re.DOTALL)
            if desc_match:
                desc_lines = desc_match.group(1).strip().split('\n')
                desc_lines = [line.strip('│ ').rstrip() for line in desc_lines]
                result['informal_description'] = '\n'.join(desc_lines).strip()
            
            if result:
                results.append(result)
        
        return {
            'shown': shown,
            'total_available': total_available,
            'candidates': candidates,
            'results': results
        }
    
    def _determine_detail_level(self, parsed_data: Dict[str, Any], 
                               requested_level: Optional[DetailLevel] = None) -> DetailLevel:
        """Determine appropriate detail level based on results."""
        if requested_level:
            return requested_level
        
        result_count = len(parsed_data['results'])
        
        if result_count == 0:
            return DetailLevel.MINIMAL
        elif result_count == 1:
            return DetailLevel.DETAILED
        elif result_count <= 3:
            return DetailLevel.STANDARD
        else:
            return DetailLevel.MINIMAL
    
    def _format_output(self, parsed_data: Dict[str, Any], detail_level: DetailLevel) -> str:
        """Format output based on detail level."""
        output = []
        
        # Summary line
        if parsed_data['candidates'] == 0:
            output.append("No results found.")
            return '\n'.join(output)
        
        output.append(f"Results: {parsed_data['shown']} shown, {parsed_data['total_available']} available, {parsed_data['candidates']} candidates")
        output.append("")
        
        # Format each result
        for i, result in enumerate(parsed_data['results'], 1):
            if detail_level == DetailLevel.MINIMAL:
                output.append(f"{i}. [{result.get('id', 'N/A')}] {result.get('name', 'N/A')}")
            
            elif detail_level == DetailLevel.STANDARD:
                output.append(f"{i}. ID: {result.get('id', 'N/A')}")
                output.append(f"   Name: {result.get('name', 'N/A')}")
                output.append(f"   File: {result.get('file', 'N/A')}")
                if 'code' in result:
                    # Show just the first line of code
                    first_line = result['code'].split('\n')[0]
                    output.append(f"   Signature: {first_line}")
                output.append("")
            
            elif detail_level == DetailLevel.DETAILED:
                output.append(f"=== Result {i} ===")
                output.append(f"ID: {result.get('id', 'N/A')}")
                output.append(f"Name: {result.get('name', 'N/A')}")
                output.append(f"File: {result.get('file', 'N/A')}")
                
                if 'code' in result:
                    output.append("\nCode:")
                    output.append(result['code'])
                
                if 'docstring' in result:
                    output.append("\nDocstring:")
                    output.append(result['docstring'])
                
                if 'informal_description' in result:
                    output.append("\nDescription:")
                    output.append(result['informal_description'])
                
                output.append("")
        
        return '\n'.join(output)
    
    def _is_likely_non_existent(self, query: str, parsed_data: Dict[str, Any]) -> bool:
        """Determine if search results indicate the API doesn't exist."""
        # No candidates at all
        if parsed_data['candidates'] == 0:
            return True
        
        # Check if results are relevant to the query
        query_lower = query.lower()
        query_parts = set(re.findall(r'\w+', query_lower))
        
        # If we have results, check if any are actually relevant
        relevant_count = 0
        for result in parsed_data['results'][:5]:  # Check first 5 results
            result_name = result.get('name', '').lower()
            result_parts = set(re.findall(r'\w+', result_name))
            
            # Check for overlap between query and result
            if query_parts.intersection(result_parts):
                relevant_count += 1
        
        # If very few relevant results compared to query complexity
        if len(query_parts) >= 2 and relevant_count == 0:
            return True
            
        return False
    
    def _check_already_listed(self, query: str) -> bool:
        """Check if query pattern is already in the non-existent list."""
        if not self.non_existent_file.exists():
            return False
            
        content = self.non_existent_file.read_text()
        # Simple check - could be enhanced with pattern matching
        return query in content or query.replace('.', r'\.') in content
    
    def _append_non_existent(self, query: str, package: Optional[str]) -> None:
        """Append a non-existent API to the list."""
        # Check if already listed
        if self._check_already_listed(query):
            return
            
        # Prepare the entry
        timestamp = subprocess.run(['date', '+%Y-%m-%d'], capture_output=True, text=True).stdout.strip()
        
        entry = f"\n{self._get_existing_entries() + 1}. **`{query}`** - Not found in mathlib4\n"
        entry += f"   - **Search context**: Searched"
        if package:
            entry += f" in package {package}"
        entry += f" on {timestamp}\n"
        entry += "   - **Implication**: Consider alternative approaches or verify the API name\n"
        
        # Append to file
        with open(self.non_existent_file, 'a') as f:
            f.write(entry)
    
    def _get_existing_entries(self) -> int:
        """Get count of existing entries for numbering."""
        if not self.non_existent_file.exists():
            return 0
            
        content = self.non_existent_file.read_text()
        # Count numbered entries - look for patterns like "28. **`"
        matches = re.findall(r'^(\d+)\.\s+\*\*`', content, re.MULTILINE)
        if matches:
            # Return the highest number found
            return max(int(m) for m in matches)
        return 0
    
    def search(self, query: str, limit: int = 10, 
               detail: Optional[str] = None, 
               package: Optional[str] = None) -> str:
        """Search with context-aware output."""
        args = ["search", query, "--limit", str(limit)]
        
        if package:
            args.extend(["--package", package])
        
        # Run search
        raw_output = self._run_command(args)
        
        # Parse output
        parsed = self._parse_search_output(raw_output)
        
        # Check if API likely doesn't exist and append to list
        if self._is_likely_non_existent(query, parsed):
            self._append_non_existent(query, package)
        
        # Determine detail level
        if detail:
            try:
                detail_level = DetailLevel(detail)
            except ValueError:
                detail_level = self._determine_detail_level(parsed)
        else:
            detail_level = self._determine_detail_level(parsed)
        
        # Format and return
        return self._format_output(parsed, detail_level)
    
    def get(self, group_id: str) -> str:
        """Get detailed info for a specific ID (always detailed)."""
        raw_output = self._run_command(["get", str(group_id)])
        
        # For get command, we'll parse and reformat more cleanly
        output = []
        
        # Extract key information
        lines = raw_output.split('\n')
        
        for line in lines:
            # Skip decorative lines
            if '╭' in line or '╰' in line or '─' in line:
                continue
            
            # Skip empty lines at the beginning
            if not line.strip() and not output:
                continue
                
            # Clean up box drawing characters
            cleaned = line.replace('│', '').strip()
            if cleaned or output:  # Include empty lines after content starts
                output.append(cleaned)
        
        return '\n'.join(output).strip()
    
    def dependencies(self, group_id: str) -> str:
        """Get dependencies for a specific ID."""
        raw_output = self._run_command(["dependencies", str(group_id)])
        
        # Clean up output similar to get
        output = []
        lines = raw_output.split('\n')
        
        for line in lines:
            if '╭' in line or '╰' in line or '─' in line:
                continue
            
            cleaned = line.replace('│', '').strip()
            if cleaned or output:
                output.append(cleaned)
        
        return '\n'.join(output).strip()


def main():
    """CLI interface for the wrapper."""
    import argparse
    
    parser = argparse.ArgumentParser(description="LLM-optimized LeanExplore wrapper")
    subparsers = parser.add_subparsers(dest='command', help='Commands')
    
    # Search command
    search_parser = subparsers.add_parser('search', help='Search for Lean statements')
    search_parser.add_argument('query', help='Search query')
    search_parser.add_argument('--limit', type=int, default=10, help='Result limit')
    search_parser.add_argument('--detail', choices=['minimal', 'standard', 'detailed'],
                             help='Output detail level (auto-selected if not specified)')
    search_parser.add_argument('--package', help='Restrict to specific package')
    
    # Get command
    get_parser = subparsers.add_parser('get', help='Get details for a specific ID')
    get_parser.add_argument('id', help='Statement group ID')
    
    # Dependencies command
    dep_parser = subparsers.add_parser('dependencies', help='Get dependencies for an ID')
    dep_parser.add_argument('id', help='Statement group ID')
    
    args = parser.parse_args()
    
    if not args.command:
        parser.print_help()
        sys.exit(1)
    
    explorer = LLMLeanExplore()
    
    if args.command == 'search':
        result = explorer.search(args.query, args.limit, args.detail, args.package)
    elif args.command == 'get':
        result = explorer.get(args.id)
    elif args.command == 'dependencies':
        result = explorer.dependencies(args.id)
    
    print(result)


if __name__ == "__main__":
    main()