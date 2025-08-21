rm(list = ls())  # 清空当前工作环境

####----加载R包----#### 
library(ggtree)    # 树形图绘制
library(treeio)    # 读取树数据
library(ape)       # 树的基本操作
library(ggplot2)   # 用于美化图形

####----读取命令行参数----#### 
args <- commandArgs(trailingOnly = TRUE)  
tree_file <- args[1]   # 树文件路径
output_file <- args[2] # 输出文件路径

####----读取树文件----#### 
tree <- read.tree(tree_file)  # 读取Newick格式的树文件

####----设置基本绘图对象----#### 
p <- ggtree(tree, branch.length = "none", layout = "fan") + 
  geom_tiplab(aes(label = label), size = 3, color = "black", align = TRUE, offset = 0.5) +  # 标签美化：调整标签偏移
  geom_nodepoint(size = 1.5, shape = 21, fill = "red") +  # 节点标记（红色圆点）
  theme_tree2() +  # 树布局设置
  theme(
    axis.line = element_blank(),  # 移除坐标轴线
    legend.position = "right",  # 设置图例位置
    legend.title = element_text(size = 10),  # 图例标题字体大小
    legend.text = element_text(size = 8),  # 图例文本字体大小
    axis.title = element_text(size = 8),  # 坐标轴标题字体大小
    axis.text = element_text(size = 7)  # 坐标轴文本字体大小
  )

####----自动调整分支间距----#### 
# 使用xlim调整x轴的最大值以适应树的显示区域。可以根据树的实际分支情况进行调整。
p <- p + xlim(NA, 40)  # 设置x轴的最大范围，避免树形图压缩

####----保存树图----#### 
ggsave(output_file, p, width = 12, height = 10)  # 保存为PNG图像，调整图像大小
