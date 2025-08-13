# Repository Guidelines

## Project Structure & Modules
- Root: high-level docs and tooling.
- `lean-core/`: Lean 4 formalization of E[τ] = e.
  - `PotionProblem.lean` entry; modules in `PotionProblem/` (PascalCase files map to module names).
  - Tests in `lean-core/test/*.lean`.
- `viz/`: TypeScript/Vite/WebGL visualizations (`src/core`, `src/math`, `src/scenes`).
- `docs/`: Mathematical exposition and technical guides.
- `tools/`: Support utilities (API database, logs, Python helpers).

## Build, Test, and Dev Commands
- Lean build: `cd lean-core && lake build` (typechecks library and modules).
- Lean update deps: `lake update` (uses pinned `lean-toolchain`).
- Viz dev server: `cd viz && npm install && npm run dev` (Node >= 18).
- Viz build: `npm run build`; preview: `npm run preview`.
- Viz typecheck only: `npm run typecheck`.

## Coding Style & Naming
- Lean 4:
  - Indentation 2 spaces; Unicode enabled (`pp.unicode.fun = true`).
  - `autoImplicit = false`; write explicit binders.
  - Names: Types/Theorems `PascalCase`, defs/lemmas `camelCase`.
  - File/module naming mirrors directory path (e.g., `PotionProblem/SeriesAnalysis.lean`).
- TypeScript:
  - Indentation 2 spaces; ES modules; keep `src/` folders cohesive.
  - Prefer `camelCase` for vars/functions, `PascalCase` for classes.

## Testing Guidelines
- Lean tests: add examples/lemmas under `lean-core/test/` that import project modules; run `lake build` to typecheck. Avoid `sorry`; ensure new theorems integrate with main import `PotionProblem.lean`.
- Viz: no JS test harness configured; use `npm run typecheck` and exercise scenes via `npm run dev`.

## Commit & Pull Requests
- Commit style: follow Conventional Commits where practical (`feat:`, `fix:`, `docs:`); existing history also uses bracketed scopes (e.g., `[ACHIEVEMENT]`). Keep messages imperative and scoped.
- PRs: concise description, linked issues, reproduction steps. For `viz/`, include screenshots/clip of the scene. Keep PRs focused; note any changes to `lean-toolchain` or Lake config explicitly.

## Security & Config
- Do not commit secrets. `.env` and variants are ignored; keep local keys out of Git.
- Respect pinned Lean toolchain; discuss upgrades in a dedicated PR.
