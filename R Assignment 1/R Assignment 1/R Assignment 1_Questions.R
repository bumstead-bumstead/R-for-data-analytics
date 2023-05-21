# Provide your own script for $$$ part
# Explain the code and discuss the result using the comment symbol "#"

# Part 1: Vector
# Answer the following questions based on the three vectors A, B, and C as follows"
A <- c(1,2,3,4,5)
B <- c("a", "b", "c")
C <- c(TRUE, FALSE, TRUE)

# Q1: Check the mode of each vector
mode(A)
mode(B)
mode(C)

#mode(x) 함수는 객체의 type을 반환해주는 함수이다.
#숫자로만 이루어져있는 vector인 A는 "numeric"을, 
#문자열로 이루어진 vector B는 "character"을,
#논리값으로 이루어진 vector C는 "logical"을 각각 반환했다.

# Q2: Add the vector A and B and explain what happens:
A + B

#+ 연산은 numeric인 A와 character인 B 사이에 쓸 수 없기 때문에 오류가 발생했다.

# Q3: Add the vector A and C and explain what happens:
A + C
###################################
#먼저 논리값인 TRUE, FALSE는 각각 1, 0으로 반환되고,
#R의 언어 특성상 elements 순서대로 연산이 진행된다.
#elements 수가 더 적으면 다시 처음부터 연산이 이루어지고, 이에 대한 warning message가 출력된다.
#

# Q4: Add the the last three elements of vector A and the entire vector C
# discuss the difference of the results of Q3 and Q4
A[3:5] + C

#Q3의 경우 A의 elements의 개수가 C의 elements의 개수와 달랐기 때문에 warning messege가 출력된 반면
#Q4는 elements의 수가 같으므로 순서대로 연산이 진행되었다.

# Q5: Generate a vector using seq() function
# Q5-1: starting from 2, ending with 20, increasing step by 2
seq(from=2,to=20,by=2)

#seq함수의 인자 from은 생성되는 벡터의 첫번 째 원소, to는 마지막 원소, by는 공차이다.

# Q5-2: discuss if you change it starting from 20, ending with 2 without changing by option
seq(from=20,to=2,by=2)

#20은 2보다 크기 때문에 by 인자값이 양수이면 오류가 발생한다.

# Q5-2: change the "by" option to generate the vector starting from 20, ending with 2, decreasing step by 2
# Hint: use help() function for seq() function and read the document carefully
seq(from=20, to=2, by=-2)

#seq 함수의 by에 입력받는 값은 increment of sequence이기 때문에 감소되려면 -2이어야한다.

# Q5-3: create the same vector with Q5-1 using "length" option instead of "by" option
seq(from=2, to=20, length=10)

#length option은 from과 to를 포함해 10개의 숫자를 같은 간격으로 출력시킨다.

# Q5-4: discuss what happens if you exchange the value of "from" option with "to" option 

#5-3에서 생성된 vector의 역순으로 만들어질 것이다.
seq(from=20, to=2, length=10)

# Q6: generate a vector using rep() function
# Q6-1: generate the following vector
# (10 10 10 20 20 20 30 30 30)
rep(c(10,20,30),each=3)

#인자값을 반복해주는 rep함수를 이용했고, each=3은 입력받은 벡터의 각각의 값을 세번씩 출력한다는 뜻이다.

# Q6-2: generate the following vector
# (10 10 10 20 20 20 30 30 30 10 10 10 20 20 20 30 30 30)
rep(rep(c(10,20,30),each=3),2)

#Q6-1의 결과값이 두 번 반복된 형태이기 때문에 rep함수를 다시 사용했다.


# Q7: Based on the given x and y vectors,
x <- 1:10
y <- 10:1
# Q7-1: the result of the following is 12. Explain why.
sum(x>=5) + sum(y>=5) + any(x>=10)*all(x<10)

#sum 함수는 x>=5, y>=5의 논리결과값의 합, 즉 각각 6을 반환하고, 논리 벡터에서 x>=10인 값이 존재하는 지 확인해 논리값을 반환하는 any함수는 1을 반환,
#논리 벡터에서 모든 원소가 x<10인 지를 확인해 논리값을 반환하는 all함수는 0을 반환해 결과는 6 + 6 + 0 = 12이다.

# Q7-2: the result of the following is 67. Explain why.
sum(which(x>=5)) + sum(which(y>=5)) + any(which(x>=10))
any(which(x>=10))
#which함수는 x>=5를 만족시키는 값의 index를 반환해 sum 되었고, (5+6+7+8+9+10) 같은 방식으로 두번 쨰 항에서는 (1+2+3+4+5+6)이 된다.
#세 번째 항의 any함수는 조건을 만족시키는 인자값이 존재하는 지 확인해 TRUE를 반환하였으므로 1. 결과는 45 + 21 + 1 = 67 이 된다.

# Part 2: List
# Q8: Based on the give list A,
A <- list(1:5,c(10,20,30,40,50))
# Q8-1: the following line returns an error message. Explain why
lapply(A,median) + c(100, 200)

#lapply는 함수(위에서는 median)를 적용해 list로 반환하는 함수이다. 즉 위의 식은 list와 vector을 더한 것이므로 오류가 발생했다.

# Q8-2: the following line returns a value. Explain why
sapply(A,median) + c(100, 200)

#sapply는 함수를 적용해 vector의 형태로 반환하는 함수이다. 따라서 elements의 수가 같은 두개의 vector의 합이므로 103 230이 반환되었다.

# Part 3: Matrix
# Q9-1: Create the 5 by 3 matrix (A) with the following elements using seq() function
# First row: 10, 20, 30
# Second row: 40, 50, 60
# Third row: 70, 80, 90
# Fourth row: 100, 110, 120
# Fifth row: 130, 140, 150
A <- matrix(seq(from = 10,to = 150,by = 10), nrow = 5,byrow = T)
A
#주어진 행렬의 원소가 10부터 150까지 10씩 row 방향으로 증가하는 규칙을 갖기 때문에 (byrow = T) seq함수로 벡터를 만들어 행렬을 생성시켰다. 
#또 원소의 개수가 15개 이므로 nrow = 5로 지정하면 column은 자동으로 3개로 지정된다.

# Q9-2: Add the second row of the matrix A and 3-5th rows of the last column of A
A[2,] + A[3:5,3]

#row와 column의 index를 순서대로 입력하는 행렬의 indexing을 이용해 행렬 덧셈을 계산할 수 있다.

# Q9-3: Explain the result of the following line
apply(A,2,mean) > apply(A[2:4,],1,mean)

#apply는 행렬에 특정 함수를 적용시키는 함수로써, 좌변은 행렬 A의 열에 대해 mean 함수가 적용되어 70, 80, 90이 반환되고, 우변은 A[2:4,] 행렬의 행에 대해 mean 함수가 적용되어 50, 80, 110이 반환된다.
#따라서 위 식의 결과는 TRUE FALSE FALSE가 된다.

# Create the following four matrices
matA <- matrix(1:4, nrow = 2, ncol = 2)
matB <- matrix(11:16, nrow = 2, ncol = 3)
matC <- matrix(21:29, nrow = 3, ncol = 3)
matD <- matrix(31:36, nrow = 3, ncol = 2)
# Q10: create the matrix named "matE" with following elements 
# by combinding the above four matrices in one line
#  1  3 11 13 15
#  2  4 12 14 16
# 21 24 27 31 34
# 22 25 28 32 35
# 23 26 29 33 36
matE = rbind(cbind(matA,matB),cbind(matC,matD))
matE
#column 방향으로 행렬을 합치는 cbind 함수로 matA, matB와 matC,matD를 각각 합치고 row 방향으로 행렬을 합치는 rbind 함수로 이 두 행렬을 합친다.

# Part 4: Dataframe & Strings
# Crate a dataframe named "dfA" with the following elements
# First column (name = Name): ("Kang", "Kim", "Cho", "Ng")
# Second column (name = Age): (30, 40, 25, 50)
# Third column (name = Address): 
# ("Anam-dong, Seoul", "Mansu-dong, Incheon", "Manri-dong, Busan", "Bongsun-dong, Gwangju")
Name <- c("kang", "kim", "Cho", "Ng")
Age <- c(30,40,25,50)
Address <- c("Anam-dong, Seoul", "Mansu-dong, Incheon", "Manri-dong, Busan", "Bongsun-dong, Gwangju")
dfA <- data.frame(Name, Age, Address,stringsAsFactors=FALSE)
dfA
# Answer the following questions based on the created dataframe
# Q11-1: Count the number of characters of each name
nchar(dfA[[1]])

#이름 항목인 dfA[[1]]을 불러와서 nchar 함수로 문자열의 글자수를 출력시켰다.

# Q11-2: Returen the name of the youngest person

dfA[which(dfA[[2]]==min(dfA[[2]])),1]

#나이항목인 dfA[[2]]와 가장 작은 값을 반환해주는 min함수로 제일 낮은 나이를 찾고, which함수로 그 index를 반환시킨 후, 다시 dfA에서 이름을 반환시켰다.


# Q11-3: Return the city names (address after the comma) only
# Hint: search an example of returning the second element in each list item
# Causion!: spaces must be removed 
q113 <- strsplit(dfA[[3]], " ")
unlist(q113)[c(2,4,6,8)]

#먼저 Address 항목인 dfa[[3]]을 띄어쓰기를 기준으로 strsplit한후, 이를 unlist함수로 벡터의 형태로 바꾼 뒤 짝수 항을 모두 불러왔다.
#검색을 통해 문제를 해결하는 예시를 찾아 sapply(q113, '[')[2, ]라는 방법으로도 해결할 수 있다는 것을 알았지만, sapply의 함수 자리에 입력된 '['의 사용법을 찾지 못해서 사용하지 않았다.
#sapply(q113, '[')
 
  
# Answer the following questions
# Q12-1: Read the provided file "2018_2_Scores_Students.csv" uisng the full path
score <- read.csv("2018_2_Scores_Students.csv", header = TRUE)

#read.csv함수로 같은 경로에 있는 엑셀파일을 바로 불러왔다.
#1행의 원소를 제목으로 지정해주기 위해 header = TRUE로 지정했다.

# The score of unsubmitted assignment is recorded as NA
# Q12-2: How many students did not submit their results for each assignment?
for (i in 2:6) {
  print(35-length(which(score[[i]]>=0)))
}

#which 함수로 각각의 과제에서(for 문을 이용해서) 점수가 0보다 큰 (NA가 아닌) 모든 index의 개수를 전체 인원인 35에서 빼서 제출한 인원을 출력하게 했다.

# Q12-3: Compute the mean of each assignment
for (i in 2:6) {
  print(mean(score[[i]], na.rm = TRUE))
}

#Q12-2와 마찬가지로 각각의 값에 대해 반환하기 위해 for문을 사용했고 각각의 과제에 mean함수로 평균을 계산했다.
#또 NA가 포함되어 있을 때 mean의 결과값이 출력되지 않기 때문에 na.rm = TRUE로 NA를 모두 삭제시켰다.

# Q12-4: Count the number of students who received the total score greater than 45
length(which(apply(score[ ,2:6], 1, sum, na.rm = TRUE)>45))

#sum함수는 데이터프레임을 받았을 때 모든 인자를 더해버리고, sapply, lapply함수는 각각의 열에 대해서 적용되기 때문에 이를 조절할 수 있는 apply 함수를 사용했다.
#데이터프레임의 열에 sum함수를 적용시킨 값 중에 45가 넘는 index를 구하고(which), length함수로 그 개수를 반환시켰다.
