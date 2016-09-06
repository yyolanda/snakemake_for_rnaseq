# Snakemake pipeline for RNA-sequencing data processing


### Installation

- Open a terminal window and install Miniconda3 with:
```
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```
- Download the entire repository.
- Switch to the repository and create a working environment fold called `workspace`:
```
conda create -n workspace -c bioconda --file requirements.txt
```

### Running the pipeline

- Create a folder at anywhere for your project and place all the fastq files into a folder called `fastq`.
- Copy and paste the `Snakefile` and `config.yaml` file into your project folder.
- Edit the parameters and sample list inside the `config.yaml` file.
- Activate the pipeline environment using:
```
source activate workspace
```
- Run the pipeline using:
```
snakemake -p --cores 8
```
You may check your pipeline execution plan before running it by using the `-np` flag instead of `-p`.
- After the pipeline is done, deactivate the pipeline environment using:
```
source deactivate
```
