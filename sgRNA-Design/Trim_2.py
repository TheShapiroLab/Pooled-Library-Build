import os
#Open the isolated regions file from the R code and read each line as a unique element, then strip the line breaks
with open ("/Path-to-Input/Example_Input_2.fasta") as file:
    datalines=[x.strip() for x in file.readlines()]

#Prepare to save the output of the following loop as a new file called target_regions.txt 
out=open("/Path-to-Output/target_regions.txt", "w")

#Loop through each line in the file and if the length of the line is longer than 10bp (ie. DNA sequence and not a name), output the last 300bp
for lines in datalines:
    if(len(lines)>10):
        out.write(lines[-300:])
        out.write("\n")
    else:
          out.write(lines)
          out.write("\n")
