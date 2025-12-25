
# ebpfsmiht —— 魔改csmith 从而生成合法的ebpf程序

# 修改规则
## 类型系统修改为支持ebpf程序类型

## 头文件引入

## 入口函数 main 修改为指定程序类型的 sec函数，并设置返回值

## 限制对全局变量的访问

## 限制内建函数
--no-safe-math
在某些配置或宏展开下，这些函数内部使用 __builtin_trap() 或类似机制（Clang/GCC 内置），当检测到潜在 UB（如溢出）时触发陷阱（trap）。Clang 在编译为 eBPF 目标（-target bpf）时，会将 __builtin_trap() 转换为 eBPF 的 kfunc 调用 __bpf_trap

## 通过限制 goto 可以消除一些问题
--no-jumps