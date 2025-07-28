-- Mathlib4 API Tracking Database Schema
-- Version: 1.0
-- Purpose: Track existence, usage patterns, and evolution of Mathlib4 APIs

-- Core API table
CREATE TABLE apis (
    api_name TEXT PRIMARY KEY,          -- e.g., "Summable.tsum_add_tsum_compl"
    exists_in_mathlib BOOLEAN NOT NULL, -- true if verified to exist
    deprecated BOOLEAN DEFAULT FALSE,   -- deprecation status
    replacement_api TEXT,               -- if deprecated, what to use instead
    signature TEXT NOT NULL,            -- full type signature
    import_path TEXT NOT NULL,          -- e.g., "Mathlib.Topology.Algebra.InfiniteSum.Basic"
    lean_explore_id INTEGER,            -- LeanExplore search result ID
    source_file TEXT,                   -- exact file location
    line_number INTEGER,                -- line in source file
    mathematical_significance TEXT,     -- brief description of what it proves
    verified_date DATE NOT NULL,        -- when we verified existence
    mathlib_version TEXT NOT NULL,      -- e.g., "v4.21.0"
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories for organizing APIs
CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_name TEXT UNIQUE NOT NULL, -- e.g., "Infinite Sum APIs"
    description TEXT
);

-- Many-to-many relationship for API categories
CREATE TABLE api_categories (
    api_name TEXT,
    category_id INTEGER,
    PRIMARY KEY (api_name, category_id),
    FOREIGN KEY (api_name) REFERENCES apis(api_name),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Usage patterns and examples
CREATE TABLE usage_patterns (
    pattern_id INTEGER PRIMARY KEY AUTOINCREMENT,
    api_name TEXT NOT NULL,
    pattern_code TEXT NOT NULL,         -- Lean code example
    description TEXT,                   -- explanation of the pattern
    FOREIGN KEY (api_name) REFERENCES apis(api_name)
);

-- Common errors and gotchas
CREATE TABLE api_errors (
    error_id INTEGER PRIMARY KEY AUTOINCREMENT,
    api_name TEXT NOT NULL,
    error_pattern TEXT NOT NULL,        -- the wrong way to use it
    correct_pattern TEXT NOT NULL,      -- the right way
    error_message TEXT,                 -- typical error message
    explanation TEXT,                   -- why this happens
    FOREIGN KEY (api_name) REFERENCES apis(api_name)
);

-- Track which sorries each API helps solve
CREATE TABLE sorry_contributions (
    api_name TEXT,
    module TEXT NOT NULL,               -- e.g., "IrwinHallTheory"
    sorry_line INTEGER NOT NULL,        -- line number of the sorry
    contribution_level INTEGER,         -- 1-5 stars for importance
    notes TEXT,
    PRIMARY KEY (api_name, module, sorry_line),
    FOREIGN KEY (api_name) REFERENCES apis(api_name)
);

-- Search history to avoid redundant searches
CREATE TABLE search_history (
    search_id INTEGER PRIMARY KEY AUTOINCREMENT,
    search_pattern TEXT NOT NULL,
    search_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    result_count INTEGER,
    mathlib_version TEXT
);

-- Non-existent API patterns
CREATE TABLE non_existent_apis (
    pattern TEXT PRIMARY KEY,           -- e.g., "tsum.*if.*then.*else"
    description TEXT NOT NULL,          -- what was being sought
    search_context TEXT,                -- why it was searched
    alternative_approach TEXT,          -- what to use instead
    verified_date DATE NOT NULL,
    mathlib_version TEXT NOT NULL
);

-- Indexes for performance
CREATE INDEX idx_api_exists ON apis(exists_in_mathlib);
CREATE INDEX idx_api_deprecated ON apis(deprecated);
CREATE INDEX idx_api_import ON apis(import_path);
CREATE INDEX idx_api_version ON apis(mathlib_version);
CREATE INDEX idx_search_pattern ON search_history(search_pattern);
CREATE INDEX idx_search_date ON search_history(search_date);

-- Trigger to update timestamp
CREATE TRIGGER update_api_timestamp 
AFTER UPDATE ON apis
BEGIN
    UPDATE apis SET updated_at = CURRENT_TIMESTAMP WHERE api_name = NEW.api_name;
END;