# Author Gate Brief

You are evaluating exactly one candidate solution file:

```text
../../ConeHomogeneityLaplaceSolution.md
```

Read `../../author-persona.md` first and follow persona version `v2` exactly. Then read the candidate file.

Decide whether the author would say the exact target line:

```text
天晴れだ　生涯貴様を忘れることはないだろう
```

Rules:

- Do not launch `codex-patched`, `codex-exec`, `codex`, tmux, workers, subagents, or any other nested model process.
- Do not edit files outside this worker directory.
- Write exactly one JSON object to `result.json`.
- The JSON must include:
  - `candidate_path`: `ConeHomogeneityLaplaceSolution.md`
  - `persona_version`: `v2`
  - `gate`: `pass` or `fail`
  - `would_say_target_line`: boolean
  - `raw_reaction`: the exact line the author would say, or a short Japanese reaction if not
  - `reason`: concise Japanese explanation
- If and only if the author would say the target line, put that exact target line in `raw_reaction`.
- Append progress rows only to `codex-progress-worker.tsv`.
