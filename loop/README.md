# 生涯カウントループ

このディレクトリは、媚薬問題の別解探索を繰り返すための最小限の運用メモである。

## 集計

```bash
python3 scripts/count_lifetime.py --format text
```

現行ペルソナは`author-persona.md`の見出しから読む。現行ペルソナで同じ候補別解を複数回評価した場合は、`worker-runs/*/result.json`のパス順で最新の評価だけをユニーク別解として数える。

「生涯」は、`would_say_target_line`が`true`で、かつ`raw_reaction`に次の文字列が含まれる場合だけ数える。

```text
天晴れだ　生涯貴様を忘れることはないだろう
```

## ゴール判定

```bash
scripts/check_lifetime_goal.sh
```

このコマンドは、現行ペルソナでのユニークな「生涯」別解が1000件に達していない場合に失敗する。1000件に達したときだけ`/goal`を完了扱いにできる。

## ループの1単位

1. 未追跡の候補別解ファイルを作る。
2. `worker-runs/<run-id>/brief.md`に固定ペルソナ、候補別解、出力`result.json`を明記する。
3. Workerに候補別解を評価させる。
4. `python3 scripts/count_lifetime.py --format text`で件数を確認する。
5. 候補、評価証跡、必要なループ設定をコミットし、sqlite、ログ、進捗TSVなどの実行時生成物は`.gitignore`で除外する。
