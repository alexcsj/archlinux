# Arch Linux 環境配置倉庫

一個完整的 Arch Linux 環境配置和安裝指南倉庫，支持在不同硬體設備上快速部署相同的開發環境。

## 🎯 用途

本倉庫用於：
- 📋 記錄和版本控制 Arch Linux 環境配置
- 🔄 在新設備上快速複製整個開發環境
- 🎨 根據不同硬體配置進行客製化安裝
- 📚 提供完整的安裝文檔和故障排除指南

## 📁 倉庫結構

```
.
├── README.md                           # 本文件
├── docs/                              # 詳細文檔
│   ├── quick-install-checklist.md     # 快速安裝檢查清單
│   ├── environment-setup-guide.md     # 詳細軟體包安裝指南
│   ├── configuration-backup-guide.md  # 配置備份和恢復
│   └── lenovo-duet-2022-adaptation.md # 聯想小新 Duet 2022 硬體指南
├── scripts/                            # 自動化腳本
│   ├── install.sh                     # 主安裝腳本
│   ├── backup-config.sh               # 配置備份腳本
│   └── restore-config.sh              # 配置恢復腳本
├── packages/                           # 軟體包清單
│   └── installed-packages.txt          # 所有 1071 個軟體包
├── templates/                          # 配置模板
│   ├── hardware-profiles.md            # 硬體配置文件
│   └── install-config.example          # 安裝配置示例
└── config-backups/                     # 配置備份存儲目錄
```

## 🚀 快速開始

### 1. 複製本倉庫

```bash
git clone https://github.com/yourusername/archlinux.git
cd archlinux
```

### 2. 選擇硬體配置

查看 `templates/hardware-profiles.md` 以了解支援的硬體：

```bash
cat templates/hardware-profiles.md
```

### 3. 運行安裝腳本

基礎安裝：
```bash
chmod +x scripts/install.sh
./scripts/install.sh
```

帶硬體配置的安裝：
```bash
./scripts/install.sh --hardware duet-2022
```

### 4. 恢復配置（可選）

如果有備份的配置文件：

```bash
chmod +x scripts/restore-config.sh
./scripts/restore-config.sh path/to/backup
```

## 📊 環境統計

| 項目 | 數量 |
|------|------|
| **已安裝軟體包** | 1,071 |
| **開發工具** | ~200 |
| **文檔頁數** | ~2,500 |
| **支援硬體配置** | 持續增加 |

## 📖 文檔導航

### 首次安裝
1. 📄 [快速安裝檢查清單](docs/quick-install-checklist.md) - 30 分鐘快速指南
2. 📄 [環境設置指南](docs/environment-setup-guide.md) - 詳細的軟體包分類

### 硬體特定配置
- 📄 [聯想小新 Duet 2022](docs/lenovo-duet-2022-adaptation.md) - 平板設備配置

### 備份和恢復
- 📄 [配置備份指南](docs/configuration-backup-guide.md) - 備份和恢復方法

## 🛠️ 支援的硬體

| 硬體 | 狀態 | 文檔 |
|------|------|------|
| **Arch Linux (通用 x86_64)** | ✅ 支持 | [快速指南](docs/quick-install-checklist.md) |
| **聯想小新 Duet 2022** | ✅ 完全支持 | [完整指南](docs/lenovo-duet-2022-adaptation.md) |
| **其他平板設備** | 🔄 計劃中 | [提交問題](../../issues) |

## 🔧 核心功能

✅ **完整開發環境**
- C/C++、Python、Node.js、Java、Rust
- Git、Docker、嵌入式工具

✅ **GNOME 桌面環境**
- Wayland 顯示服務器
- 中文輸入法支援

✅ **多媒體系統**
- PipeWire 音訊
- FFmpeg 影像處理

✅ **系統優化**
- Linux Zen 內核
- 電源管理工具
- 高 DPI 屏幕支援

## 📝 軟體包清單

完整的 1,071 個軟體包清單位於 `packages/installed-packages.txt`：

```bash
# 查看軟體包數量
wc -l packages/installed-packages.txt

# 批量安裝
cat packages/installed-packages.txt | awk '{print $1}' | \
    xargs sudo pacman -S --noconfirm
```

## 🔄 自動化腳本

### 備份配置

```bash
chmod +x scripts/backup-config.sh
./scripts/backup-config.sh

# 輸出：system-config-backup-YYYYMMDD-HHMMSS.tar.gz
```

### 恢復配置

```bash
chmod +x scripts/restore-config.sh
./scripts/restore-config.sh path/to/backup.tar.gz
```

## 💾 使用 Claude CLI 自動安裝

### 方法 1：讀取倉庫並自動配置

```bash
claude project add https://github.com/yourusername/archlinux.git
cd archlinux
claude install --auto-detect-hardware
```

### 方法 2：指定硬體配置

```bash
claude install --hardware duet-2022
```

### 方法 3：互動式配置選擇

```bash
claude install --interactive
```

## 🔀 工作流程

### 在新電腦上安裝

1. **克隆倉庫**
   ```bash
   git clone https://github.com/yourusername/archlinux.git
   cd archlinux
   ```

2. **檢測硬體或手動選擇**
   ```bash
   ./scripts/install.sh --auto-detect
   # 或
   ./scripts/install.sh --hardware duet-2022
   ```

3. **恢復配置（可選）**
   ```bash
   ./scripts/restore-config.sh backup.tar.gz
   ```

4. **驗證安裝**
   ```bash
   pacman -Q | wc -l  # 應為 1071
   ```

### 更新配置

1. **進行系統變更**
   ```bash
   sudo pacman -Syu
   yay -S new-package
   ```

2. **備份新配置**
   ```bash
   ./scripts/backup-config.sh
   ```

3. **提交回倉庫**
   ```bash
   git add -A
   git commit -m "Update configuration after system changes"
   git push origin main
   ```

## 📋 預備檢查清單

在運行安裝前確保：

- ✅ 已安裝 Arch Linux 基礎系統
- ✅ 有穩定的網際網路連接
- ✅ 足夠的磁碟空間（至少 30GB）
- ✅ 了解你的硬體配置

## 🐛 故障排除

### 軟體包衝突

```bash
sudo pacman -Syu --overwrite "*"
```

### AUR 軟體包安裝失敗

```bash
yay -S package-name --editmenu
```

### 詳細信息

參照相應的文檔：
- 系統問題：[快速檢查清單](docs/quick-install-checklist.md#常見問題快速解決)
- 硬體問題：[硬體適配指南](docs/lenovo-duet-2022-adaptation.md#故障排除)
- 配置問題：[配置備份指南](docs/configuration-backup-guide.md#常見問題排除)

## 🤝 貢獻

歡迎提交問題和改進建議：

1. 測試安裝腳本
2. 提交 bug 報告
3. 新增硬體配置支援
4. 改進文檔

## 📜 版本歷史

| 版本 | 日期 | 主要變更 |
|------|------|---------|
| 1.0 | 2026-09-11 | 初始版本，包含完整環境配置 |

## 📞 聯繫方式

- 📧 Email: csj.taiwan@gmail.com
- 🐙 GitHub Issues: [提交問題](../../issues)

## 📄 許可證

MIT License - 見 LICENSE 文件

---

## 🎯 下一步

1. **完成第一次安裝** - 按照[快速檢查清單](docs/quick-install-checklist.md)
2. **備份配置** - 使用 `scripts/backup-config.sh`
3. **推送到 GitHub** - 保持配置版本控制
4. **在新設備上克隆** - 快速部署相同環境

---

**最後更新：** 2026-09-11  
**維護者：** csj.taiwan@gmail.com
