#!/bin/bash

# 编译并加载CSmith生成的eBPF程序

# 检查命令行参数
if [ $# -ne 1 ]; then
    echo "用法: $0 <input_file>"
    echo "示例: $0 ./seeds/test0.c"
    exit 1
fi

# 获取输入文件路径和文件名
INPUT_FILE=$1
if [ ! -f "$INPUT_FILE" ]; then
    echo "错误: 文件 '$INPUT_FILE' 不存在！"
    exit 1
fi

# 提取文件名（不带路径和扩展名）
FILENAME=$(basename "$INPUT_FILE" .c)
DIRNAME=$(dirname "$INPUT_FILE")

# 设置CSMITH_HOME环境变量
CSMITH_HOME="/home/clhiker/bpf/csmith"

# 设置编译选项
CC="clang"
CFLAGS="-I${CSMITH_HOME}/runtime -I${CSMITH_HOME}/build/runtime -O2 -g -w -target bpf"

# 编译eBPF目标文件
OUTPUT_FILE="${DIRNAME}/${FILENAME}.o"
$CC $CFLAGS -c "$INPUT_FILE" -o "$OUTPUT_FILE"

# 检查编译结果
if [ $? -eq 0 ]; then
    echo "编译成功！eBPF目标文件位于 $OUTPUT_FILE"
    
    # 删除旧的bpf程序（如果存在）
    sudo rm -f /sys/fs/bpf/$FILENAME
    
    # 加载eBPF程序
    echo "正在加载eBPF程序..."
    sudo bpftool -d prog load "$OUTPUT_FILE" /sys/fs/bpf/$FILENAME
    
    if [ $? -eq 0 ]; then
        echo "eBPF程序加载成功！"
        echo "程序路径: /sys/fs/bpf/$FILENAME"
        echo "使用以下命令查看程序: sudo bpftool prog show id $(sudo bpftool prog list | grep $FILENAME | awk '{print $1}')"
    else
        echo "eBPF程序加载失败！"
        exit 1
    fi
else
    echo "编译失败！"
    exit 1
fi
