# 데이터 분석가 _ james        \
#                                \
# 스크립트 실행(Run a script)    \
##  : Windows : 'Ctrl + Enter'   \
##  : MAC     : 'Command + Enter'\
#---------------------------------

# dplyr 복습하기
install.packages("hflights")   #패키지 안에 데이터가 포함되어있어서 사용
library(hflights)
data("hflights")
library(dplyr)

# 미국 휴스턴에서 출발하는 모든 비행기의 2011년 이착륙기록이 수록된 것으로 227,496건의 이착륙기록
head(hflights)

# 1월 20일 데이터 추출
filter(hflights, Month == 1, DayofMonth == 20)

# 데이터를 ArrDelay, Month, Year 순으로 정렬
arrange(hflights, ArrDelay, Month, Year)

##### 연습문제!

#문제1
# mutate를 사용해 delay라는 변수를 만들고 오름차순으로 정렬후 상위 20개의 평균을 구하시오
# delay = ArrDelay - DepDelay

hflights%>%
  mutate(delay = ArrDelay - DepDelay)%>%
  arrange(delay)%>%
  summarise(mean(top_n(n=20,wt=delay)))


#문제2
# 비행편수(TailNum)가 20편 이상, 평균 비행거리가 2000마일 이상 평균 연착시간의 평균을 구하시오
# 비행거리 : Distance
# 연착시간 : ArrDelay


##평균의 평균이 무슨말...? :group_by로 비행 편명 별 그룹을 해주었기 때문에 비행편명별 그룹 -> 각 비행편들의 평균 -> 조건해당되는 그룹의 평균을 또 구하는 것.


hflights%>%
  group_by(TailNum)%>%                      
  summarise(num = n(),                           #num=n() : count와 같은 의미
            dis=mean(Distance,na.rm=T),
            delay = mean(ArrDelay, na.rm=T))%>%
  filter(num >= 20, dis > 2000)%>%
  summarise(mean(delay))                        #열에대한 연산(summary)은 다시 할 수 있다. 
  

  

##########################################
################# tidyr ##################
##########################################

delivery=read.csv('SKT.csv', fileEncoding='UTF-8')

##1 tidyr 패키지를 활용한 데이터 처리 
## 데이터 정렬 형태 변경( wide <-> long )


# 예제 데이터 불러오기  
delivery = read.csv('SKT.csv', fileEncoding='UTF-8')
head(delivery)

# tidyr 패키지 불러오기
install.packages('tidyr')
library(tidyr)
library(dplyr)

## 파이프라인(%>%)을 쓰기 위해서 불러오기


# group_by( ) %>% summarise( )로 데이터 요약하기
aggr = delivery %>% 
  group_by(시군구,시간대,요일,업종) %>% 
  summarise(통화건수=sum(통화건수)) %>% 
  as.data.frame()
aggr


##1.1 spread( )로 데이터를 여러 열로 나누기(long -> wide)
## spread(데이터이름, 기준변수이름, 나열할 값)
aggr %>% 
  spread(업종, 통화건수) 

aggr_wide = aggr %>% spread(업종, 통화건수) 
aggr_wide


##1.2 replace_na( )로 결측값 처리하기              #spread와 짝을이뤄 사용! 
## replace_na(list(변수1=값, 변수2=값, ...))
aggr_wide %>% replace_na(list(족발보쌈=999, 중국음식=0, 치킨=0))


aggr_wide2 = aggr_wide %>% replace_na(list(족발보쌈=0, 중국음식=0, 치킨=0, 피자=0))


##1.3 drop_na( )로 결측값을 포함한 관측치 버리기
## drop_na(결측값을 찾을 변수1, 변수2, ...) 
aggr_wide %>% drop_na()                      #na가 1개라도 포함된 행 다 날려! (되도록 그러지는 말고..)
aggr_wide %>% drop_na(치킨, 피자)            #치킨하고 피자에 na가 있으면 다 날려!




## 반대로!!    

##1.4 gather( )로 여러 열을 한 열+구분변수로 만들기(wide->long)
## gather(데이터이름, 새기준변수이름, 새변수이름, 모을 변수들)
aggr_wide2 %>% gather(Category, Count, 족발보쌈, 중국음식, 피자, 치킨)

## 순서대로 시군구부터 요일까지를 뺀 나머지 변수를 선택
aggr_long = aggr_wide2 %>% gather(Category, Count, -(시군구:요일))

aggr_long


##1.5 complete( )로 빠져있는 조합 채우기

nrow(aggr_wide2)
## 3947 !=  4200 = 25(시군구)*24(시간대)*7(요일)  na값도 있기 때문에 데이터 갯수는, 모든 경우의 수 보다 작을 수 있다. 

aggr_wide2 %>% complete(시군구, 시간대, 요일) #모든 경우의 수로 만들어라~ (na로 생성됨)

# fill= 옵션으로 빈값 채우기 na대신 지정값으로 채워짐                            
aggr_wide2 = aggr_wide2 %>% complete(시군구, 시간대, 요일, fill=list(족발보쌈=0, 중국음식=0, 치킨=0, 피자=0))
                                     #complete 함수 내에서 fill을 옵션으로 주면 replace_na함수의 효과까지 같이 볼 수 있다. 



##2 (실습) 서울시 지하철 이용데이터 
# 출처 : 공공데이터포털(www.data.go.kr)

# 데이터 불러오기
## 역변호가 150인 서울역 데이터 
library(openxlsx)
subway_2017 = read.xlsx('subway_1701_1709.xlsx')
subway_2017


# 데이터의 구조 확인
str(subway_2017)

# 첫 10개 관측치만 확인하기
head(subway_2017, n=10)

# 변수이름 확인 ->이름변환
names(subway_2017)
names(subway_2017)[6:25]

substr(names(subway_2017)[6:25], 1, 2)
## 첫 두 글자만 선택 

paste0('H', substr(names(subway_2017)[6:25], 1, 2))  
## 앞에 'H'를 붙임
paste
names(subway_2017)[6:25] <- paste0('H', substr(names(subway_2017)[6:25], 1, 2))
## '='을 활용해서 변수이름 업데이트

names(subway_2017)


######################## 연습문제 #############################

# (실습) gather( ) 함수를 활용하여 H05부터 H24까지 변수를 모아
# '시간대'와 '승객수'으로 구분하는 데이터 subway2 만들기
subway2 = gather(subway_2017,시간대,승객수,H05:H24)

## 위에서 만든 subway2 데이터와 dplyr 패키지를 활용하여

# 역명/시간대별 전체 승객수 합계 계산 (승객수 합계의 내림차순으로 정렬)
subway2 %>% 
  group_by(역명,시간대)%>%
  summarise(sum=sum(승객수))%>%
  arrange(desc(sum))


# 위의 결과를 spread( ) 함수를 활용해서 표 형태로 변환
subway2 %>%
  group_by(역명,시간대)%>%
  summarise(sum=sum(승객수))%>%
  arrange(desc(sum))%>%   #arrange를 미리 사용하면 재정렬이되기때문에, 나중에 사용
  spread(시간대,sum)



# 역명/시간대/구분별 전체 승객수 합계 계산
subway2 %>%
  group_by(역명,시간대,구분)%>%
  su


# 2월 한달간 역명/시간대/구분별 전체 승객수 합계 계산
subway2 %>% NA


##############################################################################


###########################
###### 문자열 다루기 ######
###########################

## 기본 패키지 설치하기
install.packages("stringr")
library(stringr)


# 큰따움표와 작은 땨움표
string1 <- "This is a string"
string2 <- "If I want to include a 'quote' inside a string, I use single quotes" #큰따옴표로 묶고, 안에 작은따옴표 처리하는 것이 가장 안전.
string2 <- 'If I want to include a "quote" inside a string, I use single quotes' #문장 내 큰따옴표가 특수문자 처리 됨. 


# 영원히 끝나지 않는 코드
"This is a string without a closing quote
    

"   #따옴표를 끝낼 때까지 코드를 읽게 됨. 꼭 마무리할 것!

#### 패턴찾기 ####

#str_detect(데이터, 패턴)
x <- c("apple", "banana", "pear")
str_detect(x, "e")   #e가 있는지 t/f로 반환

#str_count(데이터, 패턴)
str_count(x,"e")   #e가 몇개 있어?

#str_which(데이터, 패턴)
str_which(x,"e")    #e가 몇번 째 값에 있어? ex)몇번 째 벡터에 있어? 

#str_locate(데이터, 패턴)
str_locate(x,"a")   #e가 각 값 내에서 몇 번째 텍스트에 있어? , 중복의 경우 1번째 위치만 표기
str_locate("aaa","a") # 1,1
str_locate("aaa","aa") # 1,2

### 부분집합 찾기

#str_sub(데이터, 시작, 끝)
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)   #각 값의 1번째 ~3번째 텍스트 가져와 = sumstr
str_sub(x, -3, -1) #뒤에서부터

substr(x,1,3)


#str_subset(데이터, 패턴)
str_subset(x,"r")  # r을 갖고있는 값을 가져와


### 문자열 변형하기
# str_replace(데이터,찾는변수,바꿀변수) / 1번째 찾은 값만 바꿈
# str_replace_all(데이터,찾는변수,바꿀변수) / 모든 값 바꿈

str_replace("apple","p","l")
str_replace_all("apple","p","l")


# Mutate STrings
str_to_lower("STRING") #소문자로
str_to_upper("string") #대문자로
str_to_title("string") #첫 글자만


### 연습해보기

# 문제 1
# words를 모두 대문자로 바꾼 상태에서 'AA'를 포함한 단어의 개수는 총 몇개이며 어떤단어들이 있는가?

sum(str_detect(str_to_upper(words),'AB'))
str_to_upper(words)[str_which(str_to_upper(words),'AB')]

# 문제 2
# words에서 "b"를 "a"로 모두 바꾸고 "aa"를 포함하는 단어 개수는?


# 문제 3
# words에서 "e"의 수는 전체 합과 평균은 몇인가?



#######################
###### 타입 변환 ######
#######################

as.factor(x)
# 주어진 객체 x를 팩터로 변환

as.numeric(x)
# 주어진 객체 x를 숫자를 저장한 벡터로 변환

as.character(x)
# 주어진 객체 x를 문자열을 저장한 벡터로 변환

as.matrix(x)
# 주어진 객체 x를 행렬로 변환

as.data.frame(x)
# 주어진 객체 x를 데이터 프레임으로 변환


x <- c("a", "b", "c")
as.factor(x)

as.character(as.factor(x))

x <- matrix(1:9, ncol=3)
as.data.frame(x)     #열 이름이 자동 삽입됨

#is.factor(x): x가 factor야? ->논리형(t/f)으로 반환


###########################
###### 날짜 데이터 ######
###########################
install.packages('lubridate')
library(lubridate)

# 기본적으로 일반 텍스트 데이터를 날짜 데이터로 바꿉
as.Date('2020-01-01')  # 'YYYY-MM-DD' 형태로 입력을 해야만 인식한다.
as.Date(2020-01-01) #텍스트가 전재!
as.Date(20200101)
as.Date('20200101')

# lubridate에 들어 있는 ymd() 함수는 어떤 모양이든 이를 날짜로 인식!
ymd('20200110')
mdy('January 10th 2020')
dmy('10-jan-2020')
ymd('820327')
ymd(820327)


# 날짜 데이터 뽑아내기
date_test <- ymd(191020)

year(date_test)
month(date_test)
day(date_test)
week(date_test) #연도 기준 몇주차인지
wday(date_test) #요일을 숫자로 반환. 
wday(date_test,label = T) #요일을 텍스트로 및, 시작 요일과 함께 반환

# 날짜로 각종 계산하기

date_test + days(100) #100일 후
date_test + months(100) #100개월 후
date_test + years(100) #100일 후

today()
today()-date_test


# 날자 + 시간 데이터
ymd_hm(20-10-20 14:30)
ymd_hm("20-10-20 14:30")

date_test2 <- ymd_hm("20-10-20 14:30")
hour(date_test2)
minute(date_test2)
second(date_test2)

##############################
### 연습해보기 날짜 연습해보기
head(subway_2017)
summary(subway_2017$날짜)
min(subway_2017$날짜)

# 문제1
# (실습) gather( ) 함수를 활용하여 H05부터 H24까지 변수를 모아
# '시간대'와 '승객수'으로 구분하는 데이터 subway2 만들기
# subway2 데이터의 날짜에 시간을 추가하기 ex) "2017-01-02 06:00:00"


# 문제2
# subway_2017 데이터에서 월과 일을 month, day 변수명으로 추가하시오

# 문제3
# 위에서 추가한 변수들 기반으로 3월중 가장 많이 탑승한 시간은 몇시인가?


########## 결측치 처리 #############
# 결측치(Missing Value)
# 누락된 값, 비어있는 값
# 함수 적용 불가, 분석 결과 왜곡
# 제거 후 분석 실시

# 결측치 확인하기

df <- data.frame(sex = c("M", "F", NA, "M", "F"),
                 score = c(5, 4, 3, 4, NA))

is.na(df)
table(is.na(df))  #table: 값 요약 느낌쓰...
table(is.na(df$sex))

summary(df)   #na몇개인지 간단히 확인 가능.데이터 많을 시 apply로 확인

apply(X = df, MARGIN = 2, FUN = function(x){sum(is.na(x))})  #true=1, false=0
sapply(X = df, FUN = function(x){sum(is.na(x))})

apply(iris[,1:4],2,function(x){sum(is.na(x))})


# 결측치 제거
library(dplyr) # dplyr 패키지 로드
df %>% filter(is.na(score))
df %>% filter(!is.na(score))  # score 결측치 제거


df %>% filter(!is.na(score) & !is.na(sex))

df_nomiss2 <- na.omit(df)  # 모든 변수에 결측치 없는 데이터 추출. 결측치 포함 행 모두 삭제
df_nomiss2                 # 출력


# 결측치 대체하기
df
df$score <- ifelse(is.na(df$score), 4, df$score)  # math가 NA면 55로 대체
table(is.na(df$score))                               # 결측치 빈도표 생성


install.packages("ggplot2")
library(ggplot2)
mpg <- as.data.frame(ggplot2::mpg)           # mpg 데이터 불러오기
mpg[c(65, 124, 131, 153, 212), "hwy"] <- NA  # NA 할당하기

apply(mpg,2,function(x){sum(is.na(x))})
mpg[is.na(mpg$hwy),"hwy"] <- mean(mpg$hwy,na.rm = T)


install.packages("zoo")
library(zoo)

na.locf0(c(NA, NA, "A", NA, "B"), fromLast = FALSE) # 1 결측치에 왼쪽 값을 채워넣어줌
    ## [1] NA  NA  "A" "A" "B"

na.locf0(c(NA, NA, "A", NA, "B"), fromLast = TRUE) # 2  결측치를 오른쪽부터 채움
    ## [1] "A" "A" "A" "B" "B"


##############################
####### 결측치 처리해보기!!
data(airquality)
head(airquality)


# 1. airquality 데이터의 결측치 개수를 구하시오 (열별로)

sapply(X = airquality, function(x){sum(is.na(x))})

apply(airquality, 2, function(x){sum(is.na(x))})

apply(X=airquality,MARGIN=2, FUN=function(x){sum(is.na(x))}) #구분자 써줄거면 대문자로...

# 2. 결측치가 있는 행들을 제거한 후 각 열의 평균을 구하시오

airquality_2 <- na.omit(airquality)
apply(airquality_2,2,mean)

# 3. 결측치는 변수의 중앙값으로 대체후 각 열의 평균을 출력하시오
airquality[is.na(airquality$Ozone), "Ozone"]<-median(airquality$Ozone, na.rm=T)
airquality[is.na(airquality$Solar.R), "Solar.R"]<-median(airquality$Solar.R, na.rm=T)
apply(airquality, 2, mean)
