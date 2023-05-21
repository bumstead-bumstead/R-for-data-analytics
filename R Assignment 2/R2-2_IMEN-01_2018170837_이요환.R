# Q2: arXiv paper statistics (for loop with functions)
# [Q2-1] read the "Arxiv papers on Text Mining.csv" file
# Strings must not be converted to Factors
papers <- read.csv("Arxiv papers on Text Mining.csv", header = TRUE, stringsAsFactors = FALSE)
  
# [Q2-2] remove the first column of the papers
papers <- papers[2:6]
str(papers)

#데이터프레임의 인덱싱을 이용해 (papers[2:6]) 첫번 째 열을 삭제했다.

# [Q2-3] count the number of rows and columns of the dataframe "papers"
nPapers <- length(papers[,1])
nVars <- length(papers[1,])

#각각 데이터프레임의 행, 열을 하나씩 가져와 length함수로 원소의 개수를 얻었다.


# [Q2-4] Write your own function named stat_extractor
# Input: 1 by 5 dataframe (ex: each row of the dataframe "papers")
# Output 1: number of characters in the first element
# Output 2: number of names in the second element
# Output 3: number of words in the fourth element  
# (Note) assume that words are simply seprated by a single space (" ")

stat_extractor <- function(x){
  
  # number of characters in the paper title
  output1 <- nchar(x[,1])
  
  # number of authors of the paper
  output2 <- length(strsplit(x[,2], ', ')[[1]])
  
  #strsplit 함수를 이용하면 list형태로 반환되기 때문에 [[1]]로 벡터로 만들어준 후 length 함수를 적용시켰다.
  
  # number of words in the abstract
  output3 <- length(strsplit(x[,4],' ')[[1]])
  
  return(c(output1, output2, output3))
}

# Initialize the new data frame
stat_papers <- data.frame()

# [Q2-4] For each row of the dataframe "papers", 
# apply the stat_extractor( ) function
# Use the rbind( ) function to append the result to the stat_papers dataframe

for (i in 1:nPapers){
  stat_papers <- rbind(stat_papers, stat_extractor(papers[i,]))
}

# Assign the column name
colnames(stat_papers) <- c("nchar_title", "nauthors", "nwords_abs")

# [Q2-5] Use cbind( ) function to combine papers and stat_papers
papers <- cbind(papers, stat_papers)
papers

# [Q2-6] Convert the subject column to factor type
papers$subject <- as.factor(papers$subject)

#as.factor 함수로 factor type으로 바꿀 수 있다.

# Q[2-7] What is the subject area with the longest title length on average?
# How many charaters are there?
# Hint: user tapply() function
ave <- tapply(papers[,6], papers[,3], mean)
maxlen <- which.max(ave)
ave[opt]
  
#tapply 함수를 이용해 6열인 title의 길이를 3열인 subject area를 기준으로 mean함수를 적용시켰다. 
#이를 ave변수에 지정해 which.max 함수로 최대값을 구해 maxlen 변수에 지정했고, (index 값이 반환됨) ave에 indexing해 characters의 개수와 subject area를 출력했다.

# Q[2-8] What is the subject area with the fewest number of authors on average?
# How many authors are there?
# Hint: user tapply() function
aveau <- tapply(papers[,7], papers[,3], mean)
aveau
for (i in 1:length(aveau)) {
  if (aveau[i] == min(aveau)){
      print(aveau[i])
  }
}

#2-7번과 비슷하게 which.min 함수를 이용하려 했지만, 최소값이 중복되는 경우 가장 낮은 index만 반환했기 때문에 for문을 사용해 모두 출력할 수 있도록 했다. (김규민 학생의 도움을 받았습니다.)

# Q[2-9] What is the subject area with the most similar number of words in the abstract on average 
# with the average words in the abstract of all papers?
# How many words are there?
# Hint: user tapply() function
aveabs <- tapply(papers[,8], papers[,3], mean)
for (i in 1:length(aveabs)){
  if (abs(aveabs[i] - mean(papers[,8])) == min(abs(aveabs - mean(papers[,8])))) {
    print(aveabs[i])
  }
}

#(위 두 문제들과 비슷한 방법으로 해결했지만, 편차를 비교할 방법을 김규민 학생에게 도움을 받아 해결했습니다.)