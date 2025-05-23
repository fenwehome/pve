#!/bin/bash
# images build from https://github.com/oneclickvirt/macos
# https://github.com/oneclickvirt/pve
# 2025.05.09

set -e
LANG_MODE="zh"
while [[ $# -gt 0 ]]; do
    case "$1" in
    --lang=*)
        LANG_MODE="${1#*=}"
        shift
        ;;
    *)
        echo "Unknown option: $1"
        echo "Available options: --lang=zh|en"
        exit 1
        ;;
    esac
done

_red() { echo -e "\033[31m\033[01m$@\033[0m"; }
_green() { echo -e "\033[32m\033[01m$@\033[0m"; }
_yellow() { echo -e "\033[33m\033[01m$@\033[0m"; }
_blue() { echo -e "\033[36m\033[01m$@\033[0m"; }

_text() {
    local zh="$1"
    local en="$2"
    if [[ "$LANG_MODE" == "en" ]]; then
        echo "$en"
    else
        echo "$zh"
    fi
}

reading() { read -rp "$(_green "$1")" "$2"; }
utf8_locale=$(locale -a 2>/dev/null | grep -i -m 1 -E "UTF-8|utf8")
if [[ -z "$utf8_locale" ]]; then
    _yellow "$(_text "未找到 UTF-8 本地化" "No UTF-8 locale found")"
else
    export LC_ALL="$utf8_locale"
    export LANG="$utf8_locale"
    export LANGUAGE="$utf8_locale"
    _green "$(_text "本地化已设置为 $utf8_locale" "Locale set to $utf8_locale")"
fi

DOWNLOAD_DIR="/var/lib/vz/template/iso"
DOWNLOAD_TASKS="$DOWNLOAD_DIR/download.tasks"
DECOMPRESS_TASKS="$DOWNLOAD_DIR/decompress.tasks"
if [ ! -d "$DOWNLOAD_DIR" ]; then
    _red "$(_text "目录 $DOWNLOAD_DIR 不存在。请检查路径是否正确。" "Directory $DOWNLOAD_DIR does not exist. Please check the path.")"
    exit 1
fi
touch "$DOWNLOAD_TASKS" "$DECOMPRESS_TASKS"
rm -f "${DOWNLOAD_TASKS}.tmp" "${DECOMPRESS_TASKS}.tmp"

if ! command -v 7z >/dev/null 2>&1; then
    apt install p7zip-full -y
    if ! command -v 7z >/dev/null 2>&1; then
        _red "$(_text "错误：未找到 '7z' 命令。请安装 p7zip-full" "ERROR: '7z' command not found. Please install p7zip-full")"
        exit 1
    fi
fi

check_cdn() {
    local o_url=$1
    local shuffled_cdn_urls=($(shuf -e "${cdn_urls[@]}")) # 打乱数组顺序
    for cdn_url in "${shuffled_cdn_urls[@]}"; do
        if curl -sL -k "$cdn_url$o_url" --max-time 6 | grep -q "success" >/dev/null 2>&1; then
            export cdn_success_url="$cdn_url"
            return
        fi
        sleep 0.5
    done
    export cdn_success_url=""
}

check_cdn_file() {
    check_cdn "https://raw.githubusercontent.com/spiritLHLS/ecs/main/back/test"
    if [ -n "$cdn_success_url" ]; then
        _yellow "CDN available, using CDN"
    else
        _yellow "No CDN available, using original links"
        export cdn_success_url=""
    fi
}

cdn_urls=("https://cdn0.spiritlhl.top/" "http://cdn1.spiritlhl.net/" "http://cdn2.spiritlhl.net/" "http://cdn3.spiritlhl.net/" "http://cdn4.spiritlhl.net/")
check_cdn_file
target_path="/var/lib/vz/template/iso/opencore.iso"
origin_url="https://github.com/oneclickvirt/macos/raw/refs/heads/main/EFI/opencore.iso"
final_url="${cdn_success_url}${origin_url}"
if [ ! -f "$target_path" ]; then
    _yellow "File not found: $target_path"
    _yellow "Downloading opencore.iso from: $([ -n "$cdn_success_url" ] && echo "$final_url" || echo "$origin_url")"
    wget "$([ -n "$cdn_success_url" ] && echo "$final_url" || echo "$origin_url")" -O "$target_path" && chmod 777 "$target_path"
    _yellow "Download completed and permissions set."
fi

declare -A files=(
    [1]="high-sierra.iso.7z|5.23|https://cnb.cool/oneclickvirt/template/-/lfs/81ae1e766f12f94a283ee51a2b3a0c274ce31b578acdce7eddd22c5ff8cd045e|5226471630"
    [2]="mojave.iso.7z|6.03|https://cnb.cool/oneclickvirt/template/-/lfs/4145b12588e14c933ad0d3e527b4e1f701b882d505d9dae463349f5062f7b6b1|6032600963"
    [3]="catalina.iso.7z|8.33|https://cnb.cool/oneclickvirt/template/-/lfs/660078c8a258c8bcde62c49897e5415751f5a17d30d40749a06ae81dc9b1c424|8178081717"
    [4]="big‑sur.iso.7z|12.21|https://cnb.cool/oneclickvirt/template/-/lfs/e15404924199bcf92c6421980a74ad5fdde1dd18a83551726648bd0a1417133|13154181520"
    [5]="monterey.iso.7z|12.36|https://cnb.cool/oneclickvirt/template/-/lfs/520f9e35fb4981bc171945d398f4587f780ab2f8dbfb4bf3a9463b2401ccb148|13257099123"
    [6]="ventura.iso.7z|12.31|https://cnb.cool/oneclickvirt/template/-/lfs/5f735c627d352f0677b6594e3e5f783467a35e34512fc8c6ae31349fce0c9677|13212673700"
    [7]="sonoma.iso.7z|14.41|https://cnb.cool/oneclickvirt/template/-/lfs/b35ff92067171d72519df05a066d3494b7fdb0eac1603b0a8803c98716707e9c|14644126387"
    [8]="sequoia.iso.7z|15.02|https://cnb.cool/oneclickvirt/template/-/lfs/f22ad0a9eba713645b566fd6a45f55a0daf9f481e6872cca2407856c6fd33b45|16398983272"
)

print_menu() {
    _blue "=== $(_text "macOS 下载器 菜单" "macOS Downloader Menu") ==="
    for i in {1..8}; do
        IFS='|' read -r name size url <<<"${files[$i]}"
        _yellow "  $i) $(_text "下载" "Download") $name ($(_text "大小" "Size"): ${size}GB)"
    done
    _yellow "100) $(_text "显示当前下载任务" "Show current download tasks")"
    _yellow "101) $(_text "删除下载任务及文件" "Delete a download task and file")"
    _yellow "102) $(_text "解压 .7z 文件" "Extract 7z archives")"
    _yellow "103) $(_text "显示当前解压任务" "Show current extraction tasks")"
    _yellow "104) $(_text "删除解压任务及文件" "Delete an extraction task and file")"
    _yellow "  0) $(_text "退出" "Exit")"
}

get_remote_size() {
    local url=$1
    local file_hash=$(basename "$url")
    for i in {1..8}; do
        IFS='|' read -r name size url_info exact_size <<<"${files[$i]}"
        if [[ "$url_info" == *"$file_hash"* ]]; then
            echo "$exact_size"
            return
        fi
    done
    echo "5368709120"
}

get_avail_space() {
    df --output=avail -B1 "$DOWNLOAD_DIR" | tail -1
}

start_download() {
    local fileName=$1 url=$2
    local size avail req
    for i in {1..8}; do
        IFS='|' read -r name _ url_info exact_size <<<"${files[$i]}"
        if [[ "$name" == "$fileName" ]]; then
            size="$exact_size"
            break
        fi
    done
    if [[ -z "$size" ]]; then
        _red "$(_text "错误：无法获取文件大小" "Error: Unable to determine file size")"
        return
    fi
    avail=$(get_avail_space)
    req=$((size * 2 + 2 * 1024 * 1024 * 1024))
    if ((avail < req)); then
        _red "$(_text "空间不足: 可用=${avail} 字节, 需要=${req} 字节" "Insufficient space: available=${avail} bytes, required=${req} bytes")"
        return
    fi
    nohup curl -L "$url" -o "$DOWNLOAD_DIR/$fileName" >"$DOWNLOAD_DIR/$fileName.log" 2>&1 &
    pid=$!
    echo "$pid|$fileName|$url|$size" >>"$DOWNLOAD_TASKS"
    _green "$(_text "下载开始: PID=$pid, 文件路径=$DOWNLOAD_DIR/$fileName" "Download started: PID=$pid, path=$DOWNLOAD_DIR/$fileName")"
}

show_downloads() {
    if [[ ! -s "$DOWNLOAD_TASKS" ]]; then
        _yellow "$(_text "没有下载任务" "No download tasks")"
        return
    fi
    while IFS='|' read -r pid file url size_bytes; do
        if ps -p "$pid" >/dev/null 2>&1; then
            downloaded=$(du -b "$DOWNLOAD_DIR/$file" 2>/dev/null | cut -f1 || echo 0)
            if [[ -n "$size_bytes" && "$size_bytes" -gt 0 ]]; then
                pct=$(awk "BEGIN{printf \"%.2f\", $downloaded*100/$size_bytes}")
                _blue "PID $pid: $file — $downloaded/$size_bytes 字节 ($pct%)，路径=$DOWNLOAD_DIR/$file"
            else
                _blue "PID $pid: $file — $downloaded 字节 (总大小未知)，路径=$DOWNLOAD_DIR/$file"
            fi
        else
            _yellow "PID $pid: $(_text "未运行 ▶ 从任务列表移除" "not running ▶ removing from task list")"
            grep -v "^$pid|" "$DOWNLOAD_TASKS" >"$DOWNLOAD_TASKS.tmp" && mv "$DOWNLOAD_TASKS.tmp" "$DOWNLOAD_TASKS"
        fi
    done <"$DOWNLOAD_TASKS"
}

delete_download() {
    reading "$(_text "输入要删除的下载 PID" "Enter download PID to delete"): " pid
    if ! grep -q "^$pid|" "$DOWNLOAD_TASKS"; then
        _red "$(_text "PID $pid 未找到" "PID $pid not found")"
        return
    fi
    line=$(grep "^$pid|" "$DOWNLOAD_TASKS")
    file=${line#*|}
    file=${file%%|*}
    kill "$pid" 2>/dev/null || true
    rm -f "$DOWNLOAD_DIR/$file" "$DOWNLOAD_DIR/$file.log"
    grep -v "^$pid|" "$DOWNLOAD_TASKS" >"$DOWNLOAD_TASKS.tmp" && mv "$DOWNLOAD_TASKS.tmp" "$DOWNLOAD_TASKS"
    _green "$(_text "已删除下载任务: $file，路径=$DOWNLOAD_DIR/$file" "Deleted download task for $file, path=$DOWNLOAD_DIR/$file")"
}

extract_7z() {
    mapfile -t archives < <(ls "$DOWNLOAD_DIR"/*.7z 2>/dev/null)
    if [[ ${#archives[@]} -eq 0 ]]; then
        _yellow "$(_text "目录中无 .7z 文件" "No .7z archives found in $DOWNLOAD_DIR")"
        return
    fi
    _blue "$(_text "可用 .7z 归档:" "Available .7z archives:")"
    for i in "${!archives[@]}"; do
        num=$((i + 1))
        _yellow "  $num) $(basename "${archives[i]}")"
    done
    reading "$(_text "选择要解压的索引" "Select index to extract"): " idx
    if ! [[ "$idx" =~ ^[0-9]+$ ]] || ((idx < 1 || idx > ${#archives[@]})); then
        _red "$(_text "无效选择" "Invalid selection")"
        return
    fi
    archive="${archives[$((idx - 1))]}"
    nohup 7z x "$archive" -o"$DOWNLOAD_DIR" >"$DOWNLOAD_DIR/$(basename "$archive").extract.log" 2>&1 &
    pid=$!
    echo "$pid|$(basename "$archive")" >>"$DECOMPRESS_TASKS"
    _green "$(_text "开始解压: PID=$pid, 归档路径=$DOWNLOAD_DIR/$(basename "$archive")" "Extraction started: PID=$pid, path=$DOWNLOAD_DIR/$(basename "$archive")")"
}

show_extracts() {
    if [[ ! -s "$DECOMPRESS_TASKS" ]]; then
        _yellow "$(_text "没有解压任务" "No extraction tasks")"
        return
    fi
    while IFS='|' read -r pid archive; do
        if ps -p "$pid" >/dev/null 2>&1; then
            _blue "PID $pid: $(_text "正在解压" "extracting") $archive，路径=$DOWNLOAD_DIR/$archive"
        else
            _yellow "PID $pid: $(_text "未运行 ▶ 解压完成，正在清理并从任务列表移除" "not running ▶ completed, cleaning up and removing from task list")"
            expected_iso="${archive%.7z}.iso"
            if [ -f "$DOWNLOAD_DIR/$expected_iso" ] || [ -f "$DOWNLOAD_DIR/output/$expected_iso" ]; then
                _green "$(_text "解压成功: $expected_iso 已创建" "Extraction successful: $expected_iso created")"
                if [ -f "$DOWNLOAD_DIR/output/$expected_iso" ]; then
                    mv "$DOWNLOAD_DIR/output/$expected_iso" "$DOWNLOAD_DIR/" || _red "$(_text "移动ISO文件失败" "Failed to move ISO file")"
                fi
                rm -f "$DOWNLOAD_DIR/$archive" "$DOWNLOAD_DIR/${archive}.extract.log" || true
                rm -rf "$DOWNLOAD_DIR/$archive.log" || true
            else
                _red "$(_text "警告: 解压可能失败，未找到预期的ISO文件" "Warning: Extraction may have failed, expected ISO file not found")"
            fi
            if [ -d "$DOWNLOAD_DIR/output" ]; then
                if [ "$(ls -A "$DOWNLOAD_DIR/output" 2>/dev/null)" ]; then
                    mv "$DOWNLOAD_DIR/output/"* "$DOWNLOAD_DIR" 2>/dev/null || _red "$(_text "移动解压文件失败" "Failed to move extracted files")"
                fi
                rm -rf "$DOWNLOAD_DIR/output" || true
            fi
            grep -v "^$pid|" "$DECOMPRESS_TASKS" >"$DECOMPRESS_TASKS.tmp" && mv "$DECOMPRESS_TASKS.tmp" "$DECOMPRESS_TASKS"
        fi
    done <"$DECOMPRESS_TASKS"
    if [[ ! -s "$DECOMPRESS_TASKS" ]]; then
        _yellow "$(_text "没有活跃的解压任务" "No active extraction tasks")"
        >"$DECOMPRESS_TASKS"
        if [[ -d "$DOWNLOAD_DIR/output" && -z "$(ls -A "$DOWNLOAD_DIR/output" 2>/dev/null)" ]]; then
            rm -rf "$DOWNLOAD_DIR/output"
        fi
    fi
}

delete_extract() {
    reading "$(_text "输入要删除的解压 PID" "Enter extraction PID to delete"): " pid
    if ! grep -q "^$pid|" "$DECOMPRESS_TASKS"; then
        _red "$(_text "PID $pid 未找到" "PID $pid not found")"
        return
    fi
    line=$(grep "^$pid|" "$DECOMPRESS_TASKS")
    archive=${line#*|}
    expected_iso="${archive%.7z}.iso"
    if ps -p "$pid" >/dev/null 2>&1; then
        kill "$pid" 2>/dev/null && _yellow "$(_text "已终止解压进程 PID=$pid" "Terminated extraction process PID=$pid")" || _red "$(_text "无法终止进程 PID=$pid" "Could not terminate process PID=$pid")"
    fi
    rm -f "$DOWNLOAD_DIR/$expected_iso" 2>/dev/null
    rm -f "$DOWNLOAD_DIR/$archive.extract.log" 2>/dev/null
    grep -v "^$pid|" "$DECOMPRESS_TASKS" >"$DECOMPRESS_TASKS.tmp" && mv "$DECOMPRESS_TASKS.tmp" "$DECOMPRESS_TASKS"
    _green "$(_text "已删除解压任务: $archive，路径=$DOWNLOAD_DIR/$archive" "Deleted extraction task for $archive, path=$DOWNLOAD_DIR/$archive")"
}

while true; do
    print_menu
    reading "$(_text "选择操作" "Choice"): " choice
    case "$choice" in
    [1-8])
        clear
        pair=${files[$choice]}
        IFS='|' read -r fname fsize furl fexact_size <<<"$pair"
        start_download "$fname" "$furl"
        ;;
    100)
        clear
        show_downloads
        ;;
    101)
        delete_download
        sleep 5
        clear
        ;;
    102)
        clear
        extract_7z
        ;;
    103)
        clear
        show_extracts
        ;;
    104)
        delete_extract
        sleep 5
        clear
        ;;
    0)
        _green "$(_text "退出程序" "Exit")"
        exit 0
        ;;
    *)
        clear
        _red "$(_text "无效选项" "Invalid option")"
        ;;
    esac
    echo
done
