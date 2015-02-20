library(stringi)
library(stringr)
library(data.table)

# RWeka Trigram Tokenizer
TrigramTokenizer = function(x) {
  RWeka::NGramTokenizer(x, RWeka::Weka_control(min = 3, max = 3))
}


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
  
  dir.create(file.path(outputDirectory))
  for(curTextFile in dir(corpusDirectory, pattern="(.)*.txt")) {
   
    print(sprintf("Generating a %.2f%% random sample of %s",
                  percentageToSample, curTextFile))  
    
    curOutputFileName = paste0(strsplit(curTextFile,"\\.txt"),"sample.txt")
    
    SampleTextFile(file.path(corpusDirectory,
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
#   percentageToSample: % of the text file to sample
#
#   outTextFilePath: Full path to the output text file that is a 
#                    random sample of the input text file
#
# Returns:
#   sample_line_idx: Vector that stores which lines of the input
#                    text were written to the output text file
#--------------------------------------------------------------------
SampleTextFile = function(inputTextFilePath,                          
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





#--------------------------------------------------------------------
# Generates corpus from the content of the text file. 
# In addition to that, the content of the file is modified
# as follows:
#       Remove non-ASCII characters
#       Removes punctuation
#       Removes whitespace
#       Converts text to lower case
#       Removes words that are in the 'black list'
#
# Args:
#   textFilePath: Full path to the input text file
#
#   blackList: Character vector that stores a list of words to exclude from
#              from corpus/text file content
#
# Returns:
#   corp: corpus of the file content
#--------------------------------------------------------------------
LoadCorpusFromTextFile = function(textFilePath,  blackList){
  fileConn = file(file.path(textFilePath), "r", blocking=FALSE)
  currentChunk = readLines(fileConn, skipNul=TRUE)
  
  # Create the corpus/text file content
  corp = Corpus(VectorSource(currentChunk))
  
  # Remove non ascii characters from text file
  corp = tm_map(corp, removeNonASCII)
  
  # Remove punctuations
  corp = tm_map(corp, customRemovePunctuation)
  
  # Remove numbers
  corp = tm_map(corp, removeNumbers)
  
  # Remove white space
  corp = tm_map(corp, stripWhitespace)
  
  # Convert to lower case
  corp = tm_map(corp, convertToLowerCase)
  
  # Remove black list words
  corp = tm_map(corp, removeWords, blackList)
  close(fileConn)
  
  return (corp)
}




#--------------------------------------------------------------------
# Generates corpus from the provided data chunk. 
# In addition to that, the data chunk is modified
# as follows:
#       Remove non-ASCII characters
#       Removes punctuation
#       Removes whitespace
#       Converts text to lower case
#       Removes words that are in the 'black list'
#
# Args:
#   dataChunk: Character vector containing lines of data from a text file
#
#   blackList: Character vector that stores a list of words to exclude from
#              from corpus/text file content
#
# Returns:
#   corp: corpus of the data chunk
#--------------------------------------------------------------------
LoadCorpusFromDataChunk = function(dataChunk,  blackList){  
  currentChunk = dataChunk
  
  # Create the corpus/text file content
  corp = Corpus(VectorSource(currentChunk))
  
  # Remove non ascii characters from text file
  corp = tm_map(corp, removeNonASCII)
  
  # Remove punctuations
  corp = tm_map(corp, customRemovePunctuation)
  
  # Remove numbers
  corp = tm_map(corp, removeNumbers)
  
  # Remove white space
  corp = tm_map(corp, stripWhitespace)
  
  # Convert to lower case
  corp = tm_map(corp, convertToLowerCase)
  
  # Remove black list words
  corp = tm_map(corp, removeWords, blackList) 
  
  return (corp)
}


# http://stackoverflow.com/questions/9934856/removing-non-ascii-characters-from-data-files
# http://stackoverflow.com/questions/18153504/removing-non-english-text-from-corpus-in-r-using-tm
removeNonASCII <-
  content_transformer(function(x) iconv(x, "latin1", "ASCII", sub=""))

# http://stackoverflow.com/questions/14281282/
# how-to-write-custom-removepunctuation-function-to-better-deal-with-unicode-cha
#
# http://stackoverflow.com/questions/8697079/remove-all-punctuation-except-apostrophes-in-r
customRemovePunctuation <- content_transformer(function(x) {
  x <- gsub("[[:punct:]]"," ",tolower(x))
  return(x)
})

# Convert to lower case
convertToLowerCase = content_transformer(function(x) tolower(x))

#--------------------------------------------------------------------
# Generates Bigram Term Document Matrix from the provided Corpus
#
# Args:
#   corpus: The provided corpus
#
#
# Returns:
#   bigram_DTM: Term Document Matrix with the Bigrams
#--------------------------------------------------------------------
GenerateBigramTermDocumentMatrix = function(corpus){
  BigramTokenizer = function(x) {
    RWeka::NGramTokenizer(x, RWeka::Weka_control(min = 2, max = 2))
  }
  
  bigram_DTM = TermDocumentMatrix(combinedCorpus,control = list(tokenize = BigramTokenizer))
  return (bigram_DTM)
}


#--------------------------------------------------------------------
# Generates Trigram Term Document Matrix from the provided Corpus
#
# Args:
#   corpus: The provided corpus
#
#
# Returns:
#   trigram_DTM: Term Document Matrix with the Trigrams
#--------------------------------------------------------------------
GenerateTrigramTermDocumentMatrix = function(corpus){
 
  trigram_DTM = TermDocumentMatrix(combinedCorpus,control = list(tokenize = TrigramTokenizer))
  return (trigram_DTM)
}


#-----------------------------------------------------------------
# Transforms the row sums of a TermDocumentMatrix into a 
# data.table
#
# Args:
#   curTDM: Term Document Matrix
#
# Returns:
#   curTermFreq: data.table that stores the row sums of a 
#                term document matrix
#-----------------------------------------------------------------
computeTermFrequencies = function(curTDM) {
  
  curTermFreq = sort(rowSums(as.matrix(curTDM)), decreasing=TRUE)
  
  curTermFreq = as.data.frame(curTermFreq)
  curTermFreq$unigram = rownames(curTermFreq)
  rownames(curTermFreq) = NULL
  colnames(curTermFreq) = c("count","unigram")
  curTermFreq = as.data.table(curTermFreq)
  setkey(curTermFreq,unigram)
  
  return(curTermFreq)
}



#-----------------------------------------------------------------
# Initializes a list of common terms based on term frequencies
# estimated from a set of text files
#
# Args:
#   outputTextFileDirectory: String that stores the full path
#                            to a directory that stores RData
#                            file(s) that contain term frequencies
#
#   cdfThreshold: Term frequency Cumulative Distribution Function
#                 (CDF) that controls the select of common terms.
#
#                 KEY POINT: The term frequency CDF may not sum
#                            to 1 depending on the chunk sparsity
#                            input to the R script that computes
#                            term frequencies
#
# Returns:
#   None - Writes the common terms to an RData file (i.e. 
#          "commonTerms.RData") in outputTextFileDirectory
#-----------------------------------------------------------------
findCommonTerms = function(outputTextFileDirectory, cdfThreshold) {
  
  combinedTermFreqsDT = data.table()
  combined_word_count = 0
  
  for (curTermFreqsFile in dir(outputTextFileDirectory, pattern=".*Terms.RData")) {
    load(file.path(outputTextFileDirectory, curTermFreqsFile))
    
    combined_word_count = combined_word_count + word_count    
    print(sprintf("# of rows: %d in %s", nrow(termFreqs), curTermFreqsFile))
    
    if (nrow(combinedTermFreqsDT) == 0) {
      combinedTermFreqsDT = termFreqs
    }else {
      combinedTermFreqsDT = mergeTermFrequencyDataTables(combinedTermFreqsDT, termFreqs)
    }
  }
  
  combinedTermFreqs = combinedTermFreqsDT$count  
  names(combinedTermFreqs) = combinedTermFreqsDT$unigram  
  combinedTermPDF = sort(combinedTermFreqs / combined_word_count, decreasing=TRUE)
  
  combinedTermCDF = cumsum(combinedTermPDF)
  cutoff_idx = which(combinedTermCDF >= cdfThreshold)[1]  
  commonTerms = names(combinedTermCDF[1:cutoff_idx])
  
  printf("CDF threshold: %f # of terms: %d", cdfThreshold, length(commonTerms))  
  combinedTermPDF = combinedTermPDF[1:cutoff_idx]
  combinedTermPDF = combinedTermPDF / sum(combinedTermPDF)
  
  save(file=file.path(outputTextFileDirectory,"commonTerms.RData"), commonTerms, combinedTermPDF)    
}




#-----------------------------------------------------------------
# Initializes a named numeric vector that stores trigram counts
#
# Args:
#   cur_chunk: Character vector that stores a subset of a text 
#              file
#
#   blackList: Character vector that stores a list of words to 
#              exclude from a line corpus
#
# Returns:
#   tdmTri: Named numeric vector that stores trigram counts
#-----------------------------------------------------------------
tokenizeTrigrams = function(cur_chunk, blackList) {
 
  curLineCorpus = LoadCorpusFromDataChunk(cur_chunk, blackList)
  
  #http://stackoverflow.com/questions/17703553/bigrams-instead-of-single-words-
  #   in-termdocument-matrix-using-r-and-rweka
  options(mc.cores=1)
  tdmTri = 
    as.matrix(TermDocumentMatrix(curLineCorpus,
                                 control =
                                   list(tokenize = TrigramTokenizer)))
  
  tdmTri = rowSums(as.matrix(tdmTri))
  
  return(tdmTri)
}


#-----------------------------------------------------------------
# Initializes a numeric vector that stores the indices 
# corresponding to trigrams that are constructed from the
# input vocabulary
#
# Args:
#   tdmTri: Named numeric vector that stores trigram counts
#
#   vocabulary: Character vector that stores a vocabulary
#
# Returns:
#   commonIdx: numeric vector that stores the indices 
#              corresponding to trigrams that are constructed
#              from the input vocabulary
#-----------------------------------------------------------------
initializeCommonTrigramIndices = function(curTriTdm,
                                           vocabulary) {
 
  trigrams = names(curTriTdm)
  commonIdx = numeric()
  
  for (n in seq_len(length(trigrams))) { 
    curWords = unlist(str_split(trigrams[n]," "))
    
    if (sum(curWords %in% vocabulary) == 3) {
      commonIdx = append(commonIdx,n)
    }
  }
  
  return(commonIdx)    
}