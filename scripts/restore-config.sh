#!/bin/bash

# 配置恢復腳本
# 使用方式：./restore-config.sh BACKUP_FILE

set -e

if [ -z "$1" ]; then
    echo "使用方式：$0 BACKUP_FILE"
    echo ""
    echo "範例："
    echo "  $0 system-config-backup-20260911-033000.tar.gz"
    exit 1
fi

BACKUP_FILE="$1"

# 顏色定義
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
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

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 檢查備份文件
if [ ! -f "$BACKUP_FILE" ]; then
    log_error "備份文件不存在：$BACKUP_FILE"
    exit 1
fi

echo -e "${BLUE}==============================${NC}"
echo -e "${BLUE}Arch Linux 配置恢復工具${NC}"
echo -e "${BLUE}==============================${NC}"
echo ""

log_info "備份文件：$BACKUP_FILE"
log_info "文件大小：$(du -h "$BACKUP_FILE" | cut -f1)"
echo ""

# 確認恢復
read -p "確認恢復配置？此操作可能覆蓋現有配置 (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log_info "恢復已取消"
    exit 0
fi

# 臨時目錄
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

log_info "解壓備份文件..."
tar -xzf "$BACKUP_FILE" -C "$TEMP_DIR"

# 找到備份目錄
BACKUP_DIR=$(ls -d "$TEMP_DIR"/system-config-backup-* | head -1)

if [ -z "$BACKUP_DIR" ]; then
    log_error "無效的備份文件格式"
    exit 1
fi

log_info "恢復位置：$BACKUP_DIR"
echo ""

# 恢復 Shell 配置
log_info "恢復 Shell 配置..."
[ -f "$BACKUP_DIR/bashrc" ] && cp "$BACKUP_DIR/bashrc" ~/.bashrc
[ -f "$BACKUP_DIR/bash_profile" ] && cp "$BACKUP_DIR/bash_profile" ~/.bash_profile
[ -f "$BACKUP_DIR/bash_logout" ] && cp "$BACKUP_DIR/bash_logout" ~/.bash_logout

# 恢復 Git 配置
log_info "恢復 Git 配置..."
[ -f "$BACKUP_DIR/gitconfig" ] && cp "$BACKUP_DIR/gitconfig" ~/.gitconfig

# 恢復 NPM 配置
log_info "恢復 NPM 配置..."
[ -f "$BACKUP_DIR/npmrc" ] && cp "$BACKUP_DIR/npmrc" ~/.npmrc

# 恢復 .config 目錄
if [ -d "$BACKUP_DIR/config" ]; then
    log_info "恢復應用配置..."
    cp -r "$BACKUP_DIR/config"/* ~/.config/ 2>/dev/null || true
fi

# 恢復 .local 目錄
if [ -d "$BACKUP_DIR/local" ]; then
    log_info "恢復本地用戶數據..."
    cp -r "$BACKUP_DIR/local"/* ~/.local/ 2>/dev/null || true
fi

# 恢復開發環境配置
log_info "恢復開發環境配置..."
[ -d "$BACKUP_DIR/espressif" ] && cp -r "$BACKUP_DIR/espressif" ~/ 2>/dev/null || true
[ -d "$BACKUP_DIR/gradle" ] && cp -r "$BACKUP_DIR/gradle" ~/ 2>/dev/null || true
[ -d "$BACKUP_DIR/java" ] && cp -r "$BACKUP_DIR/java" ~/ 2>/dev/null || true

# 恢復 IDE 配置
log_info "恢復 IDE 配置..."
[ -d "$BACKUP_DIR/vscode" ] && cp -r "$BACKUP_DIR/vscode" ~/.vscode 2>/dev/null || true

# 恢復權限（重要）
log_info "修復文件權限..."
chmod 700 ~/.config ~/.local 2>/dev/null || true
chmod 600 ~/.bashrc ~/.bash_profile ~/.gitconfig ~/.npmrc 2>/dev/null || true

log_success "配置恢復完成！"
echo ""

# 顯示備份信息
if [ -f "$BACKUP_DIR/system-info.txt" ]; then
    echo -e "${BLUE}備份時的系統信息：${NC}"
    cat "$BACKUP_DIR/system-info.txt"
    echo ""
fi

# 提示重啟
log_warn "建議重啟系統以應用所有變更"
echo ""
echo "重啟命令："
echo "  reboot"
echo ""
echo "或登出後重新登入：$(whoami)"
