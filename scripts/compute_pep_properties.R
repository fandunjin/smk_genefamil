## ---- 设置镜像，加速安装 ---- ##
options(
  repos = c(CRAN = "https://mirrors.tuna.tsinghua.edu.cn/CRAN/")
)

## 自动安装函数
install_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
  }
  library(pkg, character.only = TRUE)
}

## ---- 自动安装并加载 CRAN 包 ---- ##
cran_pkgs <- c("tidyverse", "Peptides", "seqinr", "writexl","patchwork")
lapply(cran_pkgs, install_if_missing)

## ---- 获取命令行参数 ---- ##
args <- commandArgs(trailingOnly = TRUE)

# 输入和输出文件路径
input_file <- args[1]
output_file <- args[2]

#### ---- 读取蛋白质序列 ---- ####
fa <- seqinr::read.fasta(file = input_file, seqtype = "AA", as.string = TRUE)

#### ---- 计算蛋白质理化性质 ---- ####
pep_df <- tibble(
  ID = names(fa),
  Seq = sapply(fa, function(x) paste(x, collapse = "")),
  Length = sapply(fa, nchar),
  MW = sapply(fa, Peptides::mw),
  hydrophobicity = sapply(fa, Peptides::hydrophobicity),
  pI = sapply(fa, Peptides::pI)
)

#### ---- 保存结果 ---- ####
writexl::write_xlsx(pep_df, path = output_file)
