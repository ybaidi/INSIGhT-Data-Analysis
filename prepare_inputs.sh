#!/bin/bash
# Memory request for 20G
#$ -l h_vmem=20G
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



# To convert vcf to plink
plink --vcf /xchip/beroukhimlab/Yossef/data/Normal_filtered.vcf --make-bed --out /xchip/beroukhimlab/Yossef/data/toxicity_genotype

# To split by chromosome and get frequency information
for chr in {1..23}; 
	do 
	plink --bfile /xchip/beroukhimlab/Yossef/data/toxicity_genotype \
	--chr $chr --make-bed --freqx \
	--out /xchip/beroukhimlab/Yossef/data/chr${chr}; \
	done

# Extract snps with at least 2 individual per group (also allow zero individual for 1/1 group)

for chr in {1..23} {
do
awk '$5 != 1 && $6 > 1 && $7 != 1 {print $2}' /xchip/beroukhimlab/Yossef/data/chr${chr}.frqx > /xchip/beroukhimlab/Yossef/data/chr${chr}_list.txt;
sed -i '1d' /xchip/beroukhimlab/Yossef/data/chr${chr}_list.txt; # remove the first line

plink --bfile /xchip/beroukhimlab/Yossef/data/chr${chr} \
      --extract /xchip/beroukhimlab/Yossef/data/chr${chr}_list.txt \
      --make-bed \
      --recode12 \
      --output-missing-genotype 0 \
      --transpose \
      --out /xchip/beroukhimlab/Yossef/data/chr${chr}_post

done




