# 데이터 분석가 _ james         \
#                                \
# 스크립트 실행(Run a script)    \
##  : Windows : 'Ctrl + Enter'   \
##  : MAC     : 'Command + Enter'\
#---------------------------------

#######################################
##### 복습하기 #####
#######################################

##### 1일차 복습


# matrix
mat <- matrix(c(1,2,3,4,5,6,7,8,9), ncol=3, byrow=T) #행 기준 3열의 행렬 생성
mat[1,]                                       #행렬 mat의 1행의 값
mat[,3]                                       #행렬 mat의 3열의 값

# data.frame
a<-1:10
b<-rep("a",10)
c<-data.frame(a,b)
c
# list
list1 <- list("A", 1:8)                         #list1 리스트 생성
list1[[3]] <- list(c(T, F))                      #세 번째 성분을 추가
list1[[2]][9] <- 9                             #두 번째 성분에 원소 추가
list1[3] <- NULL                             #세 번째 성분 삭제
list1[[2]] <- list1[[2]][-9]                   #두 번째 성분의 9번째 원소 삭제
list1                                            #변경사항은 꼭 변수할당 해야 저장됨.
rm(list=ls())


# 연습해보기!

# 1. a에 1부터 10까지 홀수를 3번씩 출력하고 다음과 같은 matrix 저장하시오
#     [,1] [,2] [,3] [,4] [,5]
#[1,]   1    3    5    7    9
#[2,]   1    3    5    7    9
#[3,]   1    3    5    7    9

a<-matrix(rep(seq(1,9,2),3),byrow=T,nrow=3)


# 2. b와 c로 데이터 프레임을 d에 저장하시오
b <- c(1,2,3)
c <- c("a","b","c")

d <- data.frame(b,c)

# 3. a와 d로 리스트를 e에 저장하고 2번째층에 저장된 데이터프레임 2행 2열을 출력하시오
e <- list(a,d)
e[[2]][2,2]

#######################################
##### 2-1 데이터 호출하기 #####
#######################################

### 데이터 저장하기 및 호출 하기

# --- read.csv( )를 활용한 csv파일 불러오기 ----

# 작업 폴더 확인하기 
getwd()

# 작업폴더 설정(Set Working Directory) : 'Ctrl+ Shift + h'
## RStudio Menu ; Session -> Set Working Directory -> Choose...

# 작업 폴더 지정하기
setwd()
## setwd('Your Working Directory Address')


# 데이터 불러오기
read.csv('test.csv')
## 작업 폴더에 있는 test.csv 불러와서 출력하기 


# 인코딩 지정
read.csv('pop_seoul_euckr.csv', fileEncoding='euc-kr')


## Windows 인코딩 : CP949/euc-kr (한글깨질 때 인코딩)
## mac/Linux 인코딩 : UTF-8

## 같은 운영체제에서는 생략 가능 



# '<-'을 활용해서 저장하기 
pop_seoul <- read.csv('pop_seoul_euckr.csv')
## 오른쪽 위 환경창에서 데이터 이름 클릭 


View(pop_seoul)
## 혹은 직접 View( )에 데이터를 넣고 실행



# 데이터 샘플 살펴보기
head(pop_seoul)
tail(pop_seoul, n=10)
## 첫 6개, 끝 10개 관측치만 콘솔창에서 보기


# 데이터 특성 확인하기 
str(pop_seoul)
## 데이터의 구조(Structure) 살펴보기
## 변수 형식 (뒤에 설명)


# 데이터 요약
summary(pop_seoul)




##1.1 read.table( )로 txt파일 불러오기
## 탭으로 구분된 데이터
temp = read.table('pop_seoul.txt',  
                  header=TRUE,
                  fileEncoding='UTF-8')
temp


write.csv(pop_seoul, file='aaa.csv', row.names = F)
## write.csv(저장할객체, file='경로/이름')  



#openxlsx 패키지를 활용한 엑셀파일 불러오기 
# openxlsx 패키지 설치

install.packages('openxlsx')


# library( )로 패키지 불러오기
library(openxlsx)
## 필요할 때마다 불러오기 / 항상 맨위에 놓고 호출하며 사용할 것.
## 원래는 없었던 read.xlsx( ) 함수 사용가능 


# 데이터 불러오기
SHEET1 = read.xlsx('test.xlsx', sheet=1)
## xlsx 파일 경로와 시트 번호를 지정 / 시트번호 지정안하면 1이 default
SHEET1


SHEET2 = read.xlsx('test.xlsx', sheet=2, startRow=3)
## startRow= 옵션으로 데이터 시작 행번호 지정 가능
SHEET2


SHEET3 = read.xlsx('test.xlsx', sheet=3, colNames=FALSE)
## 첫 행이 변수이름이 아니라 관측치일때, colNames=FALSE 옵션 사용
SHEET3


#
## Rdata로 저장하기
# RDS 파일 (R객체 저장)
new_data <- readRDS("iris.RDS")

# RDS 파일로 저장
saveRDS(new_data, file = "new_iris.RDS")


# image 파일
load("iris.RData")
iris4 <- iris

# image 저장
save.image("iris_image.RData")
#load는 변수할당 x 

######################### 1번 연습문제 #############################


##6 (실습) 다양한 데이터 불러오기
# 통계청 인구 데이터 
## 출처 : http://kosis.kr/statisticsList/statisticsListIndex.do?menuId=M_01_01&vwcd=MT_ZTITLE&parmTabId=M_01_01#SelectStatsBoxDiv

## 파일위치 :'data/'
## 파일이름 : '광역시도별_연령성별_인구수.xlsx'
## 데이터 시작 위치 : 2행

data1=read.xlsx('광역시도별_연령성별_인구수.xlsx',startRow=2)

# 통계청 가구별 주택 거주 데이터
## 출처 : http://kosis.kr/statHtml/statHtml.do?orgId=101&tblId=DT_1JU1501&vw_cd=&list_id=&seqNo=&lang_mode=ko&language=kor&obj_var_id=&itm_id=&conn_path=I2

## 파일위치 :'data/'
## 파일이름 : '시도별_가구_주택종류.xlsx'
## 데이터 시작 위치 : 2행

data2=read.xlsx('시도별_가구_주택종류.xlsx',startRow=2)

# 국토교통부 아파트 실거래가 데이터(2018, 강남구)
## 출처 : http://rtdown.molit.go.kr/

## 파일위치 :'data/'
## 파일이름 : '아파트매매_2019_강남구.xlsx'
# 데이터 시작 위치 : 17행

data3=read.xlsx('아파트매매_2019_강남구.xlsx',startRow=17)

#######################################
##### 2-2 R 연산하기 #####
#######################################


#### week 사칙연산 ####
# 
# ▶ R에서 제공하는 연산에 대하여 알아본다.

a<-c(1,2)
b<-c(3,4)
a+b #벡터 변수의 덧셈
a-b #벡터 변수의 뺄셈
a*b #벡터 변수의 곱셈
a/b #벡터 변수의 나눗셈

a<-c(4,5)
b<-c(2,3)
a^b #벡터변수의 제곱(구성 요소들간의 제곱, 4^2, 5^3)

rm(list = ls()) #오브젝트 내의 모든 변수 삭제


#%/% : 나눗셈에서 몫만 출력함
#%% : 나눗셈에서 몫만 출력함

a<-c(7,2)
b<-c(3,4)
a%/%b #벡터 변수의 정수나눗셈
a%%b #벡터 변수의 나머지

#행렬의 곱
A<-matrix(c(5,10,2,1), ncol=2)
B<-matrix(c(3,4,5,6), ncol=2)
#(5*3) + (2*4) ; (5*5) + (2*6) ; (10*3) + (1*4) ; (10*5) + (1*6)
A;B
A%*%B

rm(list = ls()) #오브젝트 내의 모든 변수 삭제


#### 비교연산 ####
# 
# ▶ R에서 제공하는 연산에 대하여 알아본다.


# '==' 비교되는 두 항이 같은지를 비교함. 같을 경우 True, 다를 경우 False
x<-2
y<-3
x==y

# '!=' 비교되는 두 항이 다른지를 비교함. 같을 경우 False, 다를 경우 True
x<-2
y<-3
x!=y

# '<=' 왼쪽 항이 오른쪽 항보다 작거나 같음을 비교함. 작거나 같으면 True, 크면 False
x<-2
y<-2
x<=y

# '<' 왼쪽 항이 오른쪽 항보다 작음을 비교함. 작으면 True, 크면 False
1<2

# '>' 왼쪽 항이 오른쪽 항보다 큼을 비교함. 크면 True, 작으면 False
1>2

# '>=' 왼쪽 항이 오른쪽 항보다 크거나 같음을 비교함. 크거나 같으면 True, 작으면 False
1>=2


rm(list = ls()) #오브젝트 내의 모든 변수 삭제


#### 논리연산 ####
# 
# ▶ R에서 제공하는 연산에 대하여 알아본다.

# ! : not 연산자

# & : 벡터에서의 and 논리 연산자
2==2 & c( 3>4)
2==2 & c( 3<4)
# | : 벡터에서의 or 논리 연산자
2==2 | c( 3>4)
2!=2 | c( 3>4)



rm(list = ls()) #오브젝트 내의 모든 변수 삭제


#### week. 4.3  열 추가 ####
# ▶ 이번 절에서는 데이터의 열 추가에 대하여 알아본다.

tmp_df <- data.frame(AA = c(1:5), BB = c("A","A","B","B","B"))

head(tmp_df) # 데이터 확인 
#CC컬럼을 새로 생성하고 그 안에 값을 1로 채워 넣음 
tmp_df$CC <- 1  #1개 숫자만 넣으면 모든 행이 같은 값으로 채워지고, 1보다 큰 숫자를 넣을 경우에는 모든 행의 값을 넣어주어야 한다. 

#컬럼 AA와 컬럼 CC의 값의 합한 값을 새로운 DD컬럼으로 생성
tmp_df$DD <- tmp_df$AA + tmp_df$CC
head(tmp_df) # 데이터 확인 


#### 열 제거 ####

# ▶ 열을 제거 하기 위해서는 열의 위치 번호에 (-)를 입력하여 제거 한다. 

tmp_df[, -1] #첫번째 위치의 컬럼 제거

tmp_df[, -"AA"]  #오류 발생함. '열 이름'을 사용해 불러올 수는 있지만, 열 제거는 불가능. 
# 다음에 오류가 있습니다-"AA" : 단항연산자에 유효한 인자가 아닙니다

tmp_df[, c("BB","CC","DD")]

rm(list = ls()) #오브젝트 내의 모든 변수 삭제


#######################################
##### 2-3 데이터형태 조정하기 #####
#######################################


#### 데이터 추출(Select) ####

# 데이터 추출(Select)
# ▶ 이번 절에서는 데이터 추출하기에 대하여 알아본다. 

Sample.df <- data.frame(AA = rep(letters[1:5],10), BB = sample(60:70, 50, replace = T))
# sample (추출범위, 추출 갯수, replace = 중복가능)
sample(1:6,10,replace = T) # 1부터 6을 10번 랜덤추출
#만약 랜덤을 고정하고 싶다면 set.seed(숫자)
set.seed(1234)
sample(1:6,10,replace=T)
set.seed(1234)
sample(1:6,10,replace=T)


head(Sample.df)
#AA컬럼의 값중에서 a인 값만 추출
#Type1
Sample.df[Sample.df$AA == "a",] 
#Type2
# subset(데이터, 조건)
subset(Sample.df, AA == "a") 

#AA컬럼의 값중에서 a 와 b의 값만 추출 ##열 내용에서 조건을 걸 때는, 조건문을 행으로 위치시킨다. 
#Type1
Sample.df[Sample.df$AA %in% c("a","b"),] 
##%in%:범위지정. 다음과 같이 같은것 반복 불필요-Sample.df[Sample.df$AA=="a"|Sample.df$AA=="b",]  #중요!!
#Type2
subset(Sample.df, AA %in% c("a","b"))

Sample.df$AA == "a"

# 필요한 컬럼 Select
Sample.df1 <- Sample.df
#Type1
Sample.df1[,c("AA","BB")]
#Type2
Sample.df1[,c(1,2)]
#Type3
Sample.df1[,c(-4,-5)]


rm(list = ls()) #오브젝트 내의 모든 변수 삭제


######################## 2번 연습문제 ##########################
data(iris)
head(iris)

# 1. Sepal.Length 변수의 짝수행을 출력하시오 .
iris[seq(2,150,by=2),"Sepal.Length"]
iris$Sepal.Length[seq(2,150,2)]

# 2. Subset을 사용해서 변수 Species 에서 setosa 인 데이터를 추출하시오
subset(iris,Species=="setosa")

# 3. 2번에서 뽑은 데이터를 a1에 저장하고 Sepal.Length 가 5 보다 작은 Petal.Width 의 합을 구하시오
a1<-subset(iris,Species=="setosa")
a1$Sepal.Length<5
#방법1
sum(a1[a1$Sepal.Length<5,"Petal.Width"])
#방법2
sum(subset(a1,Sepal.Length<5,"Petal.Width"))

#############################################################


#######################################
##### 2-4 데이터 합치기 #####
#######################################


#### 데이터 합치기 ####

# ▶ 데이터를 합치기 위해서 사용되는 함수는 cbind, rbind, merge 가 가장 많이 사용되어진다.

# 예제 데이터 불러오기
## 국토교통부 아파트 실거래가 데이터
## 출처 : http://rtdown.molit.go.kr/

library(openxlsx)
GN = read.xlsx('아파트매매_2018_강남구.xlsx', sheet=1, startRow=17)
head(GN)
tail(GN)

GD = read.xlsx('아파트매매_2018_강동구.xlsx', sheet=1, startRow=17)
head(GD)

SC = read.xlsx('아파트매매_2018_서초구.xlsx', sheet=1, startRow=17)
SP = read.xlsx('아파트매매_2018_송파구.xlsx', sheet=1, startRow=17)


# 데이터 구성 확인
names(GN)
names(GD)

str(GN)
str(GD)

# rbind( )를 활용한 행/관측치 결합
GN4 = rbind(GN, GD, SC, SP)
head(GN4)
tail(GN4)


##2 열 결합

# 가상의 예제 데이터 확인
my_data = data.frame(id = 1:5,
                     gender = c('M','F','F','F','M'),
                     age = seq(15, 35, 5))

my_data


# 추가 변수를 포함한 데이터
another_data = data.frame(region = c('Seoul','Seoul','Seoul','Busan','Busan'),
                          amount = c(1,1,1,1,1))

another_data


# cbind( )로 열/변수 결합
cbind(my_data, another_data)

## 일반적으로 잘 활용하지 않음
## $를 활용한 변수 추가 혹은 key(id) 변수를 활용한 결합 활용

my_data$amount = 100
my_data
## 동일한 값 변수 추가


my_data$age_grp = cut(my_data$age, 
                      breaks=c(10,20,30,40), 
                      include.lowest=TRUE, 
                      right=FALSE,
                      labels=c('10_19','20_29','30_39'))
my_data


## cut( )을 활용한 연령대 변수 추가
## breaks : 구간 경계값
## include.lowest : 첫 경계값 포함 여부 (이상~미만, 초과~이하 등)
## right : 각 구간의 오른쪽 경계 포함 여부 
## labels : 각 구간의 이름 , 갯수는 구간-1


############ 조건에 맞는 데이터 합치기 (merge)
sales = read.csv('ex_sales.csv')
sales

prod  = read.csv('ex_prod.csv')
prod


# merge( )를 활용한 데이터 결합
merged = merge(sales, prod, by.x='PROD', by.y='PROD')
## merge(데이터1, 데이터2, by.x='첫번째데이터의 기준변수', by.y='두번째...')


merged = merge(sales, prod, by='PROD')
## 기준변수가 같을 때는 "by="으로 한번에 지정 가능

merged


# all 옵션의 활용
merge(sales, prod, by.x='PROD', by.y='PROD', all.x=TRUE)
## all.x=TRUE : 짝이 없는 첫번째 데이터의 관측치도 포함
## Excel의 VLOOKUP 느낌

merge(sales, prod, by.x='PROD', by.y='PROD', all.y=TRUE)
## all.y=TRUE : 짝이 없는 두번째 데이터의 관측치도 포함

merge(sales, prod, by.x='PROD', by.y='PROD', all=TRUE)
## all=TRUE : 짝이 없는 모든 관측치 포함

###########

# 1:1, 다:1은 문제가 없지만 다:다 결합은 조심!
prod2  = read.csv('ex_prod2.csv')
prod2
## 상품 B에 대한 정보가 중복

merge(sales, prod2, by.x='PROD', by.y='PROD')
## by로 지정된 변수값 기준 
## 모든 가능한 결합을 생성


################################ merge 연습문제 ###################################

a1 <-  data.frame(name=c("aa","bb","cc"),value=seq(10,20,length.out = 3))
a2 <-  data.frame(name=c("cc","dd","ee"),value=seq(30,50,length.out = 3))
a3 <-  data.frame(name=c("aa","dd","ee","ff"),value=seq(20,80,length.out = 4),any=seq(0,3,1))

#  1. a1 와 a2 를 행결합 하시오

rbind(a1,a2)

# 2. a3 와 a1 를 행결합하시오
rbind(a3,a1)

  ##tip. 행/열 수 다를때의 행/열 결합 패키지
install.packages("plyr")
library(plyr)
rbind.fill(a3,a1)

# 3. a3 와 a2 를 name 기준으로 결합 하시오 (a3 데이터는 모두출력)

merge(a3, a2, by.x='name', by.y='name', all.x=TRUE)

# 4. 3번 데이터를 z 에 저장하고 value.y 기준으로 정렬하시오(안풀어도됨)


####################################################################################
