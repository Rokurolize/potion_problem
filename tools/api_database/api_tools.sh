#!/bin/bash
# API Database Tools for Mathlib4 API Tracking
# These functions provide easy access to the SQLite database

DB_PATH="/home/ubuntu/workbench/projects/potion_problem/api_database/mathlib_apis.db"

# Check if API exists in mathlib
api-exists() {
    if [ -z "$1" ]; then
        echo "Usage: api-exists <api_name>"
        return 1
    fi
    
    result=$(sqlite3 "$DB_PATH" "SELECT exists_in_mathlib FROM apis WHERE api_name = '$1';")
    
    if [ -z "$result" ]; then
        echo "API not found in database: $1"
        return 2
    elif [ "$result" = "1" ]; then
        echo "EXISTS: $1"
        return 0
    else
        echo "NOT EXISTS: $1"
        # Show alternative approach if available
        alt=$(sqlite3 "$DB_PATH" "SELECT alternative_approach FROM non_existent_apis WHERE pattern LIKE '%${1//./.*}%' LIMIT 1;")
        if [ -n "$alt" ]; then
            echo "Alternative: $alt"
        fi
        return 1
    fi
}

# Add verified API to database
api-add() {
    if [ $# -lt 3 ]; then
        echo "Usage: api-add <api_name> <signature> <import_path> [lean_explore_id]"
        return 1
    fi
    
    local name="$1"
    local signature="$2"
    local import="$3"
    local lean_id="${4:-NULL}"
    
    sqlite3 "$DB_PATH" <<EOF
INSERT OR REPLACE INTO apis (api_name, exists_in_mathlib, signature, import_path, 
                           lean_explore_id, verified_date, mathlib_version)
VALUES ('$name', 1, '$signature', '$import', $lean_id, date('now'), 'v4.21.0');
EOF
    
    echo "Added API: $name"
}

# Mark API as non-existent
api-not-found() {
    if [ -z "$1" ]; then
        echo "Usage: api-not-found <api_name> [alternative_approach]"
        return 1
    fi
    
    local name="$1"
    local alternative="${2:-Use alternative approach}"
    
    sqlite3 "$DB_PATH" <<EOF
INSERT OR REPLACE INTO apis (api_name, exists_in_mathlib, signature, import_path, 
                           verified_date, mathlib_version)
VALUES ('$name', 0, 'NOT FOUND', 'N/A', date('now'), 'v4.21.0');

INSERT OR REPLACE INTO non_existent_apis (pattern, description, alternative_approach,
                                        verified_date, mathlib_version)
VALUES ('$name', 'API does not exist', '$alternative', date('now'), 'v4.21.0');
EOF
    
    echo "Marked as non-existent: $name"
}

# Export APIs by category to markdown
api-export-category() {
    if [ -z "$1" ]; then
        echo "Usage: api-export-category <category_name>"
        echo "Available categories:"
        sqlite3 "$DB_PATH" "SELECT category_name FROM categories ORDER BY category_name;"
        return 1
    fi
    
    echo "# $1"
    echo ""
    
    sqlite3 -separator "|" "$DB_PATH" <<EOF | while IFS='|' read -r api_name signature import deprecated lean_id significance; do
SELECT a.api_name, a.signature, a.import_path, a.deprecated, 
       a.lean_explore_id, a.mathematical_significance
FROM apis a 
JOIN api_categories ac ON a.api_name = ac.api_name 
JOIN categories c ON ac.category_id = c.category_id 
WHERE c.category_name = '$1' AND a.exists_in_mathlib = 1 
ORDER BY a.api_name;
EOF
        echo "### \`$api_name\`"
        if [ "$deprecated" = "1" ]; then
            echo "**Status**: ⚠️ Deprecated"
        else
            echo "**Status**: ✅ Verified"
        fi
        echo "**Signature**: \`$signature\`"
        echo "**Import**: \`import $import\`"
        if [ "$lean_id" != "" ] && [ "$lean_id" != "NULL" ]; then
            echo "**ID**: $lean_id"
        fi
        if [ "$significance" != "" ] && [ "$significance" != "NULL" ]; then
            echo "**Significance**: $significance"
        fi
        echo ""
    done
}

# Find APIs that help with a specific sorry
api-for-sorry() {
    if [ $# -lt 2 ]; then
        echo "Usage: api-for-sorry <module> <line_number>"
        return 1
    fi
    
    echo "APIs for $1:$2 sorry:"
    echo ""
    
    sqlite3 -column -header "$DB_PATH" <<EOF
SELECT api_name, contribution_level as stars, notes 
FROM sorry_contributions 
WHERE module = '$1' AND sorry_line = $2 
ORDER BY contribution_level DESC;
EOF
}

# Search for APIs by pattern
api-search() {
    if [ -z "$1" ]; then
        echo "Usage: api-search <pattern>"
        return 1
    fi
    
    echo "Searching for APIs matching: $1"
    echo ""
    
    # Record search
    sqlite3 "$DB_PATH" "INSERT INTO search_history (search_pattern, mathlib_version) VALUES ('$1', 'v4.21.0');"
    
    # Search in existing APIs
    sqlite3 -column "$DB_PATH" <<EOF
SELECT api_name, 
       CASE exists_in_mathlib WHEN 1 THEN 'EXISTS' ELSE 'NOT EXISTS' END as status,
       import_path
FROM apis 
WHERE api_name LIKE '%$1%' 
ORDER BY exists_in_mathlib DESC, api_name
LIMIT 20;
EOF
}

# Get usage pattern for an API
api-usage() {
    if [ -z "$1" ]; then
        echo "Usage: api-usage <api_name>"
        return 1
    fi
    
    echo "Usage patterns for: $1"
    echo ""
    
    sqlite3 "$DB_PATH" <<EOF | while IFS='|' read -r pattern desc; do
SELECT pattern_code, description FROM usage_patterns WHERE api_name = '$1';
EOF
        echo "$pattern"
        if [ -n "$desc" ]; then
            echo "-- $desc"
        fi
        echo ""
    done
    
    # Also show common errors
    local errors=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM api_errors WHERE api_name = '$1';")
    if [ "$errors" -gt "0" ]; then
        echo "Common errors:"
        sqlite3 "$DB_PATH" <<EOF | while IFS='|' read -r wrong right msg; do
SELECT error_pattern, correct_pattern, error_message FROM api_errors WHERE api_name = '$1';
EOF
            echo "❌ WRONG: $wrong"
            echo "✅ CORRECT: $right"
            if [ -n "$msg" ]; then
                echo "Error: $msg"
            fi
            echo ""
        done
    fi
}

# Export all APIs to markdown (for backup/documentation)
api-export-all() {
    local output="${1:-api_export.md}"
    
    {
        echo "# Mathlib4 API Database Export"
        echo "Generated: $(date)"
        echo ""
        
        # Export each category
        sqlite3 "$DB_PATH" "SELECT category_name FROM categories ORDER BY category_name;" | while read -r category; do
            api-export-category "$category"
            echo ""
        done
        
        echo "## Non-Existent API Patterns"
        echo ""
        sqlite3 -separator "|" "$DB_PATH" "SELECT pattern, description, alternative_approach FROM non_existent_apis ORDER BY pattern;" | while IFS='|' read -r pattern desc alt; do
            echo "### \`$pattern\`"
            echo "**Description**: $desc"
            echo "**Alternative**: $alt"
            echo ""
        done
    } > "$output"
    
    echo "Exported to: $output"
}

# Database statistics
api-stats() {
    echo "Mathlib4 API Database Statistics"
    echo "================================"
    
    local total=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM apis;")
    local exists=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM apis WHERE exists_in_mathlib = 1;")
    local not_exists=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM apis WHERE exists_in_mathlib = 0;")
    local deprecated=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM apis WHERE deprecated = 1;")
    local patterns=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM usage_patterns;")
    local errors=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM api_errors;")
    local searches=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM search_history;")
    
    echo "Total APIs tracked: $total"
    echo "  - Verified to exist: $exists"
    echo "  - Non-existent: $not_exists"
    echo "  - Deprecated: $deprecated"
    echo ""
    echo "Usage patterns: $patterns"
    echo "Error patterns: $errors"
    echo "Search history: $searches entries"
    echo ""
    echo "Categories:"
    sqlite3 -column "$DB_PATH" <<EOF
SELECT c.category_name, COUNT(ac.api_name) as count
FROM categories c
LEFT JOIN api_categories ac ON c.category_id = ac.category_id
LEFT JOIN apis a ON ac.api_name = a.api_name AND a.exists_in_mathlib = 1
GROUP BY c.category_name
ORDER BY count DESC;
EOF
}

# Make functions available when sourced
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    # Script is being executed, not sourced
    # Run the function specified as first argument
    if [ -n "$1" ]; then
        "$@"
    else
        echo "Available commands:"
        echo "  api-exists <api_name>           - Check if API exists"
        echo "  api-add <name> <sig> <import>   - Add verified API"
        echo "  api-not-found <name> [alt]      - Mark as non-existent"
        echo "  api-search <pattern>            - Search for APIs"
        echo "  api-usage <api_name>            - Show usage patterns"
        echo "  api-for-sorry <module> <line>   - Find APIs for sorry"
        echo "  api-export-category <category>  - Export category to markdown"
        echo "  api-export-all [file]           - Export entire database"
        echo "  api-stats                       - Show database statistics"
    fi
fi