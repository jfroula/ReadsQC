# The Data Preprocessing workflow

## Summary

This workflow is a replicate of the [QA protocol](https://jgi.doe.gov/data-and-tools/bbtools/bb-tools-user-guide/data-preprocessing/) implemented at JGI for Illumina reads and use the program “rqcfilter2” from BBTools(38:96) which implements them as a pipeline. 

## Required Database

* [RQCFilterData Database](https://portal.nersc.gov/cfs/m3408/db/RQCFilterData.tgz): It is a 106G tar file includes reference datasets of artifacts, adapters, contaminants, phiX genome, host genomes.  

* Prepare the Database

```bash
	mkdir -p refdata
	wget https://portal.nersc.gov/cfs/m3408/db/RQCFilterData.tgz
	tar xvzf RQCFilterData.tgz -C refdata
	rm RQCFilterData.tgz
```

## Running Workflow in Cromwell

Description of the files:
 - `.wdl` file: the WDL file for workflow definition
 - `.json` file: the example input for the workflow
 - `.conf` file: the conf file for running Cromwell.
 - `.sh` file: the shell script for running the example workflow

## The Docker image and Dockerfile can be found here

[microbiomedata/bbtools:38.92](https://hub.docker.com/r/microbiomedata/bbtools)

## Input files

1. database path, 
2. fastq (illumina paired-end interleaved fastq), 
3. output path
4. input_interleaved (boolean)
5. forwards reads fastq file (when input_interleaved is false)
6. reverse reads fastq file (when input_interleaved is false)
7. memory (optional) ex: "jgi_rqcfilter.memory": "35G"
8. threads (optional) ex: "jgi_rqcfilter.threads": "16"

```
{
    "jgi_rqcfilter.database": "/global/cfs/projectdirs/m3408/aim2/database", 
    "jgi_rqcfilter.input_files": [
        "/global/cfs/cdirs/m3408/ficus/8434.3.102077.AGTTCC.fastq.gz", 
        "/global/cfs/cdirs/m3408/ficus/8434.1.102069.ACAGTG.fastq.gz", 
        "/global/cfs/cdirs/m3408/ficus/8434.3.102077.ATGTCA.fastq.gz"
    ], 
    "jgi_rqcfilter.outdir": "/global/cfs/cdirs/m3408/ficus_rqcfiltered",
    "jgi_rqcfilter.input_interleaved": true,
    "jgi_rqcfilter.input_fq1":[],
    "jgi_rqcfilter.input_fq2":[],
    "jgi_rqcfilter.memory": "35G",
    "jgi_rqcfilter.threads": "16"
}
```

## Output files

The output will have one directory named by prefix of the fastq input file and a bunch of output files, including statistical numbers, status log and a shell script to reproduce the steps etc. 

The main QC fastq output is named by prefix.anqdpht.fast.gz. 

```
|-- 8434.1.102069.ACAGTG.anqdpht.fastq.gz
|-- filterStats.txt
|-- filterStats.json
|-- filterStats2.txt
|-- adaptersDetected.fa
|-- reproduce.sh
|-- spikein.fq.gz
|-- status.log
|-- ...
```
