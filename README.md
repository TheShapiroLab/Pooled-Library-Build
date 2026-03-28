# Pooled-Library-Build
Candida albicans CRISPRi/a-dCas Pooled Library Design

This is a basic set of scripts you can use to convert the initial, complete upstream sequence of each gene in your pooled library into the isolated promoter region you can design sgRNAs to target.

The TSS_data.xlsx file contains TSS (5' UTR) information of each gene in the genome, originally from Lu and Lin Genome Res, 2021 ('The origin and evolution of a distinct mechanism of transcription initiation in yeasts'). The genes that were not annotated with a 5' UTR in that paper are listed in the .xlsx file with a 5' UTR of 0.

The TSS_Trim.R script first takes the input list of ORFs and upstream promoter sequences (from Example_Input.txt) and trims everything downstream of the TSS. The following Upstream_Trim.py script takes the desired size of the target region and, in the output files from the TSS_Trim.R script (for example, Example_Input_2.fasta), trims everything upstream of this region.

The resulting target regions can be uploaded to the Eukaryotic Pathogen CRISPR guide RNA/DNA Design Tool (Peng and Tarleton, Microb Genom, 2015) or other CRISPR design software to generate a list of corresponding sgRNAs.
