import os
import sys

# 创建seeds目录（如果不存在）
os.makedirs("seeds", exist_ok=True)
os.system('cd build && make -j8')
for seed in range(5):
    print(f"Generating test case with seed {seed}...")
    # 添加--no-checksum选项，屏蔽transparent_crc函数，但保留main函数生成（我们已经修改了main函数为eBPF入口）
    # 动态确定csmith可执行文件路径
    csmith_path = "./build/src/csmith"
    if not os.path.exists(csmith_path):
        print(f"Error: csmith executable not found at {csmith_path}!")
        sys.exit(1)
    cmd = f"{csmith_path} --seed {seed} --no-checksum > seeds/test{seed}.c"
    os.system(cmd)

print("Generation complete!")