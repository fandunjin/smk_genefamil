## ---- 设置镜像，加速安装 ---- ##
options(
  repos = c(CRAN = "https://mirrors.tuna.tsinghua.edu.cn/CRAN/")
)

# 安装 Bioconductor 管理工具
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

# 需要的 R 包列表
required_packages <- c(
  "tidyverse", 
  "Peptides", 
  "writexl", 
  "patchwork", 
  "seqinr", 
  "ggplot2", 
  "ape"
)

# Bioconductor 包列表
bioconductor_packages <- c(
  "ggtree", 
  "treeio"
)

# 检查已安装的包
installed_packages <- installed.packages()[,"Package"]

# 查找缺失的 CRAN 包
missing_cran_packages <- required_packages[!(required_packages %in% installed_packages)]

# 查找缺失的 Bioconductor 包
missing_bioconductor_packages <- bioconductor_packages[!(bioconductor_packages %in% installed_packages)]

# 如果有缺失的 CRAN 包，安装它们
if(length(missing_cran_packages) > 0) {
  install.packages(missing_cran_packages)
}

# 如果有缺失的 Bioconductor 包，安装它们
if(length(missing_bioconductor_packages) > 0) {
  BiocManager::install(missing_bioconductor_packages)
}

# 加载所有包
lapply(c(required_packages, bioconductor_packages), library, character.only = TRUE)
