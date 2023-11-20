import pandas as pd

## SETUP ======================================================================
# table of protein coding gene regions
genes_bed = pd.read_csv(
  "/scratch/Shares/layer/workspace/christopher_lair/stix_giggle_fusion/genelist/hg19.protein_coding.bed",
  sep="\t",
  names=["chr", "start", "end", "name", "strand"],
)
# list of gene names to use as wildcard in rules
genes = genes_bed["name"].tolist()


## RULES ======================================================================
rule All:
  input:
    expand(f'/scratch/Shares/layer/workspace/christopher_lair/stix_giggle_fusion/scripts/results/{{gene}}.txt', gene=genes)

rule STIX1kgGeneQuery:
  """
  Given a particular gene, query the 1kg STIX index
  Let the left and right intervals be the whole gene
  """
  input:
    index = "/scratch/Shares/layer/workspace/christopher_lair/stix_giggle_fusion/1kg_data/alt_sort_b",
    ped_db = "/scratch/Shares/layer/workspace/christopher_lair/stix_giggle_fusion/1kg_data/1kg.ped.db"
  params:
    chrom = lambda w: genes_bed[genes_bed['name'] == w.gene]['chr'].values[0],
    start = lambda w: genes_bed[genes_bed['name'] == w.gene]['start'].values[0],
    end =   lambda w: genes_bed[genes_bed['name'] == w.gene]['end'].values[0],
  output:
    f'/scratch/Shares/layer/workspace/christopher_lair/stix_giggle_fusion/scripts/results/{{gene}}.txt'
 

  shell:
    f"""
    bash stix_query.sh \\
    -i {{input.index}} \\
    -d {{input.ped_db}} \\
    -l {{params.chrom}}:{{params.start}}-{{params.start}} \\
    -r {{params.chrom}}:{{params.end}}-{{params.end}} \\
    -t DEL \\
    -o {{output}}
    """



