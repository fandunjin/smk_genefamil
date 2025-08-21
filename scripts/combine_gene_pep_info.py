#!/usr/bin/env python3
import sys
import pandas as pd
import subprocess

# 自动安装缺失包
def install_if_missing(pkg):
    try:
        __import__(pkg)
    except ImportError:
        subprocess.check_call([sys.executable, "-m", "pip", "install", "--index-url", "https://pypi.tuna.tsinghua.edu.cn/simple", pkg])

for pkg in ["pandas", "openpyxl"]:
    install_if_missing(pkg)

# 输入输出文件
gene_file = sys.argv[1]
pep_file = sys.argv[2]
output_file = sys.argv[3]

# 读取基因信息文件，不用第一行作为列名
gene_df = pd.read_csv(gene_file, sep="\t", header=None, dtype=str)
gene_df = gene_df.dropna(axis=1, how='all')  # 删除全空列

# 第四列作为 ID
gene_id_col = 3

# 读取蛋白信息文件
pep_df = pd.read_excel(pep_file, dtype=str)
pep_id_col = pep_df.columns[0]

# 去掉 pfam ID 后缀 .1
pep_df[pep_id_col] = pep_df[pep_id_col].str.replace(r"\.1$", "", regex=True)

# 合并
combined_df = pd.merge(
    gene_df,
    pep_df,
    left_on=gene_df.columns[gene_id_col],
    right_on=pep_id_col,
    how="left"
)

# 重新排列列顺序，第一列为 ID
combined_df = combined_df[[pep_id_col] + list(gene_df.columns[:gene_id_col]) + list(gene_df.columns[gene_id_col+1:]) + list(pep_df.columns[1:])]

# 统一列名
combined_df.columns = ["ID","Chr","Start","End","E","Seq","Length","MW","Hydrophobicity","pI"]

# 保存 Excel
combined_df.to_excel(output_file, index=False)
