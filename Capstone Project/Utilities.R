library(stringi)
library(stringr)

#--------------------------------------------------------------------
# Determines the number of lines in the given text file
#
# Args:
#   textFilePath: Full path to the file
#
# Returns:
#   num_lines: # of lines in the given file
#--------------------------------------------------------------------
CalculateTextFileLines = function(textFilePath){
  
  # http://www.inside-r.org/packages/cran/R.utils/docs/countLines
  fileConn = file(file.path(textFilePath), "rb")
  numLines = countLines(fileConn)
  close(fileConn)
  return (numLines[1])
}


#--------------------------------------------------------------------
# Counts the number of words in the given text file
#
# Args:
#   textFilePath: Full path to the file
#
# Returns:
#   num_words: # of words in the given file
#--------------------------------------------------------------------
CountWordsInTextFile = function(textFilePath){
  
  lines_to_read = min(ceiling(CalculateTextFileLines(textFilePath)/10), 10000)
  
  # http://stackoverflow.com/questions/15532810/reading-40-gb-csv-file-into-r-using-bigmemory?lq=1
  # http://stackoverflow.com/questions/9934856/removing-non-ascii-characters-from-data-files
  # http://www.r-bloggers.com/counting-the-number-of-words-in-a-latex-file-with-stringi/  
  fileConn = file(file.path(textFilePath), "r", blocking=FALSE)
  currentChunk = readLines(fileConn, lines_to_read, skipNul=TRUE)
  firstChunk = TRUE  
  wordCount = 0
  
  repeat {
    if (length(currentChunk) == 0) {
      break
    }
    else {
      currentChunk = str_trim(iconv(currentChunk,"latin1","ASCII",sub=""))      
      currentStats = as.data.frame(t(stri_stats_latex(currentChunk)))      
      wordCount = wordCount + currentStats$Words
    }
    currentChunk = readLines(fileConn, lines_to_read, skipNul=TRUE)
  }
  close(fileConn)  
  return(wordCount)
}


#--------------------------------------------------------------------
# Generates a random sample of each text file contained in a 
# directory
#
# Args:
#   corpusDirectory: Full path to a directory that contains the full
#                    corpus
#
#   percentageToSample: Percentage of data to sample for each corpus
#                       (text) file
#
#   outputTextFileDirectory: Directory to store random sample output
#
#
# Returns:
#   None
#--------------------------------------------------------------------
CreateRandomCorpusSample = function(corpusDirectory, samplingPercentage, outputDirectory){
  
  for(curTextFile in dir(corpusDirectory, pattern="(.)*.txt")) {
   
    print(sprintf("Generating a %.2f%% random sample of %s",
                  percentageToSample, curTextFile))  
    
    curOutputFileName = paste0(strsplit(curTextFile,"\\.txt"),"sample.txt")
    
    sampleTextFile(file.path(corpusDirectory,
                             curTextFile),                  
                   percentageToSample,
                   file.path(outputDirectory,
                             curOutputFileName))
  }
    
}





#--------------------------------------------------------------------
# Generates a random sample of a text file and writes it to disk
#
# Args:
#   inTextFilePath: Full path to the input text file
#
#   num_lines: List that stores the number of lines of each text file
#              contained in a directory
#
#   percentageToSample: % of the text file to sample
#
#   outTextFilePath: Full path to the output text file that is a 
#                    random sample of the input text file
#
#   displayStatus: Optional Boolean input that controls whether or not
#                  text document processing status is printed to the 
#                  status window
#
# Returns:
#   sample_line_idx: Vector that stores which lines of the input
#                    text were written to the output text file
#--------------------------------------------------------------------
sampleTextFile <- function(inputTextFilePath,                          
                           percentageToSample,
                           outputTextFilePath) {  
 
  lines_to_read <- ceiling(10 / (percentageToSample / 100))  
  print(sprintf("Finding number of lines in file %s", inputTextFilePath))  
  num_lines = CalculateTextFileLines(inputTextFilePath)  
  
  # http://stackoverflow.com/questions/15532810/reading-40-gb-csv-file-into-r-using-bigmemory?lq=1
  # http://stackoverflow.com/questions/7260657/how-to-read-whitespace-delimited-strings-until-eof-in-r
  maxLinesToRead = ceiling(num_lines/10)
  minLinesToRead = ceiling(num_lines/100)
  
  if (lines_to_read > maxLinesToRead) {
    lines_to_read = maxLinesToRead
  }else if (lines_to_read < minLinesToRead) {
    lines_to_read = minLinesToRead
  }
  
  sample_line_idx = numeric()
  file_subset = character()
  print("--------------------------------------------------------------")
  print(sprintf("Generating random sample of %s",
                basename(inputTextFilePath)))  
  
  h_conn = file(inputTextFilePath, "r", blocking=FALSE)
  lines_read = 0
  repeat {
    cur_chunk = readLines(h_conn, lines_to_read, skipNul=TRUE)
    
    if (length(cur_chunk) == 0) {
      break
    }
    else {            
      cur_sample_line_idx = which(rbinom(lines_to_read,
                                          1,
                                          percentageToSample/100) == 1)
      
      file_subset = append(file_subset,
                            cur_chunk[cur_sample_line_idx])
      
      sample_line_idx = append(sample_line_idx,
                                cur_sample_line_idx + lines_read)
      
      lines_read = lines_read + lines_to_read
      
      print(sprintf("Lines read: %d (Out of %d)",
                    lines_read,
                    num_lines))
    }
  }
  close(h_conn)
  
  print(sprintf("Requested sampling percentage: %.5f", percentageToSample))
  
  print(sprintf("Percentage of lines sampled: %.5f",
                100.0*length(file_subset) / 
                  num_lines))
  
  # Write the random sample to a text file
  if(!file.exists(outputTextFilePath)){
    file.create(outputTextFilePath)
  }
  
  h_conn = file(outputTextFilePath, "w")
  write(file_subset, file=h_conn)
  close(h_conn)
  
  return(sample_line_idx)
}
