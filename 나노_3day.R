# 데이터 분석가 _ james         \
#                                \
# 스크립트 실행(Run a script)    \
##  : Windows : 'Ctrl + Enter'   \
##  : MAC     : 'Command + Enter'\
#---------------------------------

# R 프로그래밍

### 조건문  ##완전중요

if (cond) {
  # cond가 참일 때 실행할 문장.       #여러 명령어 삽입 가능. 중괄호는 조건 바로 옆에 위치.
} else {
  # cond가 거짓일 때 실행할 문장
}                                     #cond 결과에 대한 참/거짓은 유일해야함. 조건문은 차원이 없는 vector형태의 조건을 준다. 


if ( TRUE ) {                        #조건문으로 'TRUE'삽입 시 전부 True로 출력.true문을 실행시켜보기 위한 샘플 정도로 생각하면 됨. false가 나오지 않으므로 Else 문은 실행될 일이 없음.
  print("TRUE")
  print("hello")
} else {
  print("FALSE")
  print("world")
}


if( 조건1 ) {
  # 표현식 1
} else if (조건2) {
  # 표현식 2
} else {
  # 표현식 3
}

team_A <- 2 # Number of goals scored by Team A
team_B <- 2# Number of goals scored by Team B
if (team_A > team_B){
  print ("Team A won")
} else if (team_A < team_B){
  print ("Team B won")
} else {
  "Team A & B tied"
}


## 하나의 논리값에 대한 판단

x1 <- c(4)
if (x1 %% 2 == 0) {
  y1 = c("Even Number")
  print(y1)
} else {
  y1 = c("Odd Number")
  print(y1)
}

## 두개 이상의 논리값에 대한 판단
# 엑셀if와 똑같음
ifelse(조건,참,거짓)

x <- c(1, 2, 3, 4, 5)
ifelse(x %% 2 == 0, "even", "odd")

x <- c(1,2,3,4)
y <- c(2,1,4,5)
ifelse(x<y, x, y)

#elseif와 같은 효과주기 : 거짓 명령문에 ifelse로 다른 조건을 또 제시해줌
ifelse(sum(x-y) > 0, "positive", ifelse(sum(x-y) < 0 , "negative", "zero"))


############ 연습해보자 if, ifelse

# 문제 1
# a의 평균이 15이상이면 "평균이상" 아니면 "평균미만"으로 출력하시오

a <- seq(1,30,4)

##방법 1
ifelse((sum(a)/length(a))>=15,"평균이상","평균미만")
##방법 2
ifelse(mean(a)>=15,"평균이상","평균미만")  
##방법 3
if(mean(a) >= 15){
  print("평균이상")
}else{
  print("평균미만")
}


# 문제 2
# if , else if , else를 사용해서 tmep 조건을 만드시오
# 0이하면 freezing, 10이하면 cold, 20이하면 cool, 30이하면 warm, 그외는 hot이 출력되게 하시오

temp <- 25

if(temp<=0){
  "freezing"
}else if(temp<=10){       #위 조건문에서 0 이하를 검증했기 때문에, 범위를 재지정하지 않아도 된다.
  "cold"
}else if(temp<=20){
  "cool"
}else if(temp<=30){
  "warm"
}else{
  "hot"
}

# 문제 2_1
temp <-c(5,20,-6,37,24,13)
# 문제 2번의 값을 ifelse 로 바꿔서 값을 변경하시오

ifelse(temp<=0, "freezing",
       ifelse(temp<=10, "cold",
              ifelse(temp<=20,  "cool",
                     ifelse(temp<=30, "warm", "hot"))))

# 문제 3
# - ifelse 를 사용해서 iris의 Sepal.Length가 6보타 크면 1 작으면 0인 변수 생성하시오
# - new라는 변수를 추가하고 new가 1인 Sepal.Width의 합을 구하시오
data(iris)  

iris$new <- ifelse(iris$Sepal.Length >6, 1,
                   ifelse(iris$Sepal.Length <6, 0, ""))

sum(iris[iris$new==1,"Sepal.Width"])
or
sum(subset(iris,new==1,"Sepal.Width"))

#####################################
#####################################

# 루프
# 루프는 작업을 반복하는 R의 방법으로 
# 시뮬레이션 프로그래밍에 유용한 도구입니다.

#expand.grid
# n개의 벡터에 있는 요소이 모든 조합을 작성
# ex) 두 주사위의 모든 조합

die <- 1:6
rolls <- expand.grid(die, die)
# 두개 이상의 백터와 함께 사용

# 모든 주사위의 합은?
rolls$value <- rolls$Var1 + rolls$Var2
head(rolls)
rolls$value

# 확률 N 개의 독립적 인 랜덤 사건의 모든 발생은 
# 각각 임의의 이벤트가 발생하는 확률의 곱과 같다 .
prob <- c("1" = 1/8, "2" = 1/8, "3" = 1/8, "4" = 1/8, "5" = 1/8, "6" = 3/8)
prob

rolls$prob1 <- prob[rolls$Var1]
rolls$prob2 <- prob[rolls$Var2]
rolls$prob <- rolls$prob1 * rolls$prob2
head(rolls)

# 주사위의 예상 기대값은?
sum(rolls$value * rolls$prob)
# 따라서 두 개의로드 된 주사위를 굴릴 때 예상되는 값은 8.25입니다.


############ 연습해보자 expand.grid
wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")
prob <- c("DD" = 0.03, "7" = 0.03, "BBB" = 0.06, 
          "BB" = 0.1, "B" = 0.25, "C" = 0.01, "0" = 0.52)

#1번 문제

# wheel 과 같이 총 7개의 경우의 수가 있다.
# 각 확률은 prob와 같고 총 3번의 시도를 했을 경우에 0.001보다 높은 경우의 수 개수는?
# (3번 추출하며 각각 독립이다)
# (DD, BBB, 7) 과 (DD , 7 , BBB)는 다른 경우의 수다

wheels <- expand.grid(wheel,wheel,wheel)
wheels$prob1 <- prob[wheels$Var1]
wheels$prob2 <- prob[wheels$Var2]
wheels$prob3 <- prob[wheels$Var3]
wheels$prob <- wheels$prob1*wheels$prob2*wheels$prob3

nrow(wheels[wheels$prob>0.001,])

     
#2번 문제
# 동전을 3번 던질 떄 확률은 0.3과 0.7이다
# 첫번째에 앞이나오고 그리고(&) 세번째에 뒤가 나올 확률을 구하시오

coin <- c("앞","뒤")
prob <- c("앞" = 0.3, "뒤" = 0.7)

coins <- expand.grid(coin, coin, coin)
coins$prob1 <- prob[coins$Var1]
coins$prob2 <- prob[coins$Var2]
coins$prob3 <- prob[coins$Var3]

coins$prob <-coins$prob1 * coins$prob2 * coins$prob3

##확률 추가 계산해바~~

sum(subset(coins,Var1=="앞"& Var3=="뒤","prob"))



#####################################
#####################################

# for 루프
# for루프는 R에게 "모든 값에 대해이 작업을 수행하십시오"
# 구조
for (value in that) {
  this
}

# 사례1
for (value in c("My", "first", "for", "loop")) {
  print("one run")
}
# for 루프는 print("one run")문자열 벡터의 각 요소에 대해 한 번씩 실행

# 사례2
for (value in c("My", "second", "for", "loop")) {
  print(value)
}
value

# 두개의 차이?

for (word in c("My", "second", "for", "loop")) {
  print(word)
}
for (string in c("My", "second", "for", "loop")) {
  print(string)
}
for (i in c("My", "second", "for", "loop")) {
  print(i)
}

# 출력없이 적재
for (value in c("My", "third", "for", "loop")) {
  value
}
value

# 루프의 출력을 저장하려면 실행시 자체 출력을 저장하도록 루프

chars <- rep(0,4)

words <- c("My", "fourth", "for", "loop")

for (i in 1:4) {
  chars[i] <- words[i] 
}
chars

#for문을 통한 계산
rolls$new <- NA
for (i in 1:nrow(rolls)) {
  symbols <- sum(rolls[i, 1], rolls[i, 2], rolls[i, 3])
  rolls$new[i] <- symbols
}

############ 연습해보자 for문
#1번 문제
sum <- 0
# for문을 사용해서 1부터 100까지의 누적합을 구하시오

for (i in 1:100){
  sum <- sum+i
  }
sum



#2번 문제
sum2 <- 0
sample(1:6,1)
# for문을 사용해서 위의 주사위 20번 던진 누적 합을 구하시오

for (i in 1:20){
   sum2 <- sum2 + sample(1:6,1)
}
sum2

#####################################
#####################################


# while 루프
# 구조
while (condition) {
  code
}

#예시
i <- 1            #while 함수에서는 항상  i 값을 선 지정 해주어야 한다. 
while (i < 6) {
  print(i)
  i = i+1
}

# 1~10까지 누적합 구하기 (cummlative sum by while) : while(condition) { expression }
z <- 0
i <- 1
while( i <= 10) {
  z = z + i
  cat("cummulative summation",z, "\n")         #cat: paste0처럼 모든 값들 붙혀 출력하는 함수
  i = i + 1
}

k <- 1
repeat {
  k <- k+3
  if (k > 5) break}                    #repeat문은 While문 조건보다 한단계 윗 값까지 출력되는 구조.


############ 연습해보자 for, while 문

#1번 문제 구구단 만들어보기
# 2단부터 9단까지 출력해보기

#ex)
# 2 4 6 8 10 12 14 16 18
# 3 6 9 12 ....
# .....
# 9 18 27 36 ....


#1_1 for문
#seq(값 , by = 차이, length.out = 길이)

for(i in 2:9){
  print(seq(i,by=i,length.out=9))
}

#1_2 while문
#while문
i<-2
  
while(i<=9){
  print(seq(i,by=i,length.out=9))
  i=i+1
}

#모든 구구단 식 출력하기

i=2
while(i<10){
str=''
k=1
  while(k<10){
    str=paste0(str,' ',i,'x',k,'=',i*k)
    k= k+1
  }
i=i+1
print(str)
}

#####################################
#####################################


###########################
###### 함수 만들기  #######
###########################


# 1. 함수 생성 및 실행하기
myfunction <- function(){
  print("Hi Hello")
}

myfunction()


# 2. 인수 값 전달 함수
make_sum <- function(x,y){
  x+y
}

make_sum(3,4)


# 3. 기본 값 지정하기           
pp <- function(x,y=6){           #y값을 입력하지 않으면 자동적으로 '6'을 입력하여 계산함.
  x^y
}

pp(2)
pp(4,2)


# 4. 함수에서 특정 값 반환 return

make_sum <- function(x,y){
  return(x+y)
}

make_sum(3,4)


dt <- function(x,y){
  add <- x+y
  mul <- x*y
  c(add = add, mul = mul)         #function에서는, 맨 마지막 명령문이 return 값으로 기본설정되어있다.
}

dt(3,5)


# 5. 인수의 개수가 가변적인 상황
my_function <- function(x,...){
  print(x)
  summary(...)
}
z<-1:20
zz <- my_function("hi",z)  #변수값을 저장할때는 결과값이 출력되지 않는다. hi가 출력되는 이유는 my function에서 hi를 출력하라고 명령했었기 떄문. 

summary(z)

############ 연습해보자 function

#1 
# 성적을 입력했을경우 40점 이하는 "C", 70점 이하는 "B" 
# 71점 이상은 "A"를 출력하는 function을 만드시오

grade <-function(x){
  ifelse(x<=40,"C",
         ifelse(x<=70,"B","A"))
}

grade(100)

###########################
###### 다양한 apply #######
###########################

# apply( )

# 배열 또는 행렬에 주어진 함수를 적용한 뒤 그 결과를 벡터, 배열 또는 리스트로 반환
# 배열 또는 행렬에 적용


apply(
  X,       # 배열 또는 행렬 #벡터는 못받음. 2차원 이상의 값만 취급
  MARGIN,  # 함수를 적용하는 방향. 1은 행 방향, 2는 열 방향
  # c(1, 2)는 행과 열 방향 모두를 의미
  FUN      # 적용할 함수
)

# sum이라는 함수 적용에 대해서 진행
sum(1:10)
d <- matrix(1:9, ncol=3)
d
apply(d, 1, sum)
apply(d, 2, sum)

head(iris)
apply(iris[, 1:4], 2, sum)

# 이와같이 행, 열의 합 평균은 빈번하게 사용되므로 알면 좋은 함수들
rowSums(
  x,            # 배열 또는 숫자를 저장한 데이터 프레임
  na.rm=FALSE,  # NA를 제외할지 여부
)
#반환 값은 행 방향에 저장된 값의 합이다.

rowSums(
  x,            # 배열 또는 숫자를 저장한 데이터 프레임
  na.rm=FALSE,  # NA를 제외할지 여부
)
#반환 값은 행 방향에 저장된 값의 평균이다.  <--이게 뭔소리?
rowSums(iris[, 1:4])
colSums(iris[, 1:4])



#####

# lapply( )
# 벡터, 리스트 또는 표현식에 함수를 적용하여 그 결과를 리스트로 반환
# lapply : 벡터, 리스트, 표현식, 데이터 프레임 등에 함수를 적용하고 그 결과를 리스트로 반환한다.

lapply(
  X,    # 벡터, 리스트, 표현식 또는 데이터 프레임   벡터를 받을 수 있기 때문에 for문과 가장 비슷. 
  FUN,  # 적용할 함수
  ...   # 추가 인자. 이 인자들은 FUN에 전달된다.
)
# 반환 값은 X와 같은 길이의 리스트다. 값에 대한 추가적인 분석을 위해서는 unlist 처리 필요 


# 반환 값은 함수 호출 결과다.
(result <- lapply(1:3, function(x) { x*2 }))
unlist(result)

# ㅣlist를 인자로 받을 수 있다.
(x <- list(a=1:3, b=4:6))
lapply(x, mean)

# data.frame를 인자로 받을 수 있다.           #열단위 apply 연산과 값이 동일
lapply(iris[, 1:4], mean)

########## 로 lapply( )의 결과를 벡터 또는 데이터 프레임으로 변환할 필요가 있다.

# unlist : 리스트 구조를 벡터로 변환한다.
unlist(
  x,                # R 객체. 보통 리스트 또는 벡터
  recursive=FALSE,  # x에 포함된 리스트 역시 재귀적으로 변환할지 여부
  use.names=TRUE    # 리스트 내 값의 이름을 보존할지 여부
)
# 반환 값은 벡터다.

# do.call : 함수를 리스트로 주어진 인자에 적용하여 결과를 반환한다.

do.call(
  what,  # 호출할 함수
  args,  # 함수에 전달할 인자의 리스트
)

# unlist로 백터 변환 후 데이터프레임 만들기
d <- as.data.frame(matrix(unlist(lapply(iris[, 1:4], mean)),ncol=4, byrow=TRUE))
names(d) <- names(iris[, 1:4])

# do.call을 활용한 데이터 프레임 만들기
data.frame(do.call(cbind, lapply(iris[, 1:4], mean)))


#### unlist의 문제점!
x <- list(data.frame(name="foo", value=1),data.frame(name="bar", value=2))
unlist(x)
do.call(rbind,x)  #열이름이 같은 것 끼리 행결합됨.



#############

sapply( )
# lapply와 유사하지만 결과를 벡터, 행렬 또는 배열로 반환

sapply(
  X,    # 벡터, 리스트, 표현식 또는 데이터 프레임
  FUN,  # 적용할 함수
  ...,  # 추가 인자. 이 인자들은 FUN에 전달된다.
)
# 반환 값은 FUN의 결과가 길이 1인 벡터들이면 벡터, 길이가 1보다 큰 벡터들이면 행렬이다.
lapply(iris[, 1:4], mean)
sapply(iris[, 1:4], mean)

class(sapply(iris[, 1:4], mean))

# 형태는 숫자인 백터!
sapply(iris[, 1:4], mean)

# sapply( )에서 반환한 벡터는 as.data.frame( )을 사용해 데이터 프레임으로 변환
x <- sapply(iris[, 1:4], mean)
as.data.frame(x)  #열기준 정렬됨  
as.data.frame(t(x))   #t(x):행/열 치환

# 변수 구조 확인할떄 많이 쓴다.
sapply(iris, class)
str(iris)

# sapply( )에 인자로 주어진 함수의 출력이 길이가 1보다 큰 벡터들이라면 sapply( )는 행렬을 반환
y <- sapply(iris[, 1:4], function(x) { x > 3 })


###########################


tapply( )
# 벡터에 있는 데이터를 특정 기준에 따라 그룹으로 묶은 뒤 각 그룹마다 주어진 함수를 적용하고 그 결과를 반환
tapply(
  X,      # 벡터
  INDEX,  # 데이터를 그룹으로 묶을 색인. 팩터를 지정해야 하며 팩터가 아닌 타입이 지정되면
  # 팩터로 형 변환된다.
  FUN,    # 각 그룹마다 적용할 함수
  ...,    # 추가 인자. 이 인자들은 FUN에 전달된다.
)
# 반환 값은 배열이다.

# 부터 10까지의 숫자가 있고 이들이 모두 한 그룹에 속해 있을 때, 이 그룹에 속한 데이터의 합
tapply(1:10, rep(1, 10), sum)

# 홀짝에 따라서
tapply(1:10, 1:10 %% 2 == 1, sum)  

tapply(iris$Sepal.Length, iris$Species, mean)


######

mapply( )
# sapply의 확장된 버전으로, 여러 개의 벡터 또는 리스트를 인자로 받아 함수에 각 데이터의 첫째 요소들을 적용한 결과, 
# 둘째 요소들을 적용한 결과, 셋째 요소들을 적용한 결과 등을 반환
# sapply( )와 유사하지만 다수의 인자를 함수에 넘긴다는 점에서 차이

mapply(
  FUN,  # 실행할 함수
  ...,  # 적용할 인자
)

rnorm(10, 0, 1)  #평균이 0, 분산이 1인 정규분포에서 샘플 10개 가져와

mapply(rnorm,
       c(1, 2, 3),
       c(0, 10, 100),
       c(1, 1, 1))   
# 1은 rnorm(n=1, mean=0, sd=1), 
# 2는 rnorm(n=2, mean=10, sd=1), 
# 3은 rnorm(n=3, mean=100, sd=1)에 해당한다.

mapply(mean, iris[, 1:4])
# mapply( )에는 iris의 모든 행이 나열되어 인자


############ 연습해보자 apply 종류

#문제 1
data(iris)
# iris에서 각 행바다(1~4열)의 분산 열을 추가하시오 (var)
data(iris)
iris$var <- apply(iris[1:4],1,var)

#문제 2
# function을 활용해서 iris[,1:4]의 모든 값들은 제곱하시오

apply(iris[,1:4],2,function(x){x^2})
sapply(iris[,1:4], function(x){x^2})

#문제 3
# iris에서 for문을 활용해서 숫자형(iris[,1:4]) 값을 Species별 평균을 구하시오
# z변수에 저장

tapply(iris[,1:4],iris$Species,mean) #x가 벡터가 아닌 행렬이어서 불가능

z<-c()
for(i in 1:4){
    a <- tapply(iris[,i],iris$Species,mean)
    z <- rbind(z,data.frame(t(a)))
}
z
