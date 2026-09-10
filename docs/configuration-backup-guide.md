# 配置文件備份和恢復指南

## 概述

本指南說明如何備份和恢復此系統的所有重要配置文件。

---

## 用戶配置文件（需手動備份）

### 關鍵配置文件位置

#### 1. Shell 配置文件
```
~/.bashrc                  - Bash shell 配置
~/.bash_profile            - Bash 登入 shell 配置
~/.bash_logout             - Bash 登出配置
~/.viminfo                 - Vim 配置和歷史
```

#### 2. Git 配置
```
~/.gitconfig               - Git 全域設定
```

#### 3. NPM 配置
```
~/.npmrc                   - NPM 設定
~/.npm/                    - NPM 快取和模組
~/.npm-global/             - 全域 NPM 軟體包安裝位置
```

#### 4. 開發環境配置
```
~/.espressif/              - ESP-IDF 配置和工具
~/.gradle/                 - Gradle 配置
~/.java/                   - Java 配置
~/.micropico-stubs/        - MicroPython/Pico 相關檔案
```

#### 5. IDE 和編輯器配置
```
~/.vscode/                 - Visual Studio Code 配置
~/.config/Code/            - VS Code 設定目錄
~/.config/AndroidStudio/   - Android Studio 配置
```

#### 6. 應用配置文件
```
~/.config/                 - GNOME 和各應用配置目錄
  ├── dconf/               - GNOME 設定資料庫
  ├── evolution/           - 郵件和日曆客戶端
  ├── gedit/               - 文字編輯器
  └── ...                  - 其他應用配置
```

#### 7. 音樂播放器配置
```
~/.foobar2000/             - Foobar2000 配置（需 Wine）
```

#### 8. 輸入法和語言配置
```
~/.config/fcitx5/          - Fcitx5 輸入法配置
~/.config/ibus/            - IBus 輸入法配置
```

#### 9. 其他系統配置
```
~/.bashrc                  - 包含自訂別名和環境變數
~/.local/bin/              - 自訂腳本和指令
~/.local/share/            - 應用數據
```

---

## 快速備份腳本

### 備份所有配置文件

建立文件 `backup-config.sh`：

```bash
#!/bin/bash

# 目標備份目錄
BACKUP_DIR="./system-config-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "開始備份配置文件..."

# 備份 Shell 配置
cp ~/.bashrc "$BACKUP_DIR/bashrc"
cp ~/.bash_profile "$BACKUP_DIR/bash_profile"
cp ~/.bash_logout "$BACKUP_DIR/bash_logout"

# 備份 Git 配置
cp ~/.gitconfig "$BACKUP_DIR/gitconfig"

# 備份 NPM 配置
cp ~/.npmrc "$BACKUP_DIR/npmrc"

# 備份整個 .config 目錄
cp -r ~/.config "$BACKUP_DIR/config"

# 備份 .local 目錄（包含自訂腳本）
cp -r ~/.local "$BACKUP_DIR/local"

# 備份開發環境配置
cp -r ~/.espressif "$BACKUP_DIR/espressif" 2>/dev/null || true
cp -r ~/.gradle "$BACKUP_DIR/gradle"
cp -r ~/.java "$BACKUP_DIR/java"

# 備份 IDE 配置
cp -r ~/.vscode "$BACKUP_DIR/vscode"

# 備份應用配置
cp -r ~/.foobar2000 "$BACKUP_DIR/foobar2000" 2>/dev/null || true

# 備份軟體包列表
echo "輸出已安裝軟體包列表..."
pacman -Q > "$BACKUP_DIR/installed-packages.txt"
pacman -Q --foreign > "$BACKUP_DIR/aur-packages.txt"

echo "備份完成！位置：$BACKUP_DIR"
echo "壓縮備份..."
tar -czf "${BACKUP_DIR}.tar.gz" "$BACKUP_DIR"
echo "壓縮完成：${BACKUP_DIR}.tar.gz"
```

### 執行備份
```bash
chmod +x backup-config.sh
./backup-config.sh
```

---

## 在新系統上恢復配置

### 準備工作

1. **安裝 Arch Linux 和所需軟體包**

首先，在聯想小新 Duet 2022 上安裝基礎 Arch Linux，然後安裝上述環境設定指南中提到的所有軟體包：

```bash
# 安裝基礎系統
sudo pacman -Syu
sudo pacman -S base-devel git curl wget

# 安裝 yay（AUR 助手）
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si && cd ..

# 安裝所有軟體包（使用準備好的列表）
cat installed-packages.txt | grep -v ' ' | awk '{print $1}' | xargs sudo pacman -S --noconfirm
cat aur-packages.txt | grep -v ' ' | awk '{print $1}' | xargs yay -S --noconfirm
```

2. **恢復配置文件**

建立文件 `restore-config.sh`：

```bash
#!/bin/bash

BACKUP_DIR="./system-config-backup-YYYYMMDD-HHMMSS"  # 修改為你的備份目錄

if [ ! -d "$BACKUP_DIR" ]; then
    echo "錯誤：備份目錄不存在：$BACKUP_DIR"
    exit 1
fi

echo "開始恢復配置文件..."

# 恢復 Shell 配置
cp "$BACKUP_DIR/bashrc" ~/.bashrc
cp "$BACKUP_DIR/bash_profile" ~/.bash_profile
cp "$BACKUP_DIR/bash_logout" ~/.bash_logout

# 恢復 Git 配置
cp "$BACKUP_DIR/gitconfig" ~/.gitconfig

# 恢復 NPM 配置
cp "$BACKUP_DIR/npmrc" ~/.npmrc

# 恢復 .config 目錄
cp -r "$BACKUP_DIR/config"/* ~/.config/ 2>/dev/null || true

# 恢復 .local 目錄
cp -r "$BACKUP_DIR/local"/* ~/.local/ 2>/dev/null || true

# 恢復開發環境配置
cp -r "$BACKUP_DIR/espressif" ~/ 2>/dev/null || true
cp -r "$BACKUP_DIR/gradle" ~/ 2>/dev/null || true
cp -r "$BACKUP_DIR/java" ~/ 2>/dev/null || true

# 恢復 IDE 配置
cp -r "$BACKUP_DIR/vscode" ~/.vscode 2>/dev/null || true

# 恢復應用配置
cp -r "$BACKUP_DIR/foobar2000" ~/ 2>/dev/null || true

echo "配置文件恢復完成！"
echo "請重啟系統以應用所有設定。"
```

### 執行恢復
```bash
chmod +x restore-config.sh
./restore-config.sh
```

---

## 系統級配置（需要 root 權限）

### 系統配置文件位置

#### 1. pacman 配置
```
/etc/pacman.conf           - 軟體包管理器設定
/etc/makepkg.conf          - 編譯選項設定
```

#### 2. 網路配置
```
/etc/systemd/resolved.conf - DNS 解析器設定
/etc/hostname              - 主機名
```

#### 3. 音訊配置
```
/etc/speech-dispatcher/speechd.conf - 文字轉語音引擎設定
```

#### 4. 引導程序配置
```
/etc/default/grub          - GRUB 啟動程序設定
/boot/grub/grub.cfg        - GRUB 配置（自動生成）
```

### 備份系統配置

```bash
# 需要 root 權限
sudo tar -czf system-config-backup.tar.gz \
    /etc/pacman.conf \
    /etc/makepkg.conf \
    /etc/systemd/resolved.conf \
    /etc/hostname \
    /etc/default/grub \
    /etc/speech-dispatcher/speechd.conf
```

---

## 特殊配置恢復

### ESP-IDF 開發環境

```bash
# 在新系統上設定 ESP-IDF
export PATH="$PATH:$HOME/.espressif/tools/xtensa-esp-elf/esp-2024.08.1/xtensa-esp-elf/bin"
source ~/.espressif/tools/activate_idf_v6.1.sh

# 或使用別名（在 ~/.bashrc 中已定義）
alias get_idf='. $HOME/.espressif/tools/activate_idf_v6.1.sh'
```

### Pico SDK 開發環境

```bash
# 確保 Pico SDK 路徑在 ~/.bashrc 中設定
export PICO_SDK_PATH="$HOME/pico/pico-sdk"
```

### NPM 全域軟體包

```bash
# 恢復 NPM 全域軟體包
npm install -g $(cat ~/.npm-global-packages.txt)

# 或使用已安裝的列表
cat "$BACKUP_DIR/npm-global-packages.txt" | xargs npm install -g
```

---

## 輸入法配置恢復

### Fcitx5 配置

```bash
# 恢復 Fcitx5 配置
cp -r "$BACKUP_DIR/config/fcitx5" ~/.config/

# 重啟 Fcitx5
fcitx5 -d
```

### 啟用繁體中文輸入法

```bash
# 確保安裝了正確的輸入法
yay -S fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool
yay -S fcitx5-chewing fcitx5-mcbopomofo-git

# 編輯 ~/.config/fcitx5/profile 以啟用輸入法
```

---

## 驗證恢復完整性

恢復後，使用以下命令驗證：

```bash
# 檢查 shell 配置是否生效
echo $PATH
cat ~/.bashrc | grep "get_idf"

# 檢查 Git 配置
git config --list

# 檢查 NPM 配置
npm config list

# 檢查已安裝軟體包
pacman -Q | wc -l  # 應該與原系統軟體包數量相同

# 檢查輸入法是否正常
fcitx5 -d
```

---

## 常見問題排除

### 1. 軟體包安裝失敗

如果某些 AUR 軟體包無法安裝：
```bash
yay -S 軟體包名稱 --noconfirm --editmenu
```

### 2. 配置文件權限問題

如果恢復後出現權限問題：
```bash
chmod -R 755 ~/.local
chmod -R 700 ~/.ssh  # 如果有 SSH 密鑰
```

### 3. GNOME 設定不同步

有時 GNOME 設定可能需要重新應用：
```bash
# 重置 GNOME 設定
dconf reset -f /
# 然後恢復備份的配置
```

---

## 總結

通過遵循本指南，你可以：
✅ 備份所有關鍵配置文件  
✅ 在新系統上快速復製整個開發環境  
✅ 保留所有自訂設置和開發工具配置  
✅ 確保開發工作流的連續性  

推薦在進行任何系統變更前都進行一次完整備份。
