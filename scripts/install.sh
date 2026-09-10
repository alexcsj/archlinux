#!/bin/bash

# Arch Linux 環境自動安裝腳本
# 使用方式：./install.sh [OPTIONS]
# 選項：
#   --hardware DEVICE   指定硬體配置 (generic, duet-2022)
#   --auto-detect       自動檢測硬體
#   --interactive       互動式選擇
#   --help              顯示幫助信息

set -e

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 變數定義
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
HARDWARE="generic"
VERBOSE=false

# 日誌函數
log_info() {
    echo -e "${BLUE}ℹ️ $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warn() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 幫助信息
show_help() {
    cat << EOF
Arch Linux 環境自動安裝腳本

使用方式：
  $0 [OPTIONS]

選項：
  --hardware DEVICE     指定硬體配置
                       可用值：generic, duet-2022

  --auto-detect        嘗試自動檢測硬體

  --interactive        互動式選擇硬體配置

  --packages-only      只安裝軟體包，不進行其他配置

  --config-only        只恢復配置，不安裝軟體包

  --verbose            詳細輸出

  --help               顯示此幫助信息

範例：
  # 使用聯想 Duet 2022 配置安裝
  $0 --hardware duet-2022

  # 自動檢測硬體並安裝
  $0 --auto-detect

  # 互動式安裝
  $0 --interactive

EOF
    exit 0
}

# 檢測硬體
detect_hardware() {
    log_info "正在檢測硬體配置..."

    # 檢查是否為聯想 Duet 2022
    if dmidecode -t system 2>/dev/null | grep -q "Duet" || \
       lsb_release -d 2>/dev/null | grep -q "Lenovo"; then
        echo "duet-2022"
        return
    fi

    # 預設為通用配置
    echo "generic"
}

# 互動式選擇硬體
interactive_select() {
    log_info "請選擇你的硬體配置："
    echo ""
    echo "  1) Generic x86_64 (台式機、標準筆記本)"
    echo "  2) Lenovo Duet 2022 (平板)"
    echo "  3) 自動檢測"
    echo ""
    read -p "請輸入選擇 (1-3): " choice

    case $choice in
        1) echo "generic" ;;
        2) echo "duet-2022" ;;
        3) detect_hardware ;;
        *)
            log_error "無效的選擇"
            interactive_select
            ;;
    esac
}

# 驗證硬體配置
validate_hardware() {
    case "$1" in
        generic|duet-2022)
            return 0
            ;;
        *)
            log_error "未知的硬體配置：$1"
            log_info "可用的硬體配置：generic, duet-2022"
            exit 1
            ;;
    esac
}

# 安裝基礎軟體包
install_base_packages() {
    log_info "安裝基礎軟體包..."

    # 檢查軟體包清單
    if [ ! -f "$PROJECT_ROOT/packages/installed-packages.txt" ]; then
        log_error "找不到軟體包清單：$PROJECT_ROOT/packages/installed-packages.txt"
        exit 1
    fi

    # 更新系統
    log_info "更新系統..."
    sudo pacman -Syu --noconfirm

    # 安裝 yay（AUR 助手）
    if ! command -v yay &> /dev/null; then
        log_info "安裝 yay (AUR 助手)..."
        git clone https://aur.archlinux.org/yay.git /tmp/yay-build
        cd /tmp/yay-build
        makepkg -si --noconfirm
        cd - > /dev/null
        rm -rf /tmp/yay-build
    fi

    # 批量安裝軟體包
    log_info "正在安裝 $(wc -l < "$PROJECT_ROOT/packages/installed-packages.txt") 個軟體包..."
    log_warn "這可能需要 45-90 分鐘，請耐心等待..."

    cat "$PROJECT_ROOT/packages/installed-packages.txt" | awk '{print $1}' | \
        xargs yay -S --noconfirm 2>/dev/null || \
        log_warn "某些軟體包安裝失敗，但繼續進行..."

    log_success "基礎軟體包安裝完成"
}

# 硬體特定配置
apply_hardware_config() {
    case "$1" in
        duet-2022)
            log_info "應用聯想 Duet 2022 特定配置..."

            # 高 DPI 縮放
            log_info "設定高 DPI 縮放..."
            dconf write /org/gnome/desktop/interface/scaling-factor 2 || true

            # 電池管理
            if command -v tlp &> /dev/null; then
                log_info "啟用 TLP 電池管理..."
                sudo systemctl enable tlp || true
                sudo systemctl start tlp || true
            fi

            # 屏幕旋轉
            if command -v iio-sensor-proxy &> /dev/null; then
                log_info "啟用屏幕自動旋轉..."
                systemctl --user enable iio-sensor-proxy || true
                systemctl --user start iio-sensor-proxy || true
            fi

            # 手勢支援
            if command -v libinput-gestures &> /dev/null; then
                log_info "啟用觸屏手勢..."
                systemctl --user enable libinput-gestures || true
                systemctl --user start libinput-gestures || true
            fi

            log_success "聯想 Duet 2022 配置完成"
            ;;

        generic)
            log_info "應用通用 x86_64 配置..."
            log_success "通用配置完成"
            ;;
    esac
}

# 驗證安裝
verify_installation() {
    log_info "驗證安裝..."

    local package_count
    package_count=$(pacman -Q | wc -l)

    echo ""
    echo "安裝統計："
    echo "  已安裝軟體包數：$package_count"
    echo "  預期軟體包數：1071"

    if [ "$package_count" -ge 1000 ]; then
        log_success "安裝完成！"
        return 0
    else
        log_warn "已安裝的軟體包數少於預期，可能有安裝失敗"
        return 1
    fi
}

# 安裝後提示
post_install_message() {
    cat << EOF

${GREEN}========================================${NC}
${GREEN}✅ Arch Linux 環境安裝完成！${NC}
${GREEN}========================================${NC}

${BLUE}後續步驟：${NC}

1. ${YELLOW}配置輸入法${NC}
   進入 GNOME 設定 > 鍵盤 > 輸入法
   新增 Fcitx5 並選擇繁體中文

2. ${YELLOW}調整屏幕顯示${NC}（平板用戶）
   進入 GNOME 設定 > 顯示
   根據需要調整縮放和刷新率

3. ${YELLOW}配置 Git${NC}
   git config --global user.name "你的名字"
   git config --global user.email "你的郵箱"

4. ${YELLOW}驗證開發工具${NC}
   gcc --version
   python --version
   node --version
   docker --version

5. ${YELLOW}備份配置${NC}（推薦）
   ./scripts/backup-config.sh

${BLUE}相關文檔：${NC}
  快速檢查清單：  docs/quick-install-checklist.md
  詳細安裝指南：  docs/environment-setup-guide.md
  配置備份指南：  docs/configuration-backup-guide.md
  硬體適配指南：  docs/lenovo-duet-2022-adaptation.md

${BLUE}需要幫助？${NC}
  查看 README.md 或相應的文檔

祝你使用愉快！ 🚀

EOF
}

# 主函數
main() {
    log_info "開始 Arch Linux 環境安裝..."
    echo ""

    # 檢查是否在 Arch Linux 上運行
    if [ ! -f /etc/os-release ]; then
        log_error "無法檢測到作業系統，請確保在 Arch Linux 上運行"
        exit 1
    fi

    # 解析命令行參數
    while [[ $# -gt 0 ]]; do
        case $1 in
            --hardware)
                HARDWARE="$2"
                shift 2
                ;;
            --auto-detect)
                HARDWARE=$(detect_hardware)
                shift
                ;;
            --interactive)
                HARDWARE=$(interactive_select)
                shift
                ;;
            --packages-only)
                install_base_packages
                exit 0
                ;;
            --config-only)
                verify_installation
                exit 0
                ;;
            --verbose)
                VERBOSE=true
                shift
                ;;
            --help)
                show_help
                ;;
            *)
                log_error "未知的選項：$1"
                show_help
                ;;
        esac
    done

    # 驗證硬體配置
    validate_hardware "$HARDWARE"

    echo "選定硬體配置：$HARDWARE"
    echo ""
    read -p "繼續安裝？(y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "安裝已取消"
        exit 0
    fi

    # 執行安裝
    install_base_packages
    apply_hardware_config "$HARDWARE"
    verify_installation

    echo ""
    post_install_message
}

# 執行主函數
main "$@"
