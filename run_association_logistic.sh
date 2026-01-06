#!/bin/bash
# Memory request for 20G
#$ -l h_vmem=5G
# Cores
#$ -pe smp 1
#$ -binding linear:1
# Single output files (merge std out with std error)
#$ -j y
# Runtime request
#$ -l h_rt=05:00:00
# Output path for std out
#$ -o /xchip/beroukhimlab/Yossef/log


source /broad/software/scripts/useuse

reuse PLINK

tmpdir="/xchip/beroukhimlab/Yossef/data/association_logistic"

# Add phenotypes
line="$SGE_TASK_ID"

pheno=`sed -n "$line p" /xchip/beroukhimlab/Yossef/scripts/all_pheno.txt`
pheno=$(echo $pheno | awk -F"_chr" '{print $1}')

ty=$(basename $pheno .txt)

for i in {1..23}
do

 plink --bfile ${pheno}_chr${i}\
               --allow-no-sex \
	       --logistic \
	       --out ${tmpdir}/res_${ty}_chr${i}.txt

done
