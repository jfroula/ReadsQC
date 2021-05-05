
import "rqcfilter.wdl" as rqc

workflow test_small {
  String  container="microbiomedata/bbtools:38.90"
  String  validate_container="microbiomedata/comparejson"
  String  database="/refdata"
  Boolean chastityfilter_flag=false
  String? memory="60G"
  String? threads="8"
  String  url="https://portal.nersc.gov/cfs/m3408/test_data/Ecoli_10x-int.fastq.gz"
  String  ref_json="https://raw.githubusercontent.com/microbiomedata/ReadsQC/master/test/small_test_filterStats.json"
  
  call prepare {
    input: container=container,
           url=url,
           ref_json=ref_json
  }
  call rqc.rqcfilter as filter {
    input: input_file=prepare.fastq,
           database=database,
           container=container,
           chastityfilter_flag=chastityfilter_flag,
           memory=memory,
           threads=threads
  }
  call validate {
    input: container=validate_container,
           ref_json=ref_json,
           user_json=filter.json_out
  }
}
task prepare {
   String container
   String ref_json
   String url
   command{
       wget -O "input.fastq.gz" ${url}
       wget -O "ref_json.json" ${ref_json}
   }
   output{
      File fastq = "input.fastq.gz"
      File ref_json = "ref_json.json"
   }
   runtime {
     memory: "1 GiB"
     cpu:  2
     maxRetries: 1
     docker: container
   }
}
task validate {
   String container
   File ref_json
   File user_json

   command {
       compare_json.py -i ${ref_jason} -f ${user_json}  
   }
   output {
       String result = read_lines(stdout())
   }
   runtime {
     memory: "1 GiB"
     cpu:  1
     maxRetries: 1
     docker: container
   }
}