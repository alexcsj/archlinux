# 快速安裝檢查清單 - 聯想小新 Duet 2022

## 📋 環境複製 - 3 步驟完成

### 第一步：系統安裝（1-2 小時）

```bash
# 1. 從 USB 啟動並安裝 Arch Linux
# 2. 安裝 Linux Zen 內核
sudo pacman -S linux-zen linux-zen-headers

# 3. 系統更新
sudo pacman -Syu

# 4. 安裝基礎開發工具
sudo pacman -S base-devel git curl wget

# 5. 安裝 yay（AUR 助手）
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si && cd ..
```

### 第二步：批量安裝軟體包（30-45 分鐘）

```bash
# 方法 A：使用備份的軟體包列表
sudo pacman -Syu
cat installed-packages.txt | awk '{print $1}' | \
    xargs sudo pacman -S --noconfirm

# 方法 B：分類安裝（如果方法 A 有問題）
# 請參照 environment-setup-guide.md 中的分類安裝部分
```

### 第三步：恢復配置（15 分鐘）

```bash
# 1. 解壓配置備份
tar -xzf system-config-backup-*.tar.gz

# 2. 運行恢復腳本
chmod +x restore-config.sh
./restore-config.sh

# 3. 重啟系統
reboot
```

---

## 🎯 核心軟體包速查表

| 類別 | 軟體 | 安裝命令 |
|------|------|---------|
| **系統** | Linux Zen | `pacman -S linux-zen` |
| **桌面** | GNOME | `pacman -S gnome-shell gdm` |
| **開發** | GCC | `pacman -S gcc make` |
| **Python** | Python 3 | `pacman -S python python-pip` |
| **Node.js** | Node | `pacman -S nodejs npm` |
| **IDE** | VS Code | `yay -S visual-studio-code-bin` |
| **版本控制** | Git | `pacman -S git github-cli` |
| **Docker** | Docker | `pacman -S docker docker-compose` |
| **Java** | JDK | `pacman -S jdk-openjdk` |
| **輸入法** | Fcitx5 | `pacman -S fcitx5 fcitx5-chewing` |
| **瀏覽器** | Chrome | `yay -S google-chrome` |
| **媒體** | PipeWire | `pacman -S pipewire pipewire-pulse` |
| **音訊工具** | 串流工具 | `pacman -S strawberry` |

---

## ⚙️ 硬體特定配置（聯想小新 Duet 2022）

### 重點配置清單

```bash
# 1️⃣ 觸屏驅動（自動支援，無需手動）
pacman -S libinput xf86-input-libinput

# 2️⃣ 高 DPI 屏幕縮放（需要手動調整）
# 進入 GNOME 設定 > 顯示 > 縮放
# 建議選擇 125% 或 150%

# 3️⃣ 音訊系統（已包含 PipeWire）
pacman -S pipewire pipewire-alsa pipewire-pulse wireplumber

# 4️⃣ 電池管理（強烈推薦）
sudo pacman -S tlp tlp-rdw
sudo systemctl enable tlp
sudo systemctl start tlp

# 5️⃣ 亮度控制
sudo pacman -S brightnessctl
brightnessctl set 50%  # 調整亮度

# 6️⃣ WiFi 6E 和藍牙（驅動通常自動加載）
sudo pacman -S linux-firmware wireless-regdb

# 7️⃣ 屏幕旋轉支援
sudo pacman -S iio-sensor-proxy
# 在 GNOME 設定中啟用自動旋轉

# 8️⃣ 手勢支援
yay -S libinput-gestures
systemctl --user enable libinput-gestures
systemctl --user start libinput-gestures
```

---

## 📁 關鍵配置文件位置

| 配置項 | 位置 |
|--------|------|
| Shell 配置 | `~/.bashrc`, `~/.bash_profile` |
| Git 配置 | `~/.gitconfig` |
| NPM 配置 | `~/.npmrc` |
| VS Code | `~/.config/Code/` |
| GNOME 設定 | `~/.config/dconf/` |
| Fcitx5 | `~/.config/fcitx5/` |
| 自訂腳本 | `~/.local/bin/` |
| 開發工具 | `~/.espressif/`, `~/.gradle/` |

---

## 🔧 常用命令速查

### 系統管理

```bash
# 更新系統
sudo pacman -Syu

# 安裝軟體包
sudo pacman -S 軟體包名稱
yay -S AUR軟體包名稱

# 卸載軟體包
sudo pacman -R 軟體包名稱

# 搜尋軟體包
pacman -Ss 搜尋詞
yay 搜尋詞

# 查看已安裝軟體包
pacman -Q | wc -l  # 總數
pacman -Q --foreign  # 只顯示 AUR 軟體包
```

### 開發工具

```bash
# 初始化 Git 倉庫
git init
git config --global user.name "你的名字"
git config --global user.email "你的郵箱"

# Python 虛擬環境
python -m venv venv
source venv/bin/activate

# NPM 全域軟體包
npm install -g 軟體包名稱

# Docker 容器
docker run -it ubuntu:latest

# 啟用嵌入式開發工具
source ~/.espressif/tools/activate_idf_v6.1.sh
# 或使用別名：get_idf
```

### 電源管理

```bash
# 檢查電池狀態
tlp-stat -b

# 查看電源消耗
powertop

# 進入睡眠
systemctl suspend

# 調整亮度
brightnessctl set 50%
light -S 50

# 檢查溫度
sensors
```

### 音訊調試

```bash
# 列出音訊設備
pactl list sinks
pactl list sources

# 調整音量
amixer set Master 100%
pactl set-sink-volume @DEFAULT_SINK@ 100%

# 測試揚聲器
speaker-test -t sine -f 1000 -l 2

# 測試麥克風
arecord -d 5 test.wav && aplay test.wav
```

### 網路配置

```bash
# 連接 WiFi
nmtui  # 互動界面
# 或命令行
nmcli device wifi connect "SSID" password "密碼"

# 連接藍牙設備
bluetoothctl
> scan on
> pair [MAC]
> connect [MAC]

# 檢查網路連接
nmcli connection show
nmcli device show
```

---

## 📊 安裝統計

**原始系統配置：**
- 總軟體包數：**1000+**
- 開發工具：**200+**
- 多媒體庫：**100+**
- 系統工具：**70+**
- 桌面應用：**150+**

**估計安裝時間（聯想小新 Duet 2022）：**
- 系統安裝：30-60 分鐘
- 軟體包安裝：45-90 分鐘（取決於網速）
- 配置恢復：15-30 分鐘
- **總計：90-180 分鐘（1.5-3 小時）**

---

## ✅ 安裝後驗證清單

```bash
# 檢查系統
uname -a
cat /etc/os-release

# 驗證軟體包安裝
pacman -Q | wc -l  # 應該超過 1000

# 驗證 GNOME 桌面
gnome-shell --version

# 驗證開發工具
gcc --version
python --version
node --version
docker --version

# 驗證觸屏
xinput list | grep -i touch
# 或 Wayland
cat /proc/bus/input/devices | grep -i touch

# 驗證音訊
pactl list sinks
aplay -l

# 驗證 WiFi
iwconfig
# 或
nmcli device show

# 驗證輸入法
fcitx5 --version
```

---

## 🚀 首次啟動後的必做事項

1. **配置輸入法**
   - 進入 GNOME 設定 > 鍵盤 > 輸入法
   - 新增 Fcitx5 並選擇繁體中文輸入法

2. **調整屏幕顯示**
   - 設定 > 顯示 > 縮放（125% 或 150%）
   - 設定 > 顯示 > 刷新率（保持 90Hz）

3. **啟用自動旋轉**
   - 設定 > 顯示 > 自動旋轉屏幕

4. **配置亮度和電源**
   - 設定 > 電源 > 選擇電源配置文件
   - 啟用 TLP 服務以優化電池壽命

5. **配置 Git**
   ```bash
   git config --global user.name "你的名字"
   git config --global user.email "你的郵箱"
   ```

6. **配置開發工具**
   ```bash
   # 激活 ESP-IDF
   source ~/.espressif/tools/activate_idf_v6.1.sh
   
   # 驗證 Pico SDK
   echo $PICO_SDK_PATH
   ```

---

## 📞 常見問題快速解決

| 問題 | 解決方案 |
|------|---------|
| 軟體包衝突 | `sudo pacman -Syu --overwrite "*"` |
| WiFi 無法連接 | `sudo systemctl restart NetworkManager` |
| 觸屏無回應 | `sudo modprobe -r hid_generic && sudo modprobe hid_generic` |
| 音訊無聲 | `amixer set Master unmute` |
| 電池快速耗盡 | `sudo tlp start` 和 `brightnessctl set 30%` |
| 屏幕撕裂 | 在 GNOME 設定中啟用 VSYNC |

---

## 📚 相關文件

- **詳細安裝指南：** `environment-setup-guide.md`
- **配置備份恢復：** `configuration-backup-guide.md`
- **硬體適配指南：** `lenovo-duet-2022-adaptation.md`
- **軟體包列表：** `installed-packages.txt`
- **AUR 軟體包清單：** `aur-packages.txt`

---

## 💡 最佳實踐建議

✅ **定期備份配置**
```bash
./backup-config.sh  # 每月執行一次
```

✅ **保持系統更新**
```bash
sudo pacman -Syu  # 每周執行一次
```

✅ **監控系統健康**
```bash
# 定期檢查磁碟空間
df -h
# 檢查包管理器緩存
du -sh /var/cache/pacman/
# 清理舊軟體包
sudo pacman -Sc
```

✅ **備份重要數據**
```bash
rsync -av ~/Documents/ /backup/Documents/
```

---

**最後更新：** 2026-09-11  
**應用於：** Arch Linux + GNOME + 聯想小新 Duet 2022
