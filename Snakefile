# Sample snakemake RNA-sequencing data processing pipeline
# @author Yolanda Yang & Casey P Shannon
# ------------------------------------------------------------------------------
# Run the pipeline with:
#    source activate workspace     # before running the pipeline
#    snakemake --core 8 -p      # -np for dry run
#    source deactivate     # after the pipeline is done
# ------------------------------------------------------------------------------
# PART1: Config File
# PART2: Top Level Rule
# PART3: Quality Control with fastQC
# PART4: Alignment with STAR aligner
# PART5: Counts Summarization with featureCounts
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# PART1: Config File
# Edit the "config.yaml" file to change the parameter values
configfile: "config.yaml"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# PART2: Top Level Rule
# Generate the final outputs: "counts" and fastQC dignostics
rule all:
    input:
        expand("fastQC/{sample}_fastQC/", sample = config["samples"]),
        "counts"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# PART3: Quality Control with fastQC
# input: fastq file (2 files if paired-end reads) specified in config file for each sample ID
# output: one folder per sample ID, with fastqc diagnostic files inside
rule fastQC:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
    output:
        "fastQC/{sample}_fastQC/"
    benchmark:
        "benchmarks/fastQC/{sample}.benchmark.txt"
    threads: 8
    params:
        outDir = "fastQC/{sample}_fastQC/"
    version: "0.11.4"
    shell:
        "zcat -c {input} | fastqc -t {threads} --outdir {params.outDir} stdin"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# PART4: Alignment with STAR aligner
# - Edit the parameters in "PART1: STAT aligner" of the config file
# input: fastq file (2 files if paired-end reads) specified in config file for each sample ID
# output: one folder per sample ID, with the corresponding .bam file and log files inside
rule rnaAlignment:
    input:
        lambda wildcards: config["samples"][wildcards.sample]
    output:
        "bam/{sample}/{sample}.bam"
    benchmark:
        "benchmarks/STAR/{sample}.benchmark.txt"
    threads: 8
    params:
        outFilterType = config["outFilterType"],
        outFilterMultimapNmax = config["outFilterMultimapNmax"],
        alignSJoverhangMin = config["alignSJoverhangMin"],
        alignSJDBoverhangMin = config["alignSJDBoverhangMin"],
        outFilterMismatchNmax = config["outFilterMismatchNmax"],
        outFilterMismatchNoverLmax = config["outFilterMismatchNoverLmax"],
        alignIntronMin = config["alignIntronMin"],
        alignIntronMax = config["alignIntronMax"],
        alignMatesGapMax = config["alignMatesGapMax"],
        readFilesCommand = config["readFilesCommand"],
        clip3pNbases = config["clip3pNbases"],
        clip5pNbases = config["clip5pNbases"],
        genomeDir = config["genomeDir"]
    version: "2.5.0a"
    shell:
        "STAR --runThreadN {threads} --outFilterType {params.outFilterType} --outFilterMultimapNmax {params.outFilterMultimapNmax} --alignSJoverhangMin {params.alignSJoverhangMin} --alignSJDBoverhangMin {params.alignSJDBoverhangMin} --outFilterMismatchNmax {params.outFilterMismatchNmax} --outFilterMismatchNoverLmax {params.outFilterMismatchNoverLmax} --alignIntronMin {params.alignIntronMin} --alignIntronMax {params.alignIntronMax} --alignMatesGapMax {params.alignMatesGapMax} --readFilesCommand {params.readFilesCommand} --clip3pNbases {params.clip3pNbases} --clip5pNbases {params.clip5pNbases} --genomeDir {params.genomeDir} --outFileNamePrefix bam/{wildcards.sample}/{wildcards.sample} --readFilesIn {input} --outStd SAM | samtools view -bS - > {output}"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# PART5: Counts Summarization with featureCounts
# - Edit the parameters in "PART2: featureCounts" of the config file
# input: all the .bam files
# output: one file called "counts" containing the counts data and its summary and log files
rule rnaSummarization:
    input:
        bams = expand("bam/{sample}/{sample}.bam", sample = config["samples"]),
        gtf = config["gtf"]
    output:
        counts = "counts"
    log: "counts.log"
    benchmark:
        "benchmarks/featureCounts/benchmark.txt"
    threads: 8
    params:
        typeOfReads = config["typeOfReads"],
        featureType = config["featureType"],
        attributeType = config["attributeType"]
    version: "1.5.0"
    shell:
        "(featureCounts -T {threads} {params.typeOfReads} -t {params.featureType} -g {params.attributeType} -a {input.gtf} -o {output.counts} {input.bams}) 2> {log}"
# ------------------------------------------------------------------------------
