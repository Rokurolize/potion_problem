# Task 4: Test build after integration

## 目的
統合後のビルドが正常に動作することを確認

## 実行手順

1. Lake環境のクリーンアップ
   ```bash
   rm -rf .lake
   rm -f lake-manifest.json
   ```

2. 依存関係の更新とビルド
   ```bash
   lake update
   lake build
   ```

3. ビルド結果の確認
   - エラーがないこと
   - 警告が最小限であること

4. Pythonテストの実行（オプション）
   ```bash
   uv sync
   uv run python test_all.py
   ```

## 確認事項
- Lean 4ビルドが成功すること
- sorryは残っているが、ビルドエラーはないこと
- Pythonテストが通ること（該当する場合）

## 完了後の作業
1. 新しいmainブランチをリモートにプッシュ
   ```bash
   git branch -m main old-main
   git branch -m new-main main
   git push origin main --force-with-lease
   ```

2. クリーンアップ
   ```bash
   git branch -D old-main
   git branch -D clean-v4.21.0-upgrade
   ```

## 注意事項
- force pushは慎重に行うこと
- バックアップを取ってから実行すること