#!/bin/bash

# 配置備份腳本
# 使用方式：./backup-config.sh [OUTPUT_DIR]

set -e

BACKUP_DIR="${1:-.}"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_NAME="system-config-backup-${TIMESTAMP}"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"

# 顏色定義
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ️ $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warn() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

echo -e "${BLUE}==============================${NC}"
echo -e "${BLUE}Arch Linux 配置備份工具${NC}"
echo -e "${BLUE}==============================${NC}"
echo ""

log_info "建立備份目錄：$BACKUP_PATH"
mkdir -p "$BACKUP_PATH"

# 備份 Shell 配置
log_info "備份 Shell 配置..."
[ -f ~/.bashrc ] && cp ~/.bashrc "$BACKUP_PATH/bashrc"
[ -f ~/.bash_profile ] && cp ~/.bash_profile "$BACKUP_PATH/bash_profile"
[ -f ~/.bash_logout ] && cp ~/.bash_logout "$BACKUP_PATH/bash_logout"

# 備份 Git 配置
log_info "備份 Git 配置..."
[ -f ~/.gitconfig ] && cp ~/.gitconfig "$BACKUP_PATH/gitconfig"

# 備份 NPM 配置
log_info "備份 NPM 配置..."
[ -f ~/.npmrc ] && cp ~/.npmrc "$BACKUP_PATH/npmrc"

# 備份 .config 目錄
log_info "備份應用配置目錄..."
[ -d ~/.config ] && cp -r ~/.config "$BACKUP_PATH/config" || true

# 備份 .local 目錄
log_info "備份本地用戶數據..."
[ -d ~/.local ] && cp -r ~/.local "$BACKUP_PATH/local" || true

# 備份開發環境配置
log_info "備份開發環境配置..."
[ -d ~/.espressif ] && cp -r ~/.espressif "$BACKUP_PATH/espressif" 2>/dev/null || true
[ -d ~/.gradle ] && cp -r ~/.gradle "$BACKUP_PATH/gradle" 2>/dev/null || true
[ -d ~/.java ] && cp -r ~/.java "$BACKUP_PATH/java" 2>/dev/null || true

# 備份 IDE 配置
log_info "備份 IDE 配置..."
[ -d ~/.vscode ] && cp -r ~/.vscode "$BACKUP_PATH/vscode" 2>/dev/null || true

# 備份軟體包清單
log_info "備份軟體包清單..."
pacman -Q > "$BACKUP_PATH/installed-packages.txt"
pacman -Q --foreign > "$BACKUP_PATH/aur-packages.txt" || true

# 備份系統信息
log_info "備份系統信息..."
{
    echo "=== 系統信息 ==="
    uname -a
    echo ""
    echo "=== 發行版信息 ==="
    cat /etc/os-release
    echo ""
    echo "=== 軟體包統計 ==="
    echo "總數：$(pacman -Q | wc -l)"
    echo "官方：$(pacman -Qu | wc -l || echo 'N/A')"
} > "$BACKUP_PATH/system-info.txt"

# 壓縮備份
log_info "壓縮備份..."
cd "$BACKUP_DIR"
tar -czf "${BACKUP_NAME}.tar.gz" "$BACKUP_NAME"
rm -rf "$BACKUP_NAME"

log_success "備份完成！"
echo ""
echo "備份位置：$BACKUP_DIR/${BACKUP_NAME}.tar.gz"
echo "備份大小：$(du -h "${BACKUP_NAME}.tar.gz" | cut -f1)"
echo ""
echo "恢復方式："
echo "  ./scripts/restore-config.sh $BACKUP_DIR/${BACKUP_NAME}.tar.gz"
