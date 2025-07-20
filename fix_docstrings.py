#!/usr/bin/env python3

import re
import sys

def fix_docstrings(filename):
    with open(filename, 'r') as f:
        content = f.read()
    
    # Fix doc-strings that don't start with a space or newline
    # Pattern: /-- followed by non-space, non-newline character
    fixed_content = re.sub(r'^(/--)((?![ \n]).)', r'\1 \2', content, flags=re.MULTILINE)
    
    with open(filename, 'w') as f:
        f.write(fixed_content)
    
    print(f"Fixed doc-strings in {filename}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        fix_docstrings(sys.argv[1])
    else:
        print("Usage: python fix_docstrings.py <filename>")