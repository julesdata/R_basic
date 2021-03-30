# 데이터 분석가 _ james        \
#                                \
# 스크립트 실행(Run a script)    \
##  : Windows : 'Ctrl + Enter'   \
##  : MAC     : 'Command + Enter'\
#---------------------------------

# 복습 !

######################
####### dplyr ########
######################

# dplyr 패키지 설치
#SQL 기반 R 패키지 #분석가들 필수템


install.packages('dplyr')
library(dplyr)


#패키지 내의 함수이름들은 매우 직관적이어서 쉬우나, 패키지마다 같은 이름을 사용하는 경우도 잇다. 
#패키지를 여러가지 사용할 경우 어떤 패키지의 어떤함수인지 지정해야함을 주의!


# SKT의 delivery 데이터 활용
## 원본 출처 : SKT Big Data Hub(www.bigdatahub.co.kr)
delivery = read.csv('SKT.csv', fileEncoding='UTF-8')
head(delivery)


## 1.1 slice( )로 특정 행만 불러오기
## 행번호를 활용해서 특정 행을 불러오기
## 햄 슬라이스...


slice(delivery, c(1,3,5:10))
## slice(데이터명, 잘라서가져올 행)
## 1, 3, 5~10 행만 불러오기


##1.2 filter( )로 조건에 맞는 데이터 행만 불러오기
filter(delivery, 시군구=='성북구')
filter(delivery, delivery$시군구=='성북구')

## { filter(데이터명, 조건) }
## '성북구' 데이터만 불러오기


filter(delivery, 시군구=='성북구', 요일 %in% c('토', '일'), 업종=='피자' | 통화건수>=100)

## 복수의 조건 사용
## filter(데이터명, 조건1, 조건2, 조건3, ...)
## 조건문은 논리연산(==, !=, >, < 등)을 활용
## 'OR'은 | 로 연결, 'AND'는 ,로 연결



##1.3 arrange( )로 정렬하기(오름차순)
arrange(delivery, 시군구, 요일, 업종)
## arrange(데이터명, 정렬기준변수1, 정렬기준변수2, ...)

arrange(delivery, desc(시군구), 요일, 업종)
## 내림차순(Descending)으로 정렬할 때는 'desc' 옵션 활용



##1.4 select( )로 변수를 선택하거나 제외하기 ##select사용하여 값을 불려오면, []사용시,벡터로 값이 출력되는 데 반해, 행렬이 유지된다.
select(delivery, 통화건수)

# ":"를 활용한 순서대로 여러변수 선택하기 
select(delivery, 시간대:통화건수)

# "-"를 활용한 변수제외
select(delivery, -요일)  #요일을 뺀 나머지 열 다 가져와



##1.5 distinct( )로 반복 내용제거하기 ##주문데이터 내 고객 수 구하기 등에 사용
distinct( delivery, 업종)


###################### 연습문제 ##########################
data(iris)

## 1.iris 데이터중 1부터 50행중 홀수, 100부터 150행중 짝수 선택
slice(??)

slice(iris,seq(1,50,by=2),seq(100,150,by=2))

## 2.iris 데이터중 Species가 "setosa"이면서 Sepal.Length가 5보다 큰 값을 추출하시오
filter(??)

filter(iris, Species=="setosa", Sepal.Length > 5)

## 3.iris 데이터중 Sepal.Length는 내림차순 Sepal.Width는 오름차순으로 출력하시오
arrange(??)

arrange(iris,desc(Sepal.Length),Sepal.Width)

## 4.iris 데이터중 "Sepal.Width" 와 "Species" 열을 선택하시오
select(??)

select(iris,Sepal.Width,Species) ##dplyr::를 함수 앞에 붙히면 dplyr패키지 안에서의 함수로 특정한다. 

## 5.iris 데이터중 "Species"의 종류를 확인하시오
distinct(??)

distinct(iris,Species)

###########################################################


##1.6 mutate( )로 기존 변수를 활용한 임시 변수 만들기

mutate(delivery, 새요일=paste0(요일, '요일'))

# 변수 추가 
# delivery$새요일 = paste0(delivery$요일, '요일')  #paste: 공백하나 두고 붙히기 /paste0: 공백 x

##1.7 count( )로 그룹별 개수 세기
count(delivery, 시군구)   #시군구로 group된 개념(?)

##1.8 group_by( )로 그룹 지정해주기
delivery_grp = group_by(delivery, 시군구)



##1.9 summarize( )로 요약 하기


summarise(delivery, mean(통화건수), m = min(통화건수), M = max(통화건수))
summarise(delivery_grp, mean(통화건수), m = min(통화건수), M = max(통화건수))
## 원본 데이터는 전체 요약, 그룹이 지정된 데이터는 그룹별 요약

summarise(delivery_grp, length(통화건수))
## "delivery %>% count(통화건수)"와 동일한 개념
## count(delivery_grp,시군구)와 결과 값 같음
## count(group_by(delivery,시군구),시군구)



##1.10 top_n( )으로 상위 관측치 확인하기  

top_n(delivery, 5, 통화건수)

top_n(delivery_grp, 5, 통화건수)


###################### 연습문제 ##########################
data(iris)

## 6.iris 데이터중 "Sepal.Length" 와 "Sepal.Width" 두변수의 합을 Sepal_sum이라는 변수에 저장하시오
mutate(??)
mutate(iris,Sepal_sum = Sepal.Length + Sepal.Width)

## 7.iris 데이터중 "Species"의 종별 개수를 확인하시오
count(??)
count(iris,Species)

## 8.iris 데이터중 Sepal.Length의 합과 Sepal.Width의 평균을 구하시오
summarise(??)
summarise(iris, sum=sum(Sepal.Length), mean=mean(Sepal.Width))

## 9.iris 데이터중 "Petal.Width"의 상위 5개의 값을 출력
top_n(??)
top_n(iris,5,Petal.Width)
###########################################################


##1.11 파이프라인( %>% )을 활용한 연속작업
delivery %>% 
  filter(업종=='중국음식') %>%
  group_by(시군구) %>% 
  summarise(mean_call = mean(통화건수)) %>% 
  arrange(desc(mean_call))


# 데이터 저장
new_data = delivery %>% 
  filter(업종=='중국음식') %>% 
  group_by(시군구) %>% 
  summarise(mean_call = mean(통화건수)) %>% 
  arrange(desc(mean_call))


# 결과를 csv파일로 저장
write.csv(new_data, 'result.csv', row.names=FALSE) 
## 작업폴더(Working Directory)에 'result.csv'이름으로 저장



##1.12 ungroup( )의 활용

delivery %>% 
  filter(업종=='중국음식') %>% 
  group_by(시간대,시군구) %>% 
  summarise(mean_call = mean(통화건수))


# 시군구별 상위 3대 시간대 확인
delivery %>% 
  filter(업종=='중국음식') %>% 
  group_by(시간대, 시군구) %>% 
  summarise(mean_call = mean(통화건수)) %>% 
  ungroup() %>%   ##upgroup을 생략해줘도 다시 재그룹하면 언그룹의 효과를 주긴한다.
  group_by(시군구) %>% 
  top_n(3, mean_call) %>% 
  arrange(시군구, desc(mean_call))

## summarise( )로 요약할 떄의 그룹과
## top_n( )등의 선택에서의 그룹이 다를 때는
## 중간에 ungroup( )을 넣어서 그룹 지정 해제

##연습문제 다풀고, ungroup안하고 처음부터 풀 수 있는 다른방법 연구해보자

########################### 연습문제 #############################

##2 (실습) 보험료 데이터 요약하기

# 예제 데이터 불러오기 
ins = read.csv('insurance.csv')
head(ins)

#1 데이터 ins에서 sex가 female인 관측치로 region별 관측치 수 계산
ins%>%
  filter(sex=='female')%>%
  group_by(region)%>%
  summarise(count=length(charges))%>% ##  summarise에서는 count함수를 사용할 수 없다. 
  arrange(region)                     ## or summarise(num=n()) num=n():갯수 함수

ins%>%
  filter(sex=='female')%>%
  count(region)%>%    ## count 자체가 그룹화하는 개념이 포함되므로 group by를 써주지 않아도 된다.(카운트만 할거면)
  arrange(region)
  
#2 charges가 10000이상인 관측치 중에서 smoker별 평균 age 계산

  ins%>%
    filter(charges>=10000) %>%
    group_by(smoker) %>%
    summarise(mean(age))
              
  
#3 age가 40 미만인 관측치 중에서 sex, smoker별 charges의 평균과 최댓값 계산   

charges.smoker = ins%>%
  filter(age < 40) %>%
  group_by(sex,smoker)%>%
  summarise(mean=mean(charges), max=max(charges))
  

  
# 데이터를 csv파일로 저장하기
# 위에서 작업한 내용 중 3번을 csv파일로 저장해보기

write(charges.smoker,'charges_smoker.csv',row.names=false)

########################################################################


##3 (실습) 국민건강보험공단 데이터 요약

# 국민건강보험공단 진료내역정보 
## http://data.go.kr/dataset/15007115/fileData.do
## 원본 데이터에서 외래 진료 건과 주요 변수만 선택


load('NHIS.RData')

View(NHIS)
str(NHIS)
head(NHIS)
# IDV_ID  가입자일련번호
# SEX  성별
# AGE_GROUP  연령대코드
# FORM_CD  서식코드
# DSBJT_CD  진료과목코드 
# MAIN_SICK  주상병코드 
# VSCN  요양일수
# RECN  입내원일수
# EDEC_TRAMT  심결요양급여비용총액
# EDEC_SBRDN_AMT  심결본인부담금


# 성 / 연령대별 진료건수 계산  (진료건수 기준 내림차순 정렬)

NHIS %>% 
  group_by(SEX, AGE_GROUP) %>% 
  summarise(n=length(SEX)) %>% 
  arrange(desc(n))

NHIS %>% 
  dplyr::count(SEX, AGE_GROUP) %>% 
  arrange(desc(n))


# 성별/연령대별 환자 분포 확인
## distinct() : 중복값 제거 


NHIS %>%
  dplyr::select(IDV_ID, SEX, AGE_GROUP) %>%
  unique() %>%
  dplyr::count(SEX, AGE_GROUP)


############################ 연습 문제 ################################


# 문제1
# 성 / 연령대 / 진료과목별 환자수  계산  (환자수 기준 내림차순 정렬)

NHIS %>%
  dplyr::count(SEX,AGE_GROUP,DSBJT_CD) %>%
  arrange(desc(n))

NHIS %>%
  dplyr::group_by(SEX,AGE_GROUP,DSBJT_CD) %>%
  summarise(n=length(SEX)) %>%
  arrange(desc(n))

# 문제2
# 성별/연령대별 평균(요양일수/입내원일수/급여비용/본인부담금액) 계산 후 급여비용 내림차순으로 정렬

NHIS %>%
  dplyr::group_by(SEX,AGE_GROUP) %>%
  summarise(m1=mean(VSCN), m2=mean(RECN),m3=mean(EDEC_TRAMT),m4=(EDEC_SBRDN_AMT) ) %>%
  arrange(desc(mean(m3)))

  # IDV_ID  가입자일련번호
  # SEX  성별
  # AGE_GROUP  연령대코드
  # FORM_CD  서식코드
  # DSBJT_CD  진료과목코드 
  # MAIN_SICK  주상병코드 
  # VSCN  요양일수
  # RECN  입내원일수
  # EDEC_TRAMT  심결요양급여비용총액
  # EDEC_SBRDN_AMT  심결본인부담금  
  
  
  
# 문제3
# 성별/연령대별 3개 최고빈도 주상병코드
## top_n(n=k, wt=기준변수) : 기준변수를 기준으로 상위 k개 관측치 선택
## 주상병코드 조회 (MAIN_SICK)

NHIS %>%
  dplyr::group_by(SEX,AGE_GROUP,MAIN_SICK) %>%
  summarise(n=length(MAIN_SICK))%>%
  top_n(n=3, wt=n)%>%
  arrange(SEX,AGE_GROUP,desc(n))  

  NHIS %>%
    group_by(SEX, AGE_GROUP, MAIN_SICK) %>%
    summarise(n=n()) %>%
    top_n(n=3 , wt=n) %>%
    arrange(SEX, AGE_GROUP, desc(n))
  
  NHIS %>%
    count(SEX, AGE_GROUP, MAIN_SICK) %>%
    group_by(SEX, AGE_GROUP) %>%
    top_n(n=3 , wt=n) %>%
    arrange(SEX, AGE_GROUP, desc(n))

###### mutate의 확장
## 변수의 group별 비율을 아고싶다면?? mutate활용!
data(iris)
head(iris)

## 도전해보자
## Species 별로 Sepal.Length의 비중을 알고싶다면??

#ex) prop 열 추가하려면? 
# m group   prop
# 2   a     0.2
# 3   a     0.3
# 5   a     0.5
# 1   b     0.2
# 1   b     0.2
# 3   b     0.6


######################
# 코드 작성

#내답
iris%>% 
  group_by(Species)%>%
  mutate(sum=sum(Sepal.Length))%>%
  mutate(prop=Sepal.Length/sum)%>%
  select(Species,Sepal.Length,prop)
  
#쌤답
iris %>%
  dplyr::group_by(Species) %>%
  dplyr::mutate(sum = sum(Sepal.Length)) %>%
  dplyr::mutate(prop = Sepal.Length/sum) %>%
  dplyr::select(Species,Sepal.Length,prop)

# 종별 비중 요약
iris %>%
  mutate(All.sum=sum(Sepal.Length))%>%
  group_by(Species, All.sum) %>%
  summarise(sum=sum(Sepal.Length))%>%
  mutate(prop=sum/All.sum)


######################



###### mutate의 확장2
## group별로 번호를 매기고 싶다면??

iris  %>% 
  arrange(Species,Sepal.Length) %>%
  dplyr::group_by(Species) %>%
  dplyr::mutate(seq_num = row_number()) %>% data.frame() #data.frame()하면 값이 끝까지 조회됨 

# 도전해보자
# iris 데이터에서 Species별 Sepal.Width가 3번째로 큰 값들의 합은?

A1<- iris %>%
  group_by(Species) %>%
  arrange(Species,desc(Sepal.Width))%>%
  mutate(seq_num=row_number()) %>%
  filter(seq_num==3) %>%
  ungroup() %>%
  summarise(sum = sum(Sepal.Width))
  
sum(A1$Sepal.Width)

#한번에 전체 합계 구하는 방법은?

iris %>%
  group_by(Species) %>%
  arrange(Species,desc(Sepal.Width))%>%
  mutate(seq_num=row_number()) %>%
  filter(seq_num==3) %>%
  ungroup() %>%
  summarise(sum = sum(Sepal.Width))



######################
# 코드 작성


######################

###summarise 응용
data(iris)

iris %>% group_by(Species) %>% summarise(across(1:4, mean))
iris %>% group_by(Species) %>% summarise(across(Sepal.Length:Petal.Width, .fns = mean))
iris %>% group_by(Species) %>% summarise(across(.cols = everything(), .fns = c(mean,max)))


iris %>% group_by(Species) %>% summarise_all(.funs = mean)
iris %>% group_by(Species) %>% summarise_all(funs(mean,max))


iris %>% group_by(Species) %>% summarise_at(vars(1:4), funs(mean,max))
iris %>% group_by(Species) %>% summarise_at(vars(Sepal.Length:Petal.Width), funs(mean,max))
