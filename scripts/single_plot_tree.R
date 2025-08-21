# single_plot_tree.R
# 如果没有安装ggplot2，首先安装它
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}

# 加载必要的包
library(ggplot2)  # 确保ggplot2包被加载
library(ggtree)
library(treeio)

args <- commandArgs(trailingOnly = TRUE)
tree_file <- args[1]
output_tree_file <- args[2]
git branch -m master main
git push -u origin main

# 读取树文件
tree <- treeio::read.newick(file = tree_file, node.label = "support")
tree_df <- as_tibble(tree)

# 绘制树
tree_p <- ggtree(tree, branch.length = "none") %<+% tree_df +
  geom_nodepoint(aes(fill = cut(support, c(0, 50, 75, 100))),
                 shape = 21, size = 2) +
  scale_fill_manual(values = c("black", "grey", "white"),
                    guide = 'legend', name = 'Bootstrap Percentage(BP)',
                    breaks = c('(75,100]', '(50,75]', '(0,50]'),
                    labels = expression(BP > 75, 50 < BP * "<=75", BP <= 50)) +
  geom_tiplab() +
  xlim(NA, 18) +
  theme_tree() +
  theme(
    plot.title = element_text(hjust = 0.5)
  )

# 保存结果
ggsave(filename = output_tree_file, plot = tree_p, height = 13.5, width = 18)
