# 聯想小新 Duet 2022 - Linux 環境適配指南

## 硬體規格

### 處理器和內存
- **處理器：** Intel MediaTek MT8195 或 Intel Pentium/Core i3 (取決於型號)
- **內存：** 8GB 或 16GB LPDDR5
- **存儲：** 128GB 或 256GB UFS/SSD

### 屏幕
- **尺寸：** 12.7 英吋 (16:10 縱橫比)
- **分辨率：** 2560 × 1600 像素 (OLED)
- **刷新率：** 90Hz
- **觸屏：** 10 點多點觸控

### 連接和端口
- **USB-C：** 1 個（支持 Thunderbolt 4，取決於型號）
- **耳機孔：** 3.5mm
- **讀卡器：** microSD 卡槽
- **無線：** WiFi 6E（802.11ax），藍牙 5.2
- **HDMI：** 不適用（通過 USB-C 轉接）

### 電源
- **電池容量：** 10200 mAh（約 37.74 Wh）
- **充電：** 65W USB-C PD 快速充電

---

## 安裝前準備

### 1. 檢查硬體相容性

在安裝 Arch Linux 前，確保：
- ✅ BIOS/UEFI 支持 USB 啟動
- ✅ 可以禁用 Secure Boot（Arch 安裝所需）
- ✅ 有可用的 U 盤或外接 SSD（用於安裝媒體）

### 2. 備份原始系統

```bash
# 使用 dd 備份 Windows/ChromeOS 分區（在其他電腦上執行）
sudo dd if=/dev/sdX of=original-backup.img bs=4M status=progress
```

### 3. 準備安裝媒體

```bash
# 下載 Arch Linux ISO
wget https://archlinux.org/iso/latest/archlinux-x86_64.iso

# 在 U 盤上寫入 ISO
sudo dd if=archlinux-x86_64.iso of=/dev/sdX bs=4M status=progress sync
```

---

## 特殊驅動和配置

### 1. 觸屏驅動

Arch Linux 通常自動支持觸屏，但需要確保：

```bash
# 安裝必要的 libinput 驅動
sudo pacman -S libinput xf86-input-libinput

# 檢查觸屏設備
xinput list  # 針對 X11
# 或
cat /proc/bus/input/devices | grep -i touch
```

### 2. 高 DPI 屏幕優化

由於 Duet 2022 屏幕密度高（228 PPI），需要配置 DPI 縮放：

#### GNOME 顯示設定

```bash
# 進入 GNOME 設定 > 顯示 > 縮放
# 建議選擇 125% 或 150% 縮放
```

#### 或通過 dconf 設定

```bash
# 設定全域縮放比例
dconf write /org/gnome/desktop/interface/scaling-factor 2  # 200% 縮放

# 或按監視器設定
gsettings set org.gnome.screen-display scale-monitors true
```

#### 手動 X11 配置

在 `/etc/X11/xorg.conf.d/90-monitor.conf` 中：

```ini
Section "Monitor"
    Identifier "HDMI-1"  # 修改為你的監視器 ID
    Option "DPI" "192 x 192"  # 根據屏幕密度調整
EndSection
```

### 3. 鍵盤和觸控板驅動

#### 檢查設備

```bash
# 列出輸入設備
lsusb  # 查看 USB 設備
# 或
cat /proc/bus/input/devices
```

#### 安裝輸入法驅動

```bash
sudo pacman -S xf86-input-evdev xf86-input-synaptics
```

#### 觸控板手勢支持

```bash
# 安裝 libinput-gestures
yay -S libinput-gestures

# 配置手勢
mkdir -p ~/.config/libinput-gestures.conf
# 編輯配置文件以定義手勢
```

### 4. 網路驅動

#### WiFi 6E 支援

```bash
# 檢查 WiFi 驅動
lspci | grep -i network
lsmod | grep -i wifi

# 通常需要安裝
sudo pacman -S linux-firmware wireless-regdb
```

#### 藍牙支援

```bash
# 已包含在基礎安裝中
sudo pacman -S bluez bluez-utils bluez-obex

# 啟用藍牙服務
sudo systemctl enable bluetooth
sudo systemctl start bluetooth
```

### 5. 音訊系統配置

由於 Duet 2022 有立體聲揚聲器和麥克風：

```bash
# 使用 PipeWire（推薦用於平板）
sudo pacman -S pipewire pipewire-alsa pipewire-pulse wireplumber

# 檢查音訊設備
pactl list sinks  # 查看揚聲器
pactl list sources  # 查看麥克風

# 測試揚聲器
speaker-test -t sine -f 1000 -l 3

# 測試麥克風
arecord -d 5 test.wav && aplay test.wav
```

### 6. 攝像頭支援

如果配備攝像頭：

```bash
# 檢查攝像頭設備
ls /dev/video*

# 安裝 FFmpeg 以測試攝像頭
ffplay /dev/video0

# 或使用 Cheese（GNOME 攝影應用）
sudo pacman -S gnome-photos
```

### 7. 電池和電源管理

#### 安裝電源管理工具

```bash
# TLP（推薦用於平板，優先考慮電池壽命）
sudo pacman -S tlp tlp-rdw

# 啟用 TLP
sudo systemctl enable tlp
sudo systemctl mask systemd-rfkill.socket
sudo systemctl start tlp

# 檢查電池狀態
tlp-stat -b
```

#### 或使用 power-profiles-daemon

```bash
sudo pacman -S power-profiles-daemon

sudo systemctl enable power-profiles-daemon
sudo systemctl start power-profiles-daemon

# 查看可用配置文件
powerprofilesctl list

# 設定為節電模式
powerprofilesctl set power-saver
```

#### 亮度控制

```bash
# 安裝亮度控制工具
sudo pacman -S brightnessctl light

# 調整亮度
brightnessctl set 50%
brightnessctl set 100%

# 或
light -S 50  # 設為 50%
light -A 10  # 增加 10%
light -U 10  # 減少 10%
```

### 8. 懸掛和睡眠配置

編輯 `/etc/systemd/sleep.conf`：

```ini
[Sleep]
SuspendMode=mem s2idle
HibernateMode=platform shutdown
```

測試睡眠：
```bash
# 進入睡眠
systemctl suspend

# 進入休眠（需要交換空間）
systemctl hibernate

# 混合睡眠
systemctl hybrid-sleep
```

---

## OLED 屏幕特殊考慮

### 烧屏風險

由於 OLED 屏幕的特性，需要採取以下措施：

```bash
# 安裝屏幕保護程序
sudo pacman -S xscreensaver gnome-screensaver

# 在 GNOME 設定中啟用屏幕鎖定和暗屏
```

### 屏幕亮度和對比度優化

```bash
# 使用 gnome-control-center 調整顯示設定
# 或編輯 /etc/X11/xorg.conf.d/20-amdgpu.conf

Section "Device"
    Identifier "AMDGPU 0"
    Driver "amdgpu"
    Option "VariableBrightness" "on"
EndSection
```

---

## 觸控和手勢支援

### 1. 啟用觸控功能

```bash
# 檢查 Wayland 是否在使用中（GNOME 預設）
echo $XDG_SESSION_TYPE
```

### 2. 配置觸控手勢

安裝手勢工具：

```bash
# 使用 libinput-gestures 進行手勢識別
yay -S libinput-gestures

# 配置示例 ~/.config/libinput-gestures.conf
# 三指滑動應用切換
gesture swipe up 3 xdotool key alt+Tab

# 三指滑動返回
gesture swipe down 3 xdotool key alt+shift+Tab

# 捏合放大/縮小
gesture pinch in xdotool key ctrl+minus
gesture pinch out xdotool key ctrl+plus
```

### 3. 啟用並運行手勢守護進程

```bash
# 以用戶模式運行
systemctl --user enable libinput-gestures
systemctl --user start libinput-gestures

# 或手動運行
libinput-gestures-setup start
```

---

## 分辨率和顯示配置

### 檢查支援的分辨率

```bash
# 使用 xrandr（X11）
xrandr --query

# 使用 wayland-info（Wayland）
wayland-info
```

### 設定分辨率

#### 使用 GNOME 設定
進入 **設定 > 顯示** 以調整分辨率和刷新率

#### 使用命令行
```bash
# 對於 X11
xrandr --output HDMI-1 --mode 2560x1600 --rate 90.00

# 對於 Wayland（通過 GNOME 設定或 dconf）
dconf write /org/gnome/mutter/monitor-resolution 2560x1600
```

---

## USB Type-C 多功能適配

### 連接外接設備

由於 Duet 2022 只有一個 USB-C 端口，建議購買多功能適配器：

```bash
# 支援的設備
# - USB 3.1 外接硬碟
# - HDMI 顯示器（需 USB-C to HDMI）
# - USB 集線器以連接多個設備
```

### USB-C 設備識別

```bash
# 列出 USB 設備
lsusb

# 檢查 USB-C 設備
cat /sys/class/typec/*/oper_mode_default
```

---

## 特定應用優化

### 提高平板用戶體驗

```bash
# 安裝觸控優化的應用
sudo pacman -S gnome-maps gnome-calculator gnome-calendar

# 安裝觸控友善的輸入法
yay -S fcitx5-chewing fcitx5-mcbopomofo-git

# 安裝平板友善的瀏覽器
sudo pacman -S firefox chromium
```

### 旋轉屏幕支援

```bash
# 檢查陀螺儀傳感器
cat /sys/bus/iio/devices/iio:device*/name | grep -i accel

# 安裝屏幕旋轉工具
yay -S iio-sensor-proxy

# 在 GNOME 設定中啟用自動旋轉
# 設定 > 顯示 > 自動旋轉
```

### 分割視圖支援

GNOME 42+ 支持自動分割視圖（Snap Layout）：

```bash
# 將視窗拖到屏幕邊緣以自動分割視圖
# 這對於寬屏平板非常有用
```

---

## 系統調優建議

### 1. 禁用不必要的服務

```bash
# 如果不使用 Bluetooth
sudo systemctl disable bluetooth

# 如果不使用藍牙 RFKILL 管理
sudo systemctl mask rfkill
```

### 2. 啟用 zstd 壓縮（加快軟體包）

編輯 `/etc/makepkg.conf`：

```bash
# 尋找 PKGEXT 行並修改
PKGEXT='.pkg.tar.zst'

# 編譯時選項
COMPRESSZST=(zstd -c -T0 -19 -)
```

### 3. 優化 pacman 並行下載

編輯 `/etc/pacman.conf`：

```ini
# 取消以下行的註釋
ParallelDownloads = 5
```

### 4. 啟用 SSD 優化

```bash
# 啟用 TRIM
sudo systemctl enable fstrim.timer
sudo systemctl start fstrim.timer

# 檢查 SSD 健康狀態（如支援 NVME）
sudo nvme smart-log /dev/nvme0n1
```

---

## 故障排除

### 觸屏無回應

```bash
# 重啟 libinput
sudo systemctl restart libinput

# 或重新載入驅動
sudo modprobe -r hid_generic && sudo modprobe hid_generic
```

### 電池快速耗盡

```bash
# 檢查電源消耗
powertop

# 啟用 TLP 的節電模式
sudo tlp start

# 檢查背光亮度
cat /sys/class/backlight/*/brightness
```

### WiFi 連接問題

```bash
# 重啟網路管理員
sudo systemctl restart NetworkManager

# 檢查 WiFi 驅動
sudo lspci -k | grep -A2 Network

# 重新載入 WiFi 模組
sudo modprobe -r iwlwifi && sudo modprobe iwlwifi
```

### 音訊無聲

```bash
# 檢查音訊設備
aplay -l

# 取消靜音
amixer set Master unmute

# 調整音量
amixer sset Master 100%

# 使用 pavucontrol 圖形界面調整
sudo pacman -S pavucontrol
pavucontrol
```

---

## 安裝檢查清單

- [ ] BIOS 中禁用 Secure Boot
- [ ] 完成 Arch Linux 基礎安裝
- [ ] 安裝 Linux Zen 內核
- [ ] 安裝 Intel/AMD 微碼
- [ ] 安裝顯示驅動（如需要）
- [ ] 安裝觸屏驅動和 libinput
- [ ] 配置高 DPI 縮放
- [ ] 安裝 WiFi 和藍牙驅動
- [ ] 配置音訊系統
- [ ] 安裝電源管理工具（TLP）
- [ ] 配置屏幕亮度控制
- [ ] 測試攝像頭（如有）
- [ ] 配置屏幕旋轉
- [ ] 安裝手勢識別工具
- [ ] 安裝中文輸入法
- [ ] 測試所有連接功能

---

## 參考資源

- **Arch Linux 安裝指南：** https://wiki.archlinux.org/title/Installation_guide
- **Wayland 支援：** https://wiki.archlinux.org/title/Wayland
- **觸屏支援：** https://wiki.archlinux.org/title/Touchscreen
- **電源管理：** https://wiki.archlinux.org/title/Power_management
- **TLP 文檔：** https://linrunner.de/en/tlp/
- **手勢支援：** https://github.com/bulletmark/libinput-gestures

---

## 總結

聯想小新 Duet 2022 是一台性能強大的 Linux 平板，Arch Linux 提供了完全的靈活性和性能優化。通過遵循本指南，你可以在這台設備上創建一個功能完整、性能優良的開發環境。
