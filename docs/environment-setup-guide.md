# 電腦環境配置清單 - 環境複製指南

## 系統資訊

**原始系統配置：**
- **發行版：** Arch Linux（滾動發行版）
- **內核：** Linux 7.1.9-zen1-2 (Zen 優化版本)
- **架構：** x86_64
- **硬體：** AMD Ryzen 8845HS (移動版)

## 安裝步驟概覽

### 第一步：安裝基礎系統

1. **安裝 Arch Linux**
   - 下載 Arch Linux ISO
   - 依照官方安裝指南安裝基礎系統
   - 安裝 Linux Zen 內核（而非標準 Linux 內核）
     ```bash
     pacman -S linux-zen linux-zen-headers
     ```

2. **系統初始化**
   ```bash
   pacman -S base-devel
   pacman -S amd-ucode linux-firmware
   ```

---

## 軟體包分類安裝清單

### 1. 核心系統和工具 (70+ 套件)

**檔案系統和磁碟工具：**
```bash
pacman -S btrfs-progs cryptsetup device-mapper e2fsprogs mdadm lvm2
pacman -S udisks2 udiskie dosfstools ntfs-3g cifs-utils nfs-utils
pacman -S exfat-utils
```

**系統工具：**
```bash
pacman -S sudo util-linux sysstat lsof iotop htop
pacman -S tmux screen curl wget rsync openssh
pacman -S grep sed gawk findutils which
pacman -S pacman-contrib yay
```

**網路工具：**
```bash
pacman -S dnsmasq nftables iptables iproute2 iputils
pacman -S bind-tools net-tools traceroute mtr
pacman -S wpa_supplicant networkmanager nm-connection-editor
pacman -S bluez bluez-utils bluez-obex
```

---

### 2. 桌面環境和圖形界面 (150+ 套件)

**GNOME 桌面環境（主要桌面）：**
```bash
pacman -S gnome-shell gdm gnome-control-center mutter
pacman -S gnome-terminal gnome-text-editor nautilus
pacman -S gnome-calendar gnome-calculator gnome-clocks
pacman -S gnome-system-monitor gnome-settings-daemon
pacman -S gnome-keyring gnome-session gnome-backgrounds
pacman -S gnome-user-docs gnome-tour evolution-data-server
```

**相關的視覺套件：**
```bash
pacman -S adwaita-icon-theme adwaita-icon-theme-legacy
pacman -S adwaita-fonts adwaita-cursors default-cursors
pacman -S hicolor-icon-theme shared-mime-info
```

**GNOME 擴充功能：**
```bash
yay -S gnome-shell-extension-dash-to-dock gnome-shell-extension-appindicator
```

**其他桌面應用：**
```bash
pacman -S nautilus baobab eog evince loupe simple-scan sushi
pacman -S gnome-weather gnome-maps gnome-connections
pacman -S papers orca extension-manager
```

**媒體播放器和工具：**
```bash
pacman -S gnome-mpv mpv strawberry totem-pl-parser
pacman -S ffmpeg imagemagick ghostscript
```

---

### 3. 開發工具和編譯器 (200+ 套件)

**編譯工具鏈：**
```bash
pacman -S base-devel gcc gcc-libs glibc binutils
pacman -S make cmake ninja autoconf automake
pacman -S pkgconf meson
```

**版本控制：**
```bash
pacman -S git github-cli
```

**C/C++ 開發：**
```bash
pacman -S gdb valgrind ccache cmake ninja
pacman -S boost boost-libs
```

**Python 開發：**
```bash
pacman -S python python-pip python-setuptools python-wheel
pacman -S python-psutil python-yaml python-lxml
```

**嵌入式/IoT 開發：**
```bash
pacman -S arm-none-eabi-gcc arm-none-eabi-binutils arm-none-eabi-newlib
pacman -S dfu-util
# 特別工具
yay -S agy herdr  # 自定義工具
```

**Java 開發：**
```bash
pacman -S jdk-openjdk java-environment-common java-runtime-common
```

**Node.js/JavaScript：**
```bash
pacman -S nodejs npm
# npm 全域工具已配置於 ~/.npm-global
```

**Kotlin 開發：**
```bash
pacman -S kotlin
```

**其他開發工具：**
```bash
pacman -S curl wget git rsync openssh
pacman -S man-db man-pages texinfo
```

---

### 4. 文字編輯器和 IDE

**主要 IDE：**
```bash
yay -S visual-studio-code-bin
yay -S android-studio
```

**文字編輯器：**
```bash
pacman -S vim nano gedit
```

**其他開發工具：**
```bash
pacman -S gnome-text-editor
```

---

### 5. 多媒體和聲音系統 (100+ 套件)

**音頻系統：**
```bash
pacman -S pipewire pipewire-alsa pipewire-jack pipewire-pulse
pacman -S alsa-lib alsa-utils alsa-card-profiles alsa-topology-conf alsa-ucm-conf
pacman -S alsa-plugins pulseaudio-utils
pacman -S wireplumber libpipewire gst-plugin-pipewire
```

**音樂播放器：**
```bash
pacman -S strawberry fluidsynth libao
```

**聲音編輯：**
```bash
pacman -S sox libsndfile libsamplerate
```

**音頻編碼：**
```bash
pacman -S lame faac libfdk-aac opus flac vorbis wavpack
pacman -S speex speexdsp gsm libopenmpt
```

**影片編碼和處理：**
```bash
pacman -S ffmpeg libavif libwebp libheif libde265 dav1d
pacman -S libvpx libx264 x265 libx265 rav1e svt-av1
pacman -S libxcvt harfbuzz
```

---

### 6. 輸入法系統 (中文輸入)

**Fcitx5 + 繁體中文輸入法：**
```bash
pacman -S fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool
pacman -S fcitx5-chewing ibus-chewing  # 注音輸入法
yay -S fcitx5-mcbopomofo-git  # 台灣繁體符號和標點
yay -S fcitx5-mozc  # 日文（可選）
```

**IBus（備選）：**
```bash
pacman -S ibus ibus-chewing
```

---

### 7. 圖形和遊戲 (150+ 套件)

**圖形驅動：**
```bash
pacman -S xf86-video-amdgpu xf86-video-ati
pacman -S libva vulkan-radeon vulkan-mesa-implicit-layers
pacman -S mesa lib32-mesa vulkan-icd-loader lib32-vulkan-icd-loader
```

**遊戲和遊戲工具：**
```bash
yay -S steam steam-devices protonup-qt
pacman -S wine
```

**OpenGL 和圖形庫：**
```bash
pacman -S glfw-x11 glew glm glu libglvnd libepoxy
pacman -S freeglut glslang spirv-tools vulkan-tools
pacman -S shaderc capstone
```

**影像處理：**
```bash
pacman -S gimp inkscape krita imagemagick
```

**視覺效果：**
```bash
pacman -S cairo cairomm graphene pixman
```

---

### 8. 通訊和雲端工具

**雲端服務：**
```bash
yay -S baidunetdisk-bin  # 百度網盤
pacman -S evolution-data-server gnome-online-accounts
```

**遠端桌面/虛擬化：**
```bash
pacman -S qemu-system-x86 qemu-common edk2-ovmf
pacman -S freerdp gtk-vnc libvncserver spice-gtk
pacman -S virt-manager libvirt
```

---

### 9. 瀏覽器和網路

**網頁瀏覽器：**
```bash
yay -S google-chrome
pacman -S firefox epiphany  # 備選
```

**網路工具：**
```bash
pacman -S curl wget rsync openssh
```

---

### 10. 文件處理和辦公

**文件檢視：**
```bash
pacman -S evince poppler-glib ghostscript djvulibre libspectre
pacman -S libreoffice  # 辦公套件
```

**檔案壓縮：**
```bash
pacman -S 7zip zip unzip bzip2 xz zstd brotli
yay -S rar peazip  # 商業和備選工具
```

---

### 11. 系統安全和加密

**加密和密鑰管理：**
```bash
pacman -S gnupg gpgme libsecret libsecret
pacman -S openssh openssl gnutls
pacman -S cracklib libpwquality
pacman -S cryptsetup tpm2-tss
```

---

### 12. 虛擬化和容器

**Docker 和容器：**
```bash
pacman -S docker docker-compose containerd runc
pacman -S bubblewrap
```

**其他虛擬化：**
```bash
pacman -S qemu libvirt edk2-ovmf
```

---

### 13. 硬體支援

**輸入設備：**
```bash
pacman -S xpadneo-dkms
pacman -S libinput libwacom bluez bluez-utils
```

**感應器：**
```bash
pacman -S iio-sensor-proxy geoclue
```

---

### 14. 特殊應用

**播放器和多媒體：**
```bash
yay -S csjplayer  # 自定義播放器
yay -S xnviewmp  # 圖片檢視器
```

**音樂播放器：**
```bash
pacman -S strawberry foobar2000  # 需要通過 wine 或 flatpak
```

**其他：**
```bash
yay -S currencycal  # 貨幣計算機
pacman -S zenity  # 對話框工具
```

---

### 15. 開發相關配置

**ESP-IDF 開發（已配置）：**
```bash
# ~/.espressif/tools/activate_idf_v6.1.sh 已配置
# 在 ~/.bashrc 中有別名：alias get_idf='. $HOME/.espressif/tools/activate_idf_v6.1.sh'
```

**Pico SDK（已配置）：**
```bash
# PICO_SDK_PATH=$HOME/pico/pico-sdk（在 ~/.bashrc 中已設定）
```

**自定義腳本（在 ~/.local/bin 中）：**
```bash
# ensure-wd-tmux.sh - tmux session 管理腳本
# voice-input-daemon.py - 語音輸入守護進程
# voice-input-toggle.sh - 語音輸入切換指令稿
```

---

## 關鍵配置文件

### 用戶配置：

1. **~/.bashrc** - Shell 配置
   - PATH 包含 ~/.local/bin 和 ~/.npm-global/bin
   - ESP-IDF 別名配置
   - Pico SDK 路徑設定

2. **~/.bash_profile** - 登入 shell 配置

3. **~/.gitconfig** - Git 設定

4. **~/.npmrc** - NPM 設定

5. **~/.config/** - 應用配置目錄
   - GNOME 設定
   - 開發工具配置

### 系統配置：

1. **/etc/pacman.conf** - 軟體包管理器設定
2. **/etc/systemd/resolved.conf** - DNS 設定（使用 systemd-resolved）
3. Wayland 環境（GNOME 預設）

---

## 安裝順序建議

### 第一階段：基礎系統（必須）
1. 安裝基礎 Arch Linux
2. 安裝 Linux Zen 內核
3. 安裝系統工具和基礎開發工具

### 第二階段：桌面環境（推薦）
1. 安裝 GNOME 桌面環境
2. 安裝圖形驅動
3. 安裝基礎應用

### 第三階段：開發工具
1. 安裝編譯工具鏈
2. 安裝語言運行環境（Python、Node.js、Java 等）
3. 安裝 IDE 和編輯器

### 第四階段：特殊工具（按需）
1. 嵌入式開發工具
2. 遊戲和多媒體工具
3. 其他特殊應用

### 第五階段：用戶配置
1. 複製配置文件到 ~/.config/
2. 複製 ~/.bashrc 和其他 dotfiles
3. 設定 ESP-IDF 和 Pico SDK
4. 配置輸入法

---

## 快速安裝腳本

將以下內容保存為 `install.sh`，在新系統上執行：

```bash
#!/bin/bash

# 更新系統
sudo pacman -Syu

# 安裝基礎工具
sudo pacman -S base-devel git curl wget

# 安裝 yay（AUR 助手）
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..

# 安裝必要軟體包組
# 可根據需要選擇性執行以上的 pacman -S 和 yay -S 命令

# 複製配置文件
# cp 原始系統的配置到新系統

# 完成
echo "環境安裝完成！"
```

---

## 特別注意事項

### 聯想小新 Duet 2022 適配

**聯想小新 Duet 2022 硬體特性：**
- 12.7 英吋 OLED 屏幕
- Intel Pentium 或 Core i3/i5（取決於型號）
- 8-16GB RAM
- 128-256GB SSD

**可能需要的調整：**
1. 觸屏驅動支持（需要 Wayland 或特殊配置）
2. 鍵盤和觸控板驅動
3. 電池管理工具：TLP 或 power-profiles-daemon
4. 屏幕亮度和 HDMI 輸出控制

**額外推薦軟體包：**
```bash
pacman -S tlp power-profiles-daemon brightnessctl xorg-xbacklight
pacman -S libinput gesture 工具支持觸屏手勢
```

---

## 相關資源

- **Arch Linux 官方文檔：** https://wiki.archlinux.org/
- **AUR（Arch 用戶倉庫）：** https://aur.archlinux.org/
- **Arch Linux CN 社群倉庫：** https://www.archlinuxcn.org/

---

## 總結

此系統共安裝了 **1000+ 軟體包**，涵蓋：
- ✅ 桌面環境和圖形界面
- ✅ 完整的開發工具鏈
- ✅ 多媒體和音頻系統
- ✅ 遊戲和虛擬化支持
- ✅ 嵌入式開發工具
- ✅ 雲端和網路工具
- ✅ 中文輸入法系統

根據聯想小新 Duet 2022 的硬體特性和你的使用需求，可以選擇性地安裝相應的軟體包。
