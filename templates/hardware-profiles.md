# 硬體配置文件

本文檔定義了不同硬體設備的特殊配置參數。

## 配置格式

```yaml
# hardware-profiles.yaml 格式示例
device:
  name: "設備名稱"
  type: "laptop|tablet|desktop|server"
  cpu: "處理器型號"
  ram: "記憶體大小 (GB)"
  storage: "存儲容量 (GB)"
  
features:
  touchscreen: true|false
  battery: true|false
  fingerprint: true|false
  
optimizations:
  - "優化項 1"
  - "優化項 2"
  
drivers:
  - package: "驅動套件名稱"
    version: "版本"
    purpose: "用途說明"

special_packages:
  - name: "特殊軟體包"
    reason: "安裝原因"
```

---

## 支援的硬體配置

### 1. 通用 x86_64 (generic)

**適用於：** 台式電腦、標準筆記本

```yaml
device:
  name: "Generic x86_64"
  type: "desktop"
  
features:
  touchscreen: false
  battery: false
  
optimizations:
  - "標準桌面優化"
  - "風冷系統"
```

**安裝命令：**
```bash
./scripts/install.sh --hardware generic
```

### 2. 聯想小新 Duet 2022 (duet-2022)

**適用於：** 聯想小新 Duet 2022 平板

```yaml
device:
  name: "Lenovo Duet 2022"
  type: "tablet"
  cpu: "Intel MediaTek MT8195 / Core i3/i5"
  ram: "8GB / 16GB"
  storage: "128GB / 256GB"
  
features:
  touchscreen: true
  battery: true
  fingerprint: false
  
screen:
  size: "12.7 inch"
  resolution: "2560x1600"
  type: "OLED"
  refresh_rate: "90Hz"
  
optimizations:
  - "高 DPI 縮放 (125-150%)"
  - "電池電源管理"
  - "屏幕旋轉支援"
  - "觸屏手勢"
  - "OLED 烧屏防護"
  
drivers:
  - package: "libinput"
    purpose: "觸屏驅動"
  - package: "brightnessctl"
    purpose: "屏幕亮度控制"
  - package: "tlp"
    purpose: "電池管理"
  - package: "iio-sensor-proxy"
    purpose: "自動屏幕旋轉"

special_packages:
  - name: "libinput-gestures"
    reason: "觸屏手勢支援"
  - name: "power-profiles-daemon"
    reason: "電源配置文件"
```

**特別配置：**
```bash
# 啟用高 DPI 縮放
dconf write /org/gnome/desktop/interface/scaling-factor 2

# 啟用電池節電
sudo tlp start

# 啟用屏幕旋轉
systemctl --user enable iio-sensor-proxy
```

**安裝命令：**
```bash
./scripts/install.sh --hardware duet-2022

# 或使用自動檢測（如果 lsb-release 匹配）
./scripts/install.sh --auto-detect
```

---

## 計劃中的硬體支援

### iPad (未來)
```yaml
device:
  name: "iPad (with Linux Boot)"
  type: "tablet"
  status: "coming-soon"
```

### MacBook (未來)
```yaml
device:
  name: "MacBook M-series"
  type: "laptop"
  status: "coming-soon"
```

---

## 自動硬體檢測

### 檢測方法

安裝腳本可以通過以下方式自動檢測硬體：

```bash
# 1. 檢查 DMI 資訊
sudo dmidecode -s system-product-name

# 2. 檢查 CPUID
lscpu | grep "Model name"

# 3. 檢查屏幕
xrandr --query

# 4. 檢查觸屏設備
cat /proc/bus/input/devices | grep -i touch
```

### 支援的檢測配置

檢測文件位置：`templates/hardware-detection.sh`

```bash
# 運行檢測
./templates/hardware-detection.sh

# 輸出範例：
# Device: Lenovo Duet 2022
# Detected CPU: MediaTek MT8195
# Touchscreen: Yes
# Recommended Profile: duet-2022
```

---

## 自訂硬體配置

### 建立新硬體配置

1. **複製範本**
   ```bash
   cp templates/hardware-profiles.md templates/my-device.md
   ```

2. **編輯配置**
   ```yaml
   device:
     name: "My Custom Device"
     type: "laptop"
     cpu: "YOUR_CPU_MODEL"
     ram: "YOUR_RAM_SIZE"
   
   features:
     touchscreen: true|false
     battery: true|false
   
   optimizations:
     - "自訂優化項"
   ```

3. **新增到安裝腳本**
   編輯 `scripts/install.sh` 並新增：
   ```bash
   elif [ "$HARDWARE" = "my-device" ]; then
       apply_my_device_config
   fi
   ```

4. **貢獻回倉庫**
   ```bash
   git add templates/my-device.md
   git commit -m "Add support for My Custom Device"
   git push origin main
   ```

---

## 配置應用順序

1. **基礎系統** - 所有配置都會應用
2. **硬體特定** - 根據 `--hardware` 參數應用
3. **使用者自訂** - 在 `config-backups/` 中定義

應用順序確保：
✅ 通用配置不被覆蓋  
✅ 硬體特定配置優先  
✅ 使用者設定最高優先級  

---

## 配置優先級

```
User Custom Settings
    ↑
Hardware-Specific Config
    ↑
Generic Base Config
```

---

## 檢查你的設備配置

### 快速識別

```bash
# 執行識別腳本
./scripts/identify-hardware.sh

# 或查看完整信息
cat /etc/os-release
lsb_release -a
dmidecode -t system
```

### 已知設備識別碼

| 設備 | 檢測碼 | 配置文件 |
|------|--------|---------|
| Lenovo Duet 2022 | `Lenovo Duet 2022` | `duet-2022` |
| Generic x86_64 | `x86_64` | `generic` |

---

## 關於配置檔案

所有配置都基於以下原則：

✅ **模塊化** - 每個配置獨立完整  
✅ **可擴展** - 易於新增新設備  
✅ **版本控制** - 所有變更都在 Git 中跟蹤  
✅ **文檔完整** - 每個配置都有說明  

---

**最後更新：** 2026-09-11
