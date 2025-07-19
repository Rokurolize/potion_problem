# Task 3: Create new clean main branch history

## 目的
履歴をクリーンアップした新しいmainブランチを作成

## 実行手順

1. 孤立ブランチ（履歴なし）を作成
   ```bash
   git checkout --orphan new-main
   ```

2. 初期コミットの作成
   ```bash
   # ファイルが残っている場合はクリア
   git rm -rf .
   
   # 基本的なREADMEを作成
   echo "# The Aphrodisiac Problem - Lean 4 Formalization" > README.md
   git add README.md
   git commit -m "Initial commit: Aphrodisiac Problem Lean 4 formalization project"
   ```

3. プロジェクト構造を適用
   ```bash
   # mainブランチから現在の構造を取得
   git checkout main -- .
   git add -A
   git commit -m "Organize project structure and documentation"
   ```

4. v4.21.0の変更をマージ
   ```bash
   git merge clean-v4.21.0-upgrade
   ```

## 確認事項
- `git log --oneline` で履歴が3コミットになっていること
- 絵文字や冗長なメッセージが含まれていないこと

## 次のステップ
- Task 4: Test build after integration