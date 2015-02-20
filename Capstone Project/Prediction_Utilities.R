source("./Utilities.R")

#-----------------------------------------------------------------
# Merges two data tables that store term frequencies
#
# Args:
#   termFreqsX: Data frame that contains term frequencies
#
#   termFreqsY: Data frame that contains term frequencies
#
# Returns:
#   mergedTermFreqs: Data frame that contains term frequencies
#-----------------------------------------------------------------
mergeTermFrequencyDataTables = function(termFreqsX, termFreqsY) {
  
  mergedTermFreqs = merge(termFreqsX, termFreqsY, all=TRUE)
  mergedTermFreqs$count.x[is.na(mergedTermFreqs$count.x)] = 0
  mergedTermFreqs$count.y[is.na(mergedTermFreqs$count.y)] = 0
  
  mergedTermFreqs = as.data.frame(mergedTermFreqs)
  mergedTermFreqs$count = mergedTermFreqs$count.x +  mergedTermFreqs$count.y
  mergedTermFreqs = data.table(mergedTermFreqs[,c("count","unigram")])
  setkey(mergedTermFreqs,unigram)    
}


#------------------------------------------------------------------
# Initializes the sampling of a file chunk
#
# Args:
#   curNumLinesToRead: Integer that stores the number of lines to
#                      read from a text file
#
# Returns:
#   chunkSampling: List that stores a description of the current
#                  file chunk sampling
#------------------------------------------------------------------
initializeChunkSampling = function(curNumLinesToRead) {

  line_idx = seq(1,curNumLinesToRead)
  
  chunkSampling = list()
  
  chunkSampling$train_data_idx = 
    which(rbinom(curNumLinesToRead,1,0.6) == 1)
  
  line_idx = 
    line_idx[!line_idx %in% chunkSampling$train_data_idx]
  
  chunkSampling$test_data_idx = 
    line_idx[which(rbinom(length(line_idx),1,0.5) == 1)]
  
  chunkSampling$validation_data_idx = 
    line_idx[!line_idx %in% chunkSampling$test_data_idx]    
  
  return(chunkSampling)
}



#--------------------------------------------------------------------
# Splits a text data file into training, testing, & validation 
# data sets (using a 60%/20%/20% split)
#
# Args:
#   inTextFilePath: Full path to the input text file
#
#   outputTextFileDirectory: Full path to output text file directory 
#
#   num_lines: List that stores the number of lines of each text file
#              contained in a directory
#
# Returns:
#   None
#--------------------------------------------------------------------
splitFileContent = function(inputTextFilePath, outputTextFileDirectory, num_lines) {
 
  total_num_lines = CalculateTextFileLines(inputTextFilePath) 
  num_lines_to_read = ceiling(total_num_lines/100)
  
  filePrefix = unlist(str_split(basename(inputTextFilePath),"\\.txt"))[1]
  
  trainingDataPath = file.path(outputTextFileDirectory,
                                paste0(filePrefix,"_TrainingData.txt"))
  
  testDataPath = file.path(outputTextFileDirectory,
                            paste0(filePrefix,"_TestData.txt"))
  
  validationDataPath = file.path(outputTextFileDirectory,
                                  paste0(filePrefix,"_ValidationData.txt"))
  
  h_inputConn = file(inputTextFilePath, "r", blocking=FALSE)
  
  h_trainingDataConn = file(trainingDataPath, "w")
  h_testDataConn = file(testDataPath, "w")
  h_validationDataConn <= file(validationDataPath, "w")
  
  lines_read = 0
  repeat {
    cur_chunk = readLines(h_inputConn, num_lines_to_read, skipNul=TRUE)
    
    if (length(cur_chunk) == 0) {
      break
    }
    else {
      lines_read = lines_read + length(cur_chunk)
      
      print("---------------------------------------------------")
      
      print(sprintf('Read %d lines (Out of %d)', lines_read,
                    total_num_lines))
      
      chunkSampling = initializeChunkSampling(length(cur_chunk))
      
      percentSampling = c(length(chunkSampling$train_data_idx),
                           length(chunkSampling$test_data_idx),
                           length(chunkSampling$validation_data_idx))
      
      percentSampling = 100*percentSampling/sum(percentSampling)
      
      print(sprintf('Training data: %.2f%%', percentSampling[1]))
      print(sprintf('Test data: %.2f%%', percentSampling[2]))
      print(sprintf('Validation data: %.2f%%', percentSampling[3]))
      
      write(cur_chunk[chunkSampling$train_data_idx],
            file=h_trainingDataConn)
      
      write(cur_chunk[chunkSampling$test_data_idx],
            file=h_testDataConn)
      
      write(cur_chunk[chunkSampling$validation_data_idx],
            file=h_validationDataConn)
    }
  }
  
  close(h_inputConn)
  close(h_trainingDataConn)
  close(h_testDataConn)
  close(h_validationDataConn)
}



#--------------------------------------------------------------------
# Splits a set of text data files into training, testing, & 
# validation data sets (using a 60%/20%/20% split)
#
# Args:
#   inputTextDataPath: Full path to a directory that stores text 
#   data files
#
#   outputTextFileDirectory: Full path to output text file directory 
#
#   num_lines: List that stores the number of lines of each text file
#              contained in a directory
#
# Returns:
#   None
#--------------------------------------------------------------------
splitTextFiles = function(inputTextDataPath, outputTextFileDirectory, num_lines) {
  
  # For each text file in the directory, split the contents into 
  # 3 separate files - training, testing and validation
  for (curTextFile in dir(inputTextDataPath, pattern=".*txt$")) {
    inputTextFilePath = file.path(inputTextDataPath,curTextFile)
    
    splitFileContent(inputTextFilePath, outputTextFileDirectory, num_lines)
  }
}


#-----------------------------------------------------------------
# Computes the unigram (i.e. word) statistics of a set of text 
# file(s) contained in a directory
#
# Args:
#   textFileDirectory: String that stores the full path to a text
#                      data file directory
#
#   textFilePattern: Regular expression that refers to a set of 
#                    text files
#
#
#   blackList: Character vector that stores a list of words to 
#              exclude from a line corpus
#
#   chunkSparsity: Optional floating point input that defines 
#                  the removeSparseTerms() sparse input
#
# Returns:
#   None (This R script writes the "[TextFileName]Terms.RData file to 
#         textFileDirectory that has the same prefix as
#         textDataFile)
#-----------------------------------------------------------------
analyzeTextDataUnigramStatistics = function(textFileDirectory, textFilePattern, blackList, chunkSparsity = 0.999) {

  for (curTextFile in dir(textFileDirectory,pattern=textFilePattern)) {
    
    # file prefix
    filePrefix = unlist(str_split(curTextFile,"\\.txt"))[1]
    
    # iterate through each text file, compute the unigram statistics and write to file
    if (!file.exists(file.path(textFileDirectory, paste0(filePrefix,"Terms.RData")))) {
      
      analyzeUnigramStatistics(textFileDirectory, curTextFile, blackList, chunkSparsity)
    }
  }    
}



#-----------------------------------------------------------------
# Computes the unigram (i.e. word) statistics of a text file
#
# Args:
#   textFileDirectory: String that stores the full path to a text
#                      data file directory
#
#   textDataFile: Name of a text data file
#
#   blackList: Character vector that stores a list of words to 
#              exclude from a line corpus
#
#   chunkSparsity: Optional floating point input that defines 
#                  the removeSparseTerms() sparse input
#
# Returns:
#   None (This R script writes the "[TextFileName]Terms.RData file to 
#         textFileDirectory that has the same prefix as
#         textDataFile)
#-----------------------------------------------------------------
analyzeUnigramStatistics = function(textFileDirectory, textDataFile, blackList,
                                     chunkSparsity = 0.999) {
    
  
  inputTextFilePath = file.path(textFileDirectory, textDataFile)  
  total_num_lines = CalculateTextFileLines(inputTextFilePath)
  num_lines_to_read = ceiling(total_num_lines/100)
  
  firstChunk = TRUE
  lines_read = 0
  word_count = 0
  h_conn = file(inputTextFilePath, "r", blocking=FALSE)    
  
  print(sprintf("Analyzing %s", textDataFile))
  
  repeat {    
    cur_chunk = readLines(h_conn, num_lines_to_read, skipNul=TRUE)
    
    if (length(cur_chunk) > 0) {
      lines_read = lines_read + length(cur_chunk)
      
      print("-------------------------------------------------------------")
      print(sprintf("Lines read: %d (Out of %d)", lines_read, total_num_lines))
      
      # split the line into words
      cur_chunk = gsub("\\W+"," ", cur_chunk) 
      
      if (length(cur_chunk) == 0) {
        break
      }
      else {
        # Create corpus from the data chunk
        curLineCorpus = LoadCorpusFromDataChunk(cur_chunk, blackList)
        
        # Compute document matrix for the given corpus
        curTDM = TermDocumentMatrix(curLineCorpus)
        
        # Compute total number of Words in document matrix
        word_count = word_count + sum(rowSums(as.matrix(curTDM)))
        
        # Remove sparsity
        curTDM = removeSparseTerms(curTDM, chunkSparsity)
        
        # Compute Term Document Frequency 
        # http://www.jiem.org/index.php/jiem/article/viewFile/293/252/2402
        curChunkTermFreqs = computeTermFrequencies(curTDM)
        
        if (firstChunk == TRUE) {
          termFreqs = curChunkTermFreqs
          firstChunk = FALSE
        }else {
          termFreqs =  mergeTermFrequencyDataTables(termFreqs, curChunkTermFreqs)
        }
        
        rm(cur_chunk)
        rm(curLineCorpus)
        rm(curChunkTermFreqs)
#         
#         print(sprintf("Current number of terms: %d", nrow(termFreqs)))
      }
    } else {
      break
    }
  }
  close(h_conn)
  filePrefix = unlist(str_split(basename(inputTextFilePath),"\\.txt"))[1]
  save(file=file.path(textFileDirectory,paste0(filePrefix,"Terms.RData")), termFreqs, word_count)
}




#-----------------------------------------------------------------
# Initializes a Markov chain transition matrix
#
# Args:
#   textFileDirectory: String that stores the full path to a text
#                      data file directory
#
#   commonTerms: Character vector that stores common terms (i.e
#                words that are used to segment trigrams
#
#   blackList: Character vector that stores a list of words to 
#              exclude from a line corpus
#
# Returns:
#   None (Writes the transiition matrix to an RData file before
#         after normalization)
#-----------------------------------------------------------------
constructTransitionMatrix = function(textFileDirectory, commonTerms, blackList) {
  
  trainingDataFiles = dir(outputTextFileDirectory, pattern=".*TrainingData.txt")
  
  for (n in seq_len(length(trainingDataFiles))) {
    #inputTextFilePath = file.path(textFileDirectory, trainingDataFiles[n])     
    curTransitionMatrix = initializeTrigramCounts(textFileDirectory, trainingDataFiles[n], commonTerms, blackList)
    
    if (n == 1) {
      transitionMatrix = curTransitionMatrix
    } else {
      transitionMatrix = transitionMatrix + curTransitionMatrix
    }
  }
  
  minProbability = 0.01/(length(commonTerms)-1)
  
  for (m in seq_len(nrow(transitionMatrix))) {
    curRowSum = sum(transitionMatrix[m,])
    
    if (curRowSum > 0) {
      transitionMatrix[m,] = 
        transitionMatrix[m,] / curRowSum
    } else {
      transitionMatrix[m,m] = 0.99
      
      n = seq_len(ncol(transitionMatrix))
      n = n[n != m]
      transitionMatrix[m,n] = minProbability
    }
  }
  save(file="./transitionMatrix.RData", transitionMatrix)
}





#-----------------------------------------------------------------
# Initializes triagram counts in a Markov chain transition matrix
# https://www.youtube.com/watch?v=Flj52QaHYVU
#
# Args:
#   textFileDirectory: String that stores the full path to a text
#                      data file directory
#
#   textDataFile: Name of a text data file
#
#   commonTerms: Character vector that stores common terms (i.e
#                words that are used to segment trigrams
#
#   blackList: Character vector that stores a list of words to 
#              exclude from a line corpus
# Returns:
#   transitionMatrix: Square matrix that stores term counts
#                     (this matrix is an unnormalized Markov chain
#                      transition matrix)
#-----------------------------------------------------------------
initializeTrigramCounts = function(textFileDirectory,
                                    textDataFile,                                   
                                    commonTerms,
                                    blackList) { 
  
  inputTextFilePath = file.path(textFileDirectory, textDataFile)  
  total_num_lines = CalculateTextFileLines(inputTextFilePath)  
  num_lines_to_read = 2500
  
  lines_read = 0
  word_count = 0
  h_conn = file(inputTextFilePath, "r", blocking=FALSE)
  
  print("---------------------------------------------------------")
  print(sprintf("Analyzing %s", textDataFile))
  
  vocabularySize = length(commonTerms)  
  transitionMatrix = matrix(numeric(vocabularySize^2),
                            byrow=TRUE,
                            nrow=vocabularySize,
                            dimnames=list(commonTerms,
                                          commonTerms))
  
  transitionMatrixPath = 
    file.path(dirname(inputTextFilePath),
              paste0(unlist(str_split(textDataFile,"\\.txt"))[1],
                     "_TransitionMatrix.RData"))
  
  repeat {
    cur_chunk <- readLines(h_conn, num_lines_to_read, skipNul=TRUE)
    
    if (length(cur_chunk) > 0) {
      lines_read = lines_read + length(cur_chunk)
      
      print("---------------------------------------------------------")
      print(sprintf("Lines read: %d (Out of %d)", lines_read, total_num_lines))
      
      # http://stackoverflow.com/questions/9546109/how-to-
      #   remove-002-char-in-ruby
      #
      # http://stackoverflow.com/questions/11874234/difference-between-w-
      #   and-b-regular-expression-meta-characters
      cur_chunk <- gsub("\\W+"," ", cur_chunk)   
      
      if (length(cur_chunk) == 0) {
        break
      }
      else {
        tdmTri = tokenizeTrigrams(cur_chunk, blackList)        
        commonIdx = initializeCommonTrigramIndices(tdmTri, commonTerms)
        
        commonTriTdm = tdmTri[commonIdx]
        
        for (m in seq_len(length(commonTriTdm))) {                    
          curWords = unlist(str_split(names(commonTriTdm[m])," "))
          
          for (n in seq(2,3)) {
            rowIdx = which(grepl(paste0("^",curWords[n-1],"$"),
                                  commonTerms))
            
            colIdx = which(grepl(paste0("^",curWords[n],"$"),
                                  commonTerms))
            
            transitionMatrix[rowIdx,colIdx] <- 
              transitionMatrix[rowIdx,colIdx] + commonTriTdm[m]
          }
        }
        
        save(file=transitionMatrixPath, transitionMatrix)
        
        rm(cur_chunk)
        rm(tdmTri)
        rm(commonTriTdm)
      }
    } else {
      break
    }
  }
  close(h_conn)
  
  return(transitionMatrix)
}



#-----------------------------------------------------------------
# Load transition matrix saved in each of the following files
# 1. en_US.blogs_TrainingData_TransitionMatrix.RData
# 2. en_US.twitter_TrainingData_TransitionMatrix.RData
# 3. en_US.news_TrainingData_TransitionMatrix.RData
#
# Args:
#   textFileDirectory: String that defines the directory that contains
#                      the above three files
#
# Returns:
#   matrixList: List that contains the transition matrices
#-----------------------------------------------------------------
loadTransitionMatrices = function(textFileDirectory) { 
  matrixList = list()
  
  load(file.path(textFileDirectory,
                 "en_US.blogs_TrainingData_TransitionMatrix.RData"))
  matrixList[["blogs"]] = transitionMatrix
  
  load(file.path(textFileDirectory,
                 "en_US.twitter_TrainingData_TransitionMatrix.RData"))
  matrixList[["twitter"]] = transitionMatrix
  
  load(file.path(textFileDirectory,
                 "en_US.news_TrainingData_TransitionMatrix.RData"))
  matrixList[["news"]] = transitionMatrix
  
  return(matrixList)
}



#------------------------------------------------------------------------
# Initializes a data frame that describes:
# 1.) The distribution of vocabulary words
# 2.) The number of zero counts for each row a Markov chain transition 
#     matrix
#
# Args:
#   vocabularyCounts: List that contains the vocabulary counts for
#                     the english language training data
#
# Returns:
#   vocabularyDistribution: Data frame that describes:
#                           1.) The distribution of vocabulary words
#                           2.) The number of zero counts for each row a 
#                               Markov chain transition matrix
#------------------------------------------------------------------------
initializeVocabularyDistribution = function(vocabularyCounts) {
 
  zeroCounts <- list()
  for (curType in names(vocabularyCounts)) {
    zeroCounts[[curType]] <- numeric(nrow(vocabularyCounts[[curType]]))
    
    for (n in seq_len(nrow(vocabularyCounts[[curType]]))) {
      zeroCounts[[curType]][n] <- 
        sum(vocabularyCounts[[curType]][n,] == 0)
    }
    zeroCounts[[curType]] <- zeroCounts[[curType]] / 
      nrow(vocabularyCounts[[curType]])
  }
  
  
  blogs <- data.frame(counts=rowSums(vocabularyCounts[["blogs"]]),
                      zerocounts=zeroCounts[["blogs"]])
  blogs$type <- "blogs"
  blogs$vocabularyindex <- seq(1,nrow(blogs))
  rownames(blogs) <- NULL
  
  twitter <- data.frame(counts=rowSums(vocabularyCounts[["twitter"]]),
                        zerocounts=zeroCounts[["twitter"]])
  twitter$type <- "twitter"
  twitter$vocabularyindex <- seq(1,nrow(twitter))
  rownames(twitter) <- NULL
  
  news <- data.frame(counts=rowSums(vocabularyCounts[["news"]]),
                     zerocounts=zeroCounts[["news"]])
  news$type <- "news"
  news$vocabularyindex <- seq(1,nrow(news))
  rownames(news) <- NULL
  
  vocabularyDistribution <- rbind(rbind(blogs, twitter), news)
  
  vocabularyDistribution$counts <- 
    vocabularyDistribution$counts / ncol(vocabularyCounts[["blogs"]])
  
  return(vocabularyDistribution)
}




#------------------------------------------------------------------------
# Constructs an average normalized transition matrix based on the
# vocabulary counts for the enligsh language training data
#
# Args:
#   vocabularyCounts: List that contains the vocabulary counts for
#                     the english language training data
#
# Returns:
#   averageTranstionMatrix: List that contains the following data:
#       - transitionData: An average normalized transition matrix based on 
#                         the vocabulary counts for the enligsh language 
#                         training data
#
#       - zeroCount: Number of columns in each transition matrix row where
#                    the frequency of occurence in the training data was 
#                     zero
#------------------------------------------------------------------------
constructAverageTransitionMatrix <- function(vocabularyCounts) {

  transitionMatrix <- (vocabularyCounts[["blogs"]] + 
                         vocabularyCounts[["twitter"]] + 
                         vocabularyCounts[["news"]]) / 3.0
  
  
  zeroCount <- vector('numeric',ncol(transitionMatrix))
  for (n in seq_len(length(zeroCount))) {
    zeroColIdx <- which(transitionMatrix[n,] == 0)
    zeroCount[n] <- length(zeroColIdx)
    
    if (zeroCount[n] != ncol(transitionMatrix)) {
      transitionMatrix[n,] <- 
        transitionMatrix[n,] / sum(transitionMatrix[n,])
      
      if (zeroCount[n] > 0) {
        nonZeroColIdx <- which(transitionMatrix[n,] > 0)
        
        minProbability = (1 - length(nonZeroColIdx) / 
                            ncol(transitionMatrix))/zeroCount[n]
        
        nonZeroColIdx <- which(transitionMatrix[n,] > minProbability)
        
        probabilityAdjustment <- 
          (minProbability*zeroCount[n])/length(nonZeroColIdx)
        
        transitionMatrix[n,nonZeroColIdx] <- 
          transitionMatrix[n,nonZeroColIdx] - probabilityAdjustment
        
        transitionMatrix[n,zeroColIdx] <- minProbability
      }    
    }
    else {
      transitionMatrix[n,] <- 1.0/ncol(transitionMatrix)
    }    
  }
  
  averageTranstionMatrix <- list()
  averageTranstionMatrix[["zeroCount"]] <- zeroCount
  averageTranstionMatrix[["transitionMatrix"]] <- transitionMatrix
  
  return(averageTranstionMatrix)
}



#--------------------------------------------------------------------------
# Applies the following transformations to a text input:
# 1.) Remove non-ASCII characters
# 2.) Remove punctuation
# 3.) Remove numbers
# 4.) Remove whitespace
# 5.) Remove profane words contained in a "blacklist"
# 6.) Splits the text input into a words
# 7.) Removes blank words
#
# Args:
#   textInput: String that stores a text input
#
#   blackList: Character vector that contains profane words to remove
#
# Returns:
#   predictorInput: Character vector that contains pre-processed text 
#                   phrase words
#--------------------------------------------------------------------------
preprocessTextInput = function(textInput, blackList) {
  textInputCorpus = Corpus(VectorSource(textInput))
  
  textInputCorpus = tm_map(textInputCorpus,
                            removeNonASCII,
                            mc.cores=1)
  
  textInputCorpus = tm_map(textInputCorpus,
                            customRemovePunctuation,
                            mc.cores=1)
  
  textInputCorpus = tm_map(textInputCorpus,
                            removeNumbers,
                            mc.cores=1)
  
  textInputCorpus = tm_map(textInputCorpus,
                            stripWhitespace,
                            mc.cores=1)
  
  textInputCorpus = tm_map(textInputCorpus,
                            removeWords,
                            blackList,
                            mc.cores=1)
  
  predictorInput =    unlist(str_split(as.character(textInputCorpus[[1]])," "))
  
  predictorInput = predictorInput[predictorInput != ""]
  
  return(predictorInput)
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










predictNextWord <- function(curPhrase,
                            numberOfTerms,
                            textPredictor) {
  #--------------------------------------------------------------------------
  # Predicts the next word of an n-gram using a Markov chain
  #
  # Args:
  #   curPhrase: String that stores an n-gram
  #
  #   numberOfTerms: Number of terms to predict
  #
  #   textPredictor: Markovchain class object
  #
  # Returns:
  #   textPrediction: List that contains prediction(s) of the next term
  #
  #   Keyword:        Description:
  #   -------         -----------
  #   stateHistory    Character vector that stores the markov chain state
  #                   history
  #
  #   textPrediction  Numeric vector that stores the conditional probability
  #                   for the predicted next term(s)
  #--------------------------------------------------------------------------
  textPrediction <- list()
  textPrediction$stateHistory <- character()
  
  numberWords <- length(curPhrase)
  curState <- curPhrase[1]
  vocabulary <- states(textPredictor)
  
  if (!curState %in% vocabulary) {
    randomIdx <- floor(length(vocabulary) * runif(1)) + 1
    curState <- vocabulary[randomIdx]
  }
  
  textPrediction$stateHistory <- 
    append(textPrediction$stateHistory, curState)
  
  for (n in seq(2,numberWords)) {
    nextState <- curPhrase[n]
    if (!nextState %in% vocabulary) {
      curConditionalProbability <- 
        conditionalDistribution(textPredictor, curState)
      
      nextState <- names(which.max(curConditionalProbability))
      
      if (length(nextState) > 1) {
        randomIdx <- floor(length(nextState) * runif(1)) + 1
        nextState <- nextState[randomIdx]
      }
    }
    curState <- nextState
    
    textPrediction$stateHistory <- 
      append(textPrediction$stateHistory, curState)
  }
  
  textPrediction$conditionalProbability <- 
    sort(conditionalDistribution(textPredictor, curState),
         decreasing=TRUE)[1:numberOfTerms]
  
  return(textPrediction)
}