# GitHub 推送指南

本指南說明如何將本地 `archlinux` 倉庫推送到 GitHub。

## 📋 前置要求

1. GitHub 帳號（已有：csj.taiwan@gmail.com）
2. Git 已安裝並配置
3. SSH 金鑰或 Personal Access Token（推薦 SSH）

## 🚀 步驟 1：建立 GitHub 倉庫

### 方式 A：網頁版（推薦新手）

1. 登入 GitHub：https://github.com/login
2. 點擊右上角 `+` > `New repository`
3. 填入以下信息：
   - **Repository name:** `archlinux`
   - **Description:** `Complete Arch Linux environment setup and configuration management repository`
   - **Public/Private:** 公開（Public）
   - **Initialize with:** 不勾選（我們已有本地倉庫）
4. 點擊 `Create repository`

### 方式 B：命令行（如已安裝 GitHub CLI）

```bash
gh repo create archlinux \
  --public \
  --description "Complete Arch Linux environment setup and configuration management repository"
```

## 🔗 步驟 2：設定 SSH 金鑰（推薦）

### 檢查現有的 SSH 金鑰

```bash
ls -la ~/.ssh/
```

### 如果沒有金鑰，建立新的

```bash
ssh-keygen -t ed25519 -C "csj.taiwan@gmail.com"

# 按 Enter 接受預設位置
# 輸入安全密碼（可以為空）
```

### 將公鑰新增到 GitHub

1. 複製公鑰到剪貼板：
   ```bash
   cat ~/.ssh/id_ed25519.pub | xclip -selection clipboard
   # 或
   cat ~/.ssh/id_ed25519.pub
   ```

2. 進入 GitHub 設定：https://github.com/settings/keys

3. 點擊 `New SSH key`

4. 貼上公鑰並保存

### 測試連接

```bash
ssh -T git@github.com
# 應該輸出：Hi username! You've successfully authenticated...
```

---

## 📤 步驟 3：推送本地倉庫

### 方式 A：SSH（推薦）

```bash
cd /path/to/archlinux

# 新增遠端倉庫
git remote add origin git@github.com:yourusername/archlinux.git

# 重新命名預設分支（如需要）
git branch -M main

# 推送所有分支和標籤
git push -u origin main
```

### 方式 B：HTTPS（用於 Personal Access Token）

```bash
cd /path/to/archlinux

# 新增遠端倉庫
git remote add origin https://github.com/yourusername/archlinux.git

# 推送
git push -u origin main
```

### 方式 C：GitHub CLI

```bash
cd /path/to/archlinux
gh repo create archlinux --source=. --remote=origin --push
```

---

## ✅ 驗證推送

### 檢查遠端倉庫狀態

```bash
git remote -v
# 應該顯示：
# origin  git@github.com:yourusername/archlinux.git (fetch)
# origin  git@github.com:yourusername/archlinux.git (push)
```

### 查看推送結果

```bash
git log --oneline -3 --all
```

### 在 GitHub 網頁上驗證

訪問：https://github.com/yourusername/archlinux

應該看到所有文件和提交歷史。

---

## 🔄 後續工作流程

### 在新電腦上克隆倉庫

```bash
git clone git@github.com:yourusername/archlinux.git
# 或
git clone https://github.com/yourusername/archlinux.git

cd archlinux
```

### 進行更改並推送

```bash
# 進行更改
./scripts/install.sh --hardware duet-2022

# 提交變更
git add -A
git commit -m "Update configuration for new system"

# 推送
git push origin main
```

### 拉取最新變更

```bash
git pull origin main
```

---

## 🛠️ 常見問題

### Q: 如何更改倉庫為私有？

在 GitHub 上：
1. 進入 Repository Settings
2. 向下滾動到 "Danger Zone"
3. 點擊 "Make private"

### Q: 如何在倉庫中新增協作者？

在 GitHub 上：
1. 進入 Settings > Collaborators
2. 點擊 "Add people"
3. 輸入協作者的 GitHub 用戶名

### Q: 推送時出現權限錯誤？

檢查：
```bash
# 檢查 SSH 連接
ssh -T git@github.com

# 檢查遠端 URL
git remote -v

# 重新設定遠端（如需要）
git remote set-url origin git@github.com:yourusername/archlinux.git
```

### Q: 如何撤銷推送？

注意：不建議在已推送的公開倉庫上進行此操作。

```bash
# 查看提交歷史
git log --oneline

# 重置到前一個提交（謹慎使用！）
git reset --soft HEAD~1

# 強制推送（會覆蓋遠端，謹慎使用！）
git push origin main --force-with-lease
```

---

## 🔐 安全建議

### 不要上傳的內容

確保以下內容不在倉庫中：
- ❌ 密碼和密鑰
- ❌ 個人敏感信息
- ❌ API 金鑰
- ❌ 大型二進制文件（> 100MB）

### 推薦的公開內容

✅ 配置文件（已清理敏感信息）
✅ 文檔和教程
✅ 腳本和自動化工具
✅ 軟體包清單
✅ 硬體配置指南

---

## 📚 有用的 GitHub 功能

### 建立 Issues（問題追蹤）

```bash
gh issue create --title "Add support for device X" --body "Description"
```

### 建立 Release（發布版本）

```bash
git tag -a v1.0 -m "First release"
git push origin v1.0

# 或在 GitHub 網頁上建立 Release
```

### 新增 GitHub Actions（CI/CD）

在 `.github/workflows/` 目錄中建立 YAML 文件，自動化測試和部署。

---

## 🎯 完成檢查清單

- [ ] 建立 GitHub 倉庫
- [ ] 設定 SSH 金鑰（或 Personal Access Token）
- [ ] 推送本地倉庫到 GitHub
- [ ] 在 GitHub 網頁上驗證所有文件
- [ ] 測試從新電腦克隆倉庫
- [ ] 在新電腦上運行安裝腳本
- [ ] 推送新配置回倉庫

---

## 🚀 下一步

1. **設定 README 標籤** - 讓 GitHub 顯示你的倉庫語言
2. **新增 Topics** - 在 Repository Settings 中新增主題（archlinux, linux, automation）
3. **啟用 Discussions** - 允許社群討論
4. **新增 CI/CD** - 設定 GitHub Actions 自動化工作流
5. **建立 Wiki** - 記錄額外的設定說明

---

## 📞 獲取幫助

- GitHub 文檔：https://docs.github.com/
- Git 官方指南：https://git-scm.com/doc
- SSH 設定指南：https://docs.github.com/en/authentication/connecting-to-github-with-ssh

---

**現在你已準備好將倉庫推送到 GitHub！** 🎉

```bash
# 最後確認所有更改已提交
git status

# 推送到 GitHub
git push -u origin main

# 訪問你的倉庫
echo "https://github.com/yourusername/archlinux"
```
