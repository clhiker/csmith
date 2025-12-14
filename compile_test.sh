#!/bin/bash

# 编译CSmith生成的eBPF程序test0.c文件

# 设置CSMITH_HOME环境变量
CSMITH_HOME="/home/clhiker/bpf/csmith"

# 设置编译选项
CC="clang"
CFLAGS="-I${CSMITH_HOME}/runtime -I${CSMITH_HOME}/build/runtime -O3 -w -target bpf"

# 编译test0.c生成eBPF目标文件
$CC $CFLAGS -c ${CSMITH_HOME}/seeds/test0.c -o ${CSMITH_HOME}/seeds/test0.o

# 检查编译结果
if [ $? -eq 0 ]; then
    echo "编译成功！eBPF目标文件位于 ${CSMITH_HOME}/seeds/test0.o"
    sudo rm /sys/fs/bpf/test0
    echo "使用以下命令加载eBPF程序：sudo bpftool -d prog load ${CSMITH_HOME}/seeds/test0.o /sys/fs/bpf/test0"
    sudo bpftool -d prog load ${CSMITH_HOME}/seeds/test0.o /sys/fs/bpf/test0
else
    echo "编译失败！"
    exit 1
fi
