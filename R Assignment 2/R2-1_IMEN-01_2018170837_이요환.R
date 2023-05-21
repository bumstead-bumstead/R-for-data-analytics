# Q1: Baseball game (while & repeat-break loop)
# Guess 3 digits and compared it with the answer
# If the same digit appears in the same position, it is called strike
# If the same digit appears in different positions, it is called ball
# Examples
# Answer (1,2,3)
# Guess  (1,5,6)
#         1 strike (1)
# Answer (4,5,6)
# Guess  (6,5,8)
#         1 strike (5) and 1 ball (6)
# Answer (6,3,2)
# Guess  (2,6,3)
#         0 strike and 3 balls (2,3,6)
# Answer (1,2,3)
# Guess  (4,5,6)
#         0 strike and 0 balls
# A user have 10 chances to guess the correct answer (3 strikes)

# Initialize the number of trials and strikes
trial <- 0
nstrikes <- 0
guess <- c()

# [Q1-1] Assign 3-digit answer that is randomly sampled integer between 1 and 9
# Each digit must appear only once
# Ex: (1,4,5) -> Acceptable
# Ex: (3,5,3) -> Not acceptable
answer <- sample(x = 1:9,size=3, replace=F)

#sample 함수를 이용해서 같은 숫자가 나오지 않고(replace=F) 원소가 세 개(size=3)인 1에서 9 사이의 무작위 숫자 벡터를 생성했다.

# [Q1-2] Provide the following condition inside while( )
# Condition 1: the number of trials is smaller than 10
# Condition 2: the number of strikes is smaller than 3
# The main body runs only when the both conditions are satisfied

while(trial<10 & nstrikes < 3){
  
#총 시도가 10번이 되거나, strike 개수가 3개가 되면 while문이 종료되도록 and의 의미를 갖는 &를 이용했다.
  
  # Increase the number of trials
  trial = trial + 1
  
  # Game announcement
  cat("3-digit baseball game:", trial, "-th trial. \n")
  cat("You are requested to enter three numbers, each of which must be between 1 and 9. \n")
  
  # [Q1-3] Write your own script based on the following instruction
  # Purpose: take the first digit from the user
  # Hint 1: Use the readline( ) to receive the input from the user
  # Hint 2: User input is considered as character type so the conversion to integer is necessary
  # Hint 3: User must provide an integer between 1 and 9
  repeat{
    guess[1] <- as.numeric(readline('choose first number.'))
    if(guess[1] == 1 | guess[1] ==2 | guess[1] == 3 | guess[1] == 4 | guess[1] == 5 | guess[1] == 6 | guess[1] == 7 | guess[1] == 8| guess[1] == 9) break
    cat("You entered an invalid number. Please enter the number between 1 and 9. \n")
      
  }

  
  #realine으로 입력받은 값을 숫자열로 바꾼 후 guess[1]에 집어넣는다.
  #if문과 or의 의미인 |를 이용해 1~9 사이의 정수값이 아니면 다시 입력하도록 했다.
  
  # [Q1-4] Write your own script based on the following instruction
  # Purpose: Take the second digit from the user  
  # Hint 1: Use the readline( ) to receive the input from the user
  # Hint 2: User input is considered as character type so the conversion to integer is necessary
  # Hint 3: User must provide an integer between 1 and 9
  repeat{
    guess[2] <- as.numeric(readline('choose second number.'))
    if (guess[2] == 1 | guess[2] ==2 | guess[2] == 3 | guess[2] == 4 | guess[2] == 5 | guess[2] == 6 | guess[2] == 7 | guess[2] == 8| guess[2] == 9) break
    cat("You entered an invalid number. Please enter the number between 1 and 9. \n")
  }
  
  # [Q1-5] Write your own script based on the following instruction
  # Purpose: Take the second??? digit from the user  
  # Hint 1: Use the readline( ) to receive the input from the user
  # Hint 2: User input is considered as character type so the conversion to integer is necessary
  # Hint 3: User must provide an integer between 1 and 9
  repeat{
    guess[3] <- as.numeric(readline('choose third number.'))
    if (guess[3] == 1 | guess[3] ==2 | guess[3] == 3 | guess[3] == 4 | guess[3] == 5 | guess[3] == 6 | guess[3] == 7 | guess[3] == 8| guess[3] == 9) break
    cat("You entered an invalid number. Please enter the number between 1 and 9. \n")
  }
  
  # [Q1-6] Check the number of strikes
  nstrikes <- length(which(guess == answer))
  
  #guess와 answer 벡터에서 원소가 같은 index를 반환해주는 which 함수를 사용하고, length 함수로 그 개수를 확인했다.
  
  # [Q1-7] Check the number of balls
  nballs <- 6 - length(unique(c(answer, guess))) - nstrikes
  
  #answer과 guess를 합친 벡터에서 unique함수로 겹치는 원소를 모두 제거해 6에서 빼면 위치와 상관없이 겹치는 모든 숫자의 수를 계산할 수 있다.
  #이 중에서 strike의 개수를 제외하면 ball의 개수가 된다.
  
  # Show the result
  cat("Your guess is:", guess, "\n")
  
  # [Q1-8] Print the result
  if (nstrikes >= 3){
    cat("3 strikes! You completed the game with", trial, "trials! \n")
  } else if (nstrikes >= 1 | nballs >= 1) {
    cat(nstrikes, "strikes and", nballs, "balls. \n")
    cat("Please try it again! \n")
  } else{
    cat("Failed! You used all your chances. \n")
  }
}
