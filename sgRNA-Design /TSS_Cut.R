library(data.table)
library(dplyr) 

##################################################
#' Instructions: 
#' 1. set the guide_design_region to the length you would like
#' 2. run the code, and ensure input and output file paths and names are correct. 
#' 3. run. 

#################################################
#### Guide design region
#### Set guide length
#################################################

guide_design_region <- 90

######################################################
#### Read in the file and convert into a single cell

dt <- tibble(
  main = paste(
    readLines("C:/Path-to-features/Prepped_Features.txt"), collapse = "") )
  
dt_2 <-  tidyr::separate_rows(dt,main, sep = ",")

### Create a rowid for each gene
rowid <- sort(rep(seq(1,nrow(dt_2) / 2 ,1), 2))
dt_3 <- mutate(dt_2, 
               rown = (row_number() %% 2) + 1,
               row_number = rowid) %>% 
  as.data.table()

#### Make each row a unique gene
dt_4 <- dcast(dt_3, row_number ~ rown , value.var = "main") %>% 
  rename(full_gene_name = `2`,
         promoter_sequence_sp = `1` )

#### Find the complete gene name
dt_4$gene_name_a <- as.character(lapply(strsplit(as.character(dt_4$full_gene_name), split=" "), "[", 1)) 
dt_4$gene_name_b <- as.character(lapply(strsplit(as.character(dt_4$gene_name_a), split="[|]"), "[", 1)) 
dt_4$gene_name <- gsub("[^[:alnum:]]|?", "", dt_4$gene_name_b)

#### Remove white spaces from gene if there are any
dt_4$promoter_sequence <- gsub(" ", "", dt_4$promoter_sequence_sp)
dt_5 <- dt_4[,.(gene_name, promoter_sequence)]

##########
### Bring in the xlsx file
#########
gene_lookup <- readxl::read_xlsx("C:/Path-to-table/TSS_Data.xlsx") %>% 
  filter(row_number() >1 ) %>% 
  rename(gene_name = `Sorted by Chromosome`,
         tss = `...2`) %>% 
  select(gene_name, tss)

#### Merge on gene names:
complete_lookup <- inner_join(dt_5, 
                         gene_lookup, 
                         by = "gene_name") %>% 
  #### Find the tss region. guide_design_region is set at top of script. 
  mutate(
    tss_index = 1500 - as.numeric(tss) - guide_design_region,
    tss_region = base::substr(promoter_sequence , 1, tss_index))

#### Function to write fasta file
writeFasta<-function(data, filename){
  fastaLines = c()
  for (rowNum in 1:nrow(data)){
    fastaLines = c(fastaLines, as.character(paste(">", data[rowNum,"gene_name"], sep = "")))
    fastaLines = c(fastaLines,as.character(data[rowNum,"tss_region"]))
  }
  fileConn<-file(filename)
  writeLines(fastaLines, fileConn)
  close(fileConn)
}

writeFasta(complete_lookup,
           "C:/Output-path/output.fasta")
