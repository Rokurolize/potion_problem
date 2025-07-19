# Task 1: Create clean branch from main

## 目的
mainブランチから新しいクリーンなブランチを作成

## 実行手順

```bash
# mainブランチに切り替え
git checkout main

# 新しいブランチを作成
git checkout -b clean-v4.21.0-upgrade

# 現在の状態を確認
git status
```

## 確認事項
- mainブランチがv4.15.0の状態であること
- 新しいブランチが作成されたこと

## 次のステップ
- Task 2: Apply v4.21.0 changes