# LeanExplore Usage

This project uses LeanExplore to search mathlib4 APIs during Lean 4 development.

## Installation
```bash
uv sync
```

## Usage Examples

Search for Lean statements:
```bash
uv run leanexplore search "factorial"
uv run leanexplore search "exp tsum" --package Mathlib --limit 5
```

Get detailed information:
```bash
uv run leanexplore get [GROUP_ID]
uv run leanexplore dependencies [GROUP_ID]
```

## Environment
The `.env` file contains the pre-configured `LEANEXPLORE_API_KEY`.