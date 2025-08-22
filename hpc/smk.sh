#!/bin/bash
#JSUB -J smk
#JSUB -n 48
#JSUB -q normal
#JSUB -o smk_log.%J
#JSUB -e smk_err.%J
#JSUB -cwd smk_%J
source /hpcfile/users/92024269/cx/software/miniconda3/etc/profile.d/conda.sh
conda activate genefamily

conda env list > condainfo

cd /hpcfile/users/92024269/fdj/smk_genefamily/

snakemake -s /hpcfile/users/92024269/fdj/smk_genefamily/snakefile --core 48  combine_gene_pep_info
snakemake -s /hpcfile/users/92024269/fdj/smk_genefamily/snakefile --core 48  plot_tree_single
snakemake -s /hpcfile/users/92024269/fdj/smk_genefamily/snakefile --core 48  plot_tree_multi
snakemake -s /hpcfile/users/92024269/fdj/smk_genefamily/snakefile --core 48  run_meme


