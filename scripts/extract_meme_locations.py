#!/usr/bin/env python3
"""
从 MEME 输出文件提取 motif 位置信息，生成绘图所需的表格。
可被 Snakemake 调用。
"""

import argparse
import pandas as pd
import re

def parse_meme_file(meme_file, output_file):
    """
    解析 MEME 输出 txt 文件，提取 motif 位置信息。
    """
    data = []
    with open(meme_file) as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            # 假设格式: ProteinID  Start  End  MotifID  Sequence
            # 如果 MEME txt 格式不同，需要修改这里的解析逻辑
            parts = re.split(r"\s+", line)
            if len(parts) >= 5:
                data.append(parts[:5])

    df = pd.DataFrame(data, columns=["ProteinID","Start","End","MotifID","Sequence"])
    df.to_csv(output_file, sep="\t", index=False)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Extract motif locations from MEME output")
    parser.add_argument("--input", "-i", required=True, help="MEME output file")
    parser.add_argument("--output", "-o", required=True, help="Output motif location table")
    args = parser.parse_args()

    parse_meme_file(args.input, args.output)
