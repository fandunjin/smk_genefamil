# Usage 使用方法 #
# First step #
## 指定镜像（可选）
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free

conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge

conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/bioconda

conda config --set show_channel_urls yes
## 创建环境（使用mamba创建环境）
mamba create -c bioconda -f environment.yaml
conda activate genefamily
## 安装R所需包
Rscript scripts/install_packages.R
## 下载hmm
### hmm数据下载
wget -c https://ftp.ebi.ac.uk/pub/databases/Pfam/releases/Pfam38.0/Pfam-A.hmm.gz

wget -c https://ftp.ebi.ac.uk/pub/databases/Pfam/releases/Pfam38.0/Pfam-A.hmm.dat.gz

wget -c https://ftp.ebi.ac.uk/pub/databases/Pfam/releases/Pfam38.0/active_site.dat.gz

gunzip -c Pfam-A.hmm.gz > 1.database/Pfam-A.hmm

gunzip -c Pfam-A.hmm.dat.gz > 1.database/Pfam-A.hmm.dat

gunzip -c active_site.dat.gz > 1.database/active_site.dat

# Second step #
## 将配置文件config.yaml配置好（config/config.yaml）

# Third step #
## 选择需要分析的内容
## 1.筛选目标家族成员并计算理化性质 combine_gene_pep_info
nohup snakemake --core 32 --use-conda combine_gene_pep_info &
### 运行结果
#### pfam_scan.pep.fa为筛选后的成员蛋白文件
#### pfam_scan.id为成员ID
#### combined_gene_pep_info.xlsx 为理化性质表
## 2.比对与建树（需要花费较长时间）
### 单物种
nohup snakemake --core 32 --use-conda plot_tree_single &
### 多物种
nohup snakemake --core 32 --use-conda plot_tree_multi &
## 3.motif
nohup snakemake --core 32 --use-conda run_meme &

# Notice #
## 需要下载的数据，都下载到1.database中 ####
## 家族HMM文件在该网站中下载，修改对应的PF号即可：https://www.ebi.ac.uk/interpro/entry/pfam/PF03106/
## hmm数据下载
wget -c https://ftp.ebi.ac.uk/pub/databases/Pfam/releases/Pfam38.0/Pfam-A.hmm.gz

wget -c https://ftp.ebi.ac.uk/pub/databases/Pfam/releases/Pfam38.0/Pfam-A.hmm.dat.gz

wget -c https://ftp.ebi.ac.uk/pub/databases/Pfam/releases/Pfam38.0/active_site.dat.gz

gunzip -c Pfam-A.hmm.gz > 1.database/Pfam-A.hmm

gunzip -c Pfam-A.hmm.dat.gz > 1.database/Pfam-A.hmm.dat

gunzip -c active_site.dat.gz > 1.database/active_site.dat
## 拟南芥的pep和domian数据(https://www.arabidopsis.org/)
wget -c --no-check-certificate  https://www.arabidopsis.org/download_files/Proteins/Domains/all.domains.txt

wget -c --no-check-certificate  https://www.arabidopsis.org/download/file?path=Proteins/Araport11_protein_lists/Araport11_pep_20250411.gz
## 水稻的两个数据下载
wget -c http://rice.uga.edu/pub/data/Eukaryotic_Projects/o_sativa/annotation_dbs/pseudomolecules/version_7.0/all.dir/all.pfam

wget -c http://rice.uga.edu/pub/data/Eukaryotic_Projects/o_sativa/annotation_dbs/pseudomolecules/version_7.0/all.dir/all.pep
## 单物种序列比对中，-super5加速，会牺牲部分精度，可删除
### 到combine_gene_pep_info为止，就得到筛选结果和基本理化性质

## 如果需要提交到无法连接网络的节点运行需要提前安装好pfamscan
conda create -n pfam_scan pfam_scan -y
### 并修改snakefile中的rule pfam_scan，改为：
#### 注意在shell的第一行修改对应的初始化命令
rule pfam_scan:
    input:
        pep = HMM_BLAST_PEP,
        hmm = expand(PFAM_A_HMM + ".{ext}", ext=["h3f", "h3i", "h3m", "h3p"])
    output: PFAM_SCAN_OUT
    log: f"{ID_DIR}/{PREFIX}_Pfam_scan.log"
    conda: "env/pfamscan.yaml"
    shell: ""
        """
        conda init
        conda atctivate pfam_scan
        mkdir -p {ID_DIR} && pfam_scan.pl -fasta {input[0]} -dir 1.database -cpu 8 -out {output} > {log} 2>&1
        conda deatctivate
        """

