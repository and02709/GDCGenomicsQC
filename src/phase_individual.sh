#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=4GB
#SBATCH --time=2:00:00
#SBATCH -p agsmall
#SBATCH -o phase_%a.out
#SBATCH -e phase_%a.err
#SBATCH --job-name phase_%a

WORK=$1
NAME=$2
CHR=$SLURM_ARRAY_TASK_ID

cd $WORK/phased
module load plink
module load bcftools

plink --bfile $WORK/relatedness/study.$NAME.unrelated --chr $CHR --recode vcf --out ${NAME}.chr${CHR}
bgzip -c ${NAME}.chr${CHR}.vcf > ${NAME}.chr${CHR}.vcf.gz
bcftools index -f ${NAME}.chr${CHR}.vcf.gz

/home/gdc/and02709/ancestry_OG/shapeit4/bin/shapeit4.2 \
        --input ${NAME}.chr${CHR}.vcf.gz \
        --map /home/gdc/and02709/ancestry_OG/chr${CHR}.b38.gmap.gz \
        --region ${CHR} \
        --output ${NAME}.chr${CHR}.phased.vcf.gz \
        --thread 8
