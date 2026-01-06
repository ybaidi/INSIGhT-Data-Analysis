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

tmpdir="/xchip/beroukhimlab/Yossef/data/phenotypes"
# Add phenotypes
pheno=$1

ty=$(basename $pheno .txt)

for i in {1..23}
do

plink --bfile /xchip/beroukhimlab/Yossef/data/chr${i}_post \
      --pheno ${pheno} \
      --make-bed --out ${tmpdir}/${ty}_chr${i} \
      --keep ${pheno} \
      --allow-no-sex \
      --1


done

