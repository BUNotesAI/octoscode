#!/usr/bin/env bash
# For verified byte receipts and olp-board/v1 events, use the adjacent Python tools.
# OLP 黑板原子追加助手(随仓库发行版)。
#
# 外环写黑板的唯一正道:flock 互斥 + 整条目一次性追加,防多写者交错与
# 撞号。条目正文从 stdin 喂入。
#
# 用法:
#   scripts/olp-board-append.sh <board.md>  <<'EOF'
#   ### <编号>. <标题>(<日期>,<署名>)
#   ...正文...
#   EOF
#
# 注:若你是常驻外环且自建了"自写登记"机制(监视器抵扣自触发),请在
# 你自己的包装脚本里做登记——本脚本保持纯追加,保证其他外环的监视器
# 能感知你的写入。
set -euo pipefail
BOARD="${1:?用法: olp-board-append.sh <board.md> (正文从 stdin 喂)}"
LOCK="${BOARD}.lock"
TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT
cat > "$TMP"
exec 9>"$LOCK"
flock -x 9
# A board that opted in to olp-board/v1 reserves `> OLP-EVENT ` lines and
# standalone `ts=` lines for the event CLI; a hand-appended copy would only be
# quarantined as malformed DRIFT, or could re-pair a damaged event.
if LC_ALL=C grep -qE '^(> OLP-EVENT |ts=[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z[[:space:]]?$)' "$TMP" \
    && LC_ALL=C grep -qE '^(> OLP-EVENT |<!-- olp-board/v1 -->$)' "$BOARD" 2>/dev/null; then
    echo "error: $BOARD opted in to olp-board/v1; record events with olp-board-event.py" >&2
    exit 2
fi
cat "$TMP" >> "$BOARD"
