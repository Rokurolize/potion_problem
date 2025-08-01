# System Utilities for Linux Development

## Essential Commands

### Navigation and File Management
```bash
# Directory navigation
cd <path>              # Change directory
pwd                    # Print working directory
ls -la                 # List all files with details
tree -I '__pycache__'  # Directory tree (exclude pycache)

# File operations
cp <src> <dest>        # Copy files
mv <src> <dest>        # Move/rename files
rm <file>              # Remove file
rm -rf <dir>           # Remove directory recursively
mkdir -p <path>        # Create directory (with parents)
```

### File Inspection
```bash
# View file contents
cat <file>             # Display entire file
less <file>            # Page through file
head -n 20 <file>      # First 20 lines
tail -n 20 <file>      # Last 20 lines

# Search in files
grep -n "pattern" file           # Search with line numbers
grep -r "pattern" dir/           # Recursive search
grep -c "sorry" *.lean           # Count matches
rg "pattern"                     # ripgrep (faster alternative)
```

### Git Operations
```bash
# Basic git
git status                       # Current state
git diff                         # Unstaged changes
git diff --cached               # Staged changes
git add <file>                  # Stage file
git commit -m "[TAG] Message"   # Commit
git log --oneline -10           # Recent commits

# Branching
git branch                      # List branches
git checkout <branch>           # Switch branch
git checkout -b <new-branch>    # Create and switch
```

### Process Management
```bash
# Running processes
ps aux | grep lean              # Find Lean processes
htop                            # Interactive process viewer
kill <pid>                      # Terminate process

# Background jobs
command &                       # Run in background
jobs                           # List background jobs
fg %1                          # Bring job to foreground
```

### System Information
```bash
# Disk usage
df -h                          # Disk space
du -sh *                       # Directory sizes

# Memory
free -h                        # Memory usage

# File permissions
chmod +x script.sh             # Make executable
ls -la                         # View permissions
```

### Project-Specific Utilities
```bash
# Find Lean files
find . -name "*.lean" -type f

# Count lines of code
find PotionProblem -name "*.lean" | xargs wc -l

# Watch for changes
watch -n 2 'lake build 2>&1 | grep -E "(error:|sorry)"'

# Create heredoc
cat > file.lean << 'EOF'
content here
EOF
```

### Environment
```bash
# Lake/Lean environment
lake env lean <file>           # Run Lean with Lake environment
which lake                     # Find Lake executable
echo $PATH                     # Check PATH

# Shell
echo $SHELL                    # Current shell
source ~/.bashrc              # Reload bash config
```

## Important Notes
- System is Linux (not regular Unix)
- Use `lake env` prefix for Lean commands to ensure proper environment
- ripgrep (`rg`) is pre-installed and faster than grep for large searches
- Always use absolute paths when required by tools