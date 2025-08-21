import argparse
import re

def get_geneinfo_by_id(id_file, gff_file, out_file):
    """
    从蛋白或转录本 ID 提取对应基因信息
    输出内容包括：chr, start, end, gene_id, strand, gene_name(如果有)
    """
    # 1️⃣ 读取 ID 文件
    id_set = set()
    with open(id_file, "r") as fr:
        for line in fr:
            line = line.strip()
            if line:
                # 去掉版本号（点号后的部分）
                id_clean = line.split(".")[0]
                id_set.add(id_clean)

    if not id_set:
        print(f"[Warning] ID 文件 {id_file} 是空的！")
        return

    # 2️⃣ 解析 GFF3 文件，建立 id -> gene_info 映射
    gene_info_dict = {}

    with open(gff_file, "r") as fr:
        for line in fr:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            cols = line.split("\t")
            if len(cols) < 9:
                continue
            feature_type = cols[2]
            attributes = cols[8]

            # 提取 ID
            id_match = re.search(r'ID=([^;]+)', attributes)
            if id_match:
                entry_id = id_match.group(1)
                entry_id_clean = entry_id.split(".")[0]  # 去掉版本号
            else:
                continue

            # gene、mRNA、transcript 都保存
            if feature_type in ["gene", "mRNA", "transcript"]:
                # 可选提取 Name
                name_match = re.search(r'Name=([^;]+)', attributes)
                gene_name = name_match.group(1) if name_match else ""
                gene_info_dict[entry_id_clean] = "\t".join([
                    cols[0],  # chr
                    cols[3],  # start
                    cols[4],  # end
                    entry_id_clean,  # gene_id
                    cols[6],  # strand
                    gene_name
                ])

    # 3️⃣ 输出匹配结果
    matched_count = 0
    with open(out_file, "w") as fw:
        for query_id in id_set:
            if query_id in gene_info_dict:
                fw.write(gene_info_dict[query_id] + "\n")
                matched_count += 1

    print(f"[Info] 输入 ID 总数: {len(id_set)}, 匹配到基因数: {matched_count}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Extract gene info from ID file and GFF3")
    parser.add_argument("--arg1", required=True, help="Input gene/protein ID file")
    parser.add_argument("--arg2", required=True, help="Input GFF3 annotation file")
    parser.add_argument("--arg3", required=True, help="Output file")
    args = parser.parse_args()

    get_geneinfo_by_id(args.arg1, args.arg2, args.arg3)
