# Snakemake pipeline for RNA-sequencing data processing


### Installation

1. Open a terminal window and install Miniconda3 with:
```
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```

2. Download the entire repository.

3. Switch to the repository and create a working environment fold called `workspace`:
```
conda create -n workspace -c bioconda --file requirements.txt
```

### Running the pipeline

1. Create a folder at anywhere for your project and place all the fastq files into a folder called `fastq`.

2. Copy and paste the `Snakefile` and `config.yaml` file into your project folder.

3. Edit the parameters and sample list inside the `config.yaml` file.
 
4. Activate the pipeline environment using:
```
source activate workspace
```

5. Run the pipeline using:
```
snakemake -p --cores 8
```
You may check your pipeline execution plan before running it by using the `-np` flag instead of `-p`.

6. After the pipeline is done, deactivate the pipeline environment using:
```
source deactivate
```
