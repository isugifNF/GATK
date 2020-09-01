#! /usr/bin/env nextflow

bedtools_container = 'kathrinklee/bwa'

process bedtools_help {
  label 'bedtools'

  container = "$bedtools_container"
  
  output: path 'bedtools_out.txt'

  """
  bedtools --help > bedtools_out.txt
  """
}

process bedtools_coords {
    tag "$name"
    label 'bedtools'
    publishDir "${params.outdir}/bedtools", mode: 'copy'

    input:
    val window=1000000
    val genome_length
    
    output:
    path "*_coords.bed"

    script:
    """
    bedtools makewindow -w $window -g $genome_length |\
      awk '{print \$1"\t"\$2+1"\t"\$3}' |\
      sed 's/\t/:/1' |\
      sed 's/\t/-/1' > name_coords.bed
    """
}