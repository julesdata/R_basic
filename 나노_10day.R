# 데이터 분석가 _ james         \
#                                \
# 스크립트 실행(Run a script)    \
##  : Windows : 'Ctrl + Enter'   \
##  : MAC     : 'Command + Enter'\
#---------------------------------


###  9일차 리뷰

### 질의응답 및 전체 리뷰


############################################
######## 5-2 직접 분석해보기 (따릉이 데이터) #########
############################################
library(ggplot2)

train <- read.csv("bike.csv")
head(train)
str(train)

# lubridate 패키지란?
# 날짜를 쉽게 변환하는 패키지
# ymd : 연월일
# ymd_hms : 연월일_시간

ymd("2020-01-01")
ymd("20200101")

ymd_hms("2020-01-01-03-25-30")
ymd_hms("20200101032530")

# 1. 날짜형으로 변형
train$datetime <-ymd_hms(train$datetime)


# 2,3,4 year,month,day 그리고 weekday, hour을 추출후 범주형으로 변환
train$year <- year(train$datetime)
train$month <- month(train$datetime)
train$day <- day(train$datetime)
train$hour <- hour(train$datetime)
train$weekday <- weekdays(train$datetime)

head(train)
str(train)
summary(train)
## 데이터 분석 시작

## 데이터 변형해주기
train$season= as.factor(train$season)
train$weather<- as.factor(train$weather)
train$holiday<- as.factor(train$holiday)
train$workingday <- as.factor(train$workingday)
train$weekday <- as.factor(train$weekday)

train$year <- as.factor(train$year)
train$month <- as.factor(train$month)


## 범주형, 연속형을 구분해주는것은 중요!


## 가설 검정을 시도해보자!
## 일하는날과 일안하는날, 시간에 따라서 자전거 수요는 다를까?? 
## 또한 온도에 따라서도 어떤 영향을 받을까?

## 1. 시각적 접근

## workingday마다 시간에 따른 자전거 수요 시각화하기
## (온도에 대해서 색으로 구분하기!)

## (10분)
######## 코드 작성 #########

train %>% 
  ggplot(aes(x=hour, y=count, color=temp)) + geom_point() + facet_grid(~workingday)



############################


## 2. 통계적 접근

### 그렇다면 실제 workingday에 따라서 통계 확인
### workingday는 1과 0으로 되어있는 2범주 데이터이다
### 그러므로 T검정 실시!

# 등분산 검정을 먼저 실시!
# options(scipen = 3) #지수형태가 보기 싫을때

# 귀무가설 : 등분산을 만족한다
# 대립가설 : 등분산을 만족하지 않는다.
var.test(count~workingday,data=train)

# p-value 를 보면 0.05보다 작음을 볼 수 있다.
# 즉, 귀무가설 기각 따라서 등분산을 만족하지 않는다.

# t검정을 진행하면
t.test(count~workingday,data=train,var.equal = F)

#귀무가설 : 그룹마다 차이가 없다.
#대립가설 : 그룹마다 차이가 있다.

# t검정을 해석해보면 등분산을 만족하지 않는 선에서
# 0의평균균은 약 188, 1의평균읜 193이고
# t검정 결과 유의확률은 0.05보다 작으므로 귀무가설 채택
# 즉, 그룹마다 차이가 없다!


##########################

# 위와 같은 과정을 holiday에 따라서 확인하기

######## 코드 작성 #########

#시각화
train %>% 
  ggplot(aes(hour, count, color=temp)) +
  geom_point() +
  facet_grid(~holiday)

#등분산성검정
var.test(count~holiday, data=train)

#유의확률은 0.074로 유의수준 0.05보다 크다. 즉, 귀무가설 채택 등분산성을 띈다.

#T검정
t.test(count~holiday, data=train, var.equal= T)
#유의확률은 0.54로 귀무가설 채택, 즉 Holiday의 여부에 따른 시간대별 대여량 평균은 통계적으로 차이가 없다. 

############################

# 그럼 이제 실제 데이터 분석 및 변형을 해보자

# 1. 계절에 대해서 실제 그림을 그려보기
# 시간별 대여 수량의 평균을 계절별로 나눠서 그리시오! 

train %>%
  group_by(season,hour) %>%
  summarise(mean = mean(count)) %>%
  ggplot(aes(x=hour,y=mean,group=season,color=season)) + geom_line()


# 그림에서 이상한 점을 발견할 수 있을 것이다.
# 이상한 점을 확인하고, 수정하여 다시 그리시오!

######## 코드 작성 #########

if(month %in% c(3,4,5)){
  "1"
}else if (month %in% c(6,7,8)){
  "2"
}else if (month %in% c(9,10,11)){
  "3"
}else {"4"}

train %>% mutate(season_new =
ifelse(month %in% c(3,4,5),1,
       ifelse( month %in% c(6,7,8),2,
               ifelse(month %in% c(9,10,11),3,4)))) %>%
  group_by(season_new, hour) %>%
  summarise(mean=mean(count)) %>%
  ggplot(aes(hour,mean,group=factor(season_new),color=factor(season_new))) + geom_line()
  

############################

# 바람 속도에 대해서 전처리
# 실제 바람속도를 히스토그램 그려보면 이상한 점을 발견할 수 있을것이다
# 그 값을 바꿔보시오

train %>%
  ggplot(aes(x=windspeed)) + geom_histogram()

summary(train$windspeed)
# 0을 전처리 하기!
# 중앙값으로 대체하기!

######## 코드 작성 #########





############################


#### F검정 하기
data(iris)
head(iris)
# Species마다 Sepal.Length는 다르다고 말할 수 있을까?
summary(aov(Sepal.Length~Species,data=iris))


# F검정 연습하고 해석하기
# weekday마다 count의 차이가 있는지 검정해보시오

######## 코드 작성 #########
bartlett.test(count~weekday, data=train)




############################

# 상관 관계 확인하기


# 1.temp와 atemp는 얼마나 상관이 있는가?
cor(train$temp,train$atemp)


# 2.count와 가장 연관이 있는 변수는 어떤 변수인가? (registered , casual 제외)
library(PerformanceAnalytics)

chart.Correlation(train[,6:12], histogram=TRUE, pch=19)
head(train[,6:12])
round(cor(train[,6:12]),2)

# 3.가장 영향력 있는 변수와의 그림을 그려보기
train %>%
  ggplot(aes(count,temp,color=count))+geom_point()


######## 전략을 세워보기!


## 시간 월별로는 자전거 대여가 어떻게 다르지??

## 요일별로 시간별로 어떻게 다르지??

## 각자 자전거 배치에 대한 전략을 세우고 근거를 만들어 보세요

## ex) 온도가 30 넘고 휴일이면 평균 몇대 이상씩은 두어야된다
## ex) 출퇴근 시간에는 어느정도 고정수요가 있기 떄문에 적정 수량을 배치한다.

##

train$month <- as.factor(train$month)
train$hour <- as.factor(train$hour)

train %>%
  group_by(weekday,hour) %>%
  dplyr::summarise(mean = mean(count)) %>%
  ggplot(aes(x=hour,y=mean,color=weekday,group=weekday)) + geom_line()

train$weekday <- factor(train$weekday,levels = c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"))


train %>%
  group_by(weekday,hour) %>%
  dplyr::summarise(mean = mean(count)) %>%
  ggplot(aes(x=hour,y=mean,group=weekday,color=weekday)) + geom_line()


train %>%
  group_by(month,hour) %>%
  dplyr::summarise(mean = mean(count)) %>%
  ggplot(aes(x=hour,y=mean,color=factor(month),group=month)) + geom_line()


train %>% 
  ggplot(aes(x=hour, y=weekday, fill=count)) +
  geom_tile() +
  scale_fill_distiller(palette='Blues')



train %>% 
  ggplot(aes(x=hour, y=month, fill=count)) +
  geom_tile() +
  scale_fill_distiller(palette='Blues',direction = 1)


#######################################################
#######################################################

## 전체 리뷰 해보기!

########### 마지막 꿀팁
install.packages("DataExplorer")
library(DataExplorer)
data(iris)
head(iris)

config <- list(
  "introduce" = list(),
  "plot_str" = list(
    "type" = "diagonal",
    "fontSize" = 35,
    "width" = 1000,
    "margin" = list("left" = 350, "right" = 250)
  ),
  "plot_missing" = list(),
  "plot_histogram" = list(),
  "plot_qq" = list(sampled_rows = 1000L),
  "plot_bar" = list(),
  "plot_correlation" = list("cor_args" = list("use" = "pairwise.complete.obs")),
  #  "plot_prcomp" = list(),
  "plot_boxplot" = list(),
  "plot_scatterplot" = list(sampled_rows = 1000L)
)

create_report(iris, config = config)

## 치킨데이터 적용시켜보기
create_report(train,config = config)
