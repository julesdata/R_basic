# 데이터 분석가 _ james         \
#                                \
# 스크립트 실행(Run a script)    \
##  : Windows : 'Ctrl + Enter'   \
##  : MAC     : 'Command + Enter'\
#---------------------------------


## 복습하기
# dplyr   #day_4
# tidyr   #day_5
# ggplot  #day_6


## 연습문제 풀어보기
library(tidyr)
library(dplyr)
library(openxlsx)
library(lubridate)
subway_2017 = read.xlsx('subway_1701_1709.xlsx')
names(subway_2017)[6:25] <- paste0('H', substr(names(subway_2017)[6:25], 1, 2))



#  subway_2017데이터를 활용해서 요약 시각화를 진행하여라
#1. gather을 사용해서 H05부터 H24까지 시간, 고객 변수명으로 데이터 변형하시오
#2. facet_grid를 사용해서 시간별 고객의 합을 월별로 따라로 그리시오 (1,2,3,4월)

subway2<-gather(subway_2017,"시간","고객",H05:H24)

## month를 사용해서 월 변수를 만들어야 한다.



### 프로젝트1

#################################################
######## 직접 분석해보기 (치킨 데이터) ##########
#################################################

# 내가 치킨집을 차릴경우 어떤 데이터를 보고 결정할 것인가?

kk<-read.csv("chicken.csv",fileEncoding = "CP949")
# mac인 경우 fileEncoding = "CP949"를 추가해야 한글이 깨지지 않습니다


# ex) 단순히 전체 지역에서 통화건수를 기반으로 높은 지역을 찾기
# ex) 가장 높은 연령대를 찾고 그 연령대의 전화가 많은 지역을 찾기

head(kk)
summary(kk)
str(kk)

# kk$요일 <- as.factor(kk$요일) factor로 변호
kk$요일 <- as.factor(kk$요일)
kk$성별 <- as.factor(kk$성별)
kk$시도 <- as.factor(kk$시도)
kk$시군구 <- as.factor(kk$시군구)
kk$읍면동 <- as.factor(kk$읍면동)
kk$업종 <- as.factor(kk$업종)

head(kk,50)

# scale_x_discrete(limits = c("월","화","수","목","금","토","일"))
# scale_x_discrete (x축 순서 조정)



# ex) 요일별 성별 비중을 확인해서 가장 높은 지역의 지역을 찾기

# 시군구 상위 10 개수

# 행수
kk %>%
  dplyr::count(시군구) %>%
  top_n(10,n) %>%
  arrange(desc(n))


#통화건수의 합
kk %>%
  group_by(시군구) %>%
  dplyr::summarise(sum=sum(통화건수)) %>%
  top_n(10,sum) %>%
  arrange(desc(sum))


# 성별 연령별 통화가 가장 많은 곳은?

kk %>%
  group_by(성별,연령대) %>%
  dplyr::summarise(sum=sum(통화건수)) %>%
  data.frame()


kk %>%
  group_by(성별,연령대) %>%
  dplyr::summarise(sum=sum(통화건수)) %>%
  ggplot(aes(x=연령대,y=sum,fill=성별)) +
  geom_bar(stat="identity",position = "dodge")


# 성별 연령대별 지역 top
# 30대 40대 대상

target <- kk %>%
  filter(연령대 %in% c("30대","40대")) %>%
  group_by(성별,연령대,시군구) %>%
  dplyr::summarise(sum = sum(통화건수),
                   num = n()) %>%
  ungroup() %>%
  group_by(시군구) %>%
  dplyr::summarise(sum1 = sum(sum),
                   num1 = sum(num)) %>%
  arrange(desc(sum1))

# 그래도 만명은 넘는 지역 선별 후 시각화
target %>%
  filter(sum1 >= 10000) %>%
  ggplot(aes(x=시군구,y=sum1,fill=시군구)) + geom_bar(stat="identity")


# 요일별 성별 가장 많이 팔리는 시점 확인

kk %>%
  group_by(요일,성별) %>%
  dplyr::summarise(sum = sum(통화건수)) %>%
  arrange(desc(sum))

kk %>%
  group_by(요일,성별) %>%
  dplyr::summarise(sum = sum(통화건수)) %>%
  ggplot(aes(x=요일,y=sum,fill=성별)) +
  geom_bar(stat="identity",position = "dodge")

kk %>%
  group_by(요일,성별) %>%
  dplyr::summarise(sum = sum(통화건수)) %>%
  ggplot(aes(x=요일,y=sum,fill=성별)) +
  geom_bar(stat="identity",position = "dodge")+
  scale_x_discrete(limits = c("월","화","수","목","금","토","일"))


# 금토일 장사만 해야지!
target2 <- kk %>%
  filter(요일 %in% c("금","토","일")) %>%
  group_by(요일,시군구) %>%
  dplyr::summarise(sum = sum(통화건수),
                   num = n()) %>%
  ungroup() %>%
  group_by(시군구) %>%
  dplyr::summarise(sum1 = sum(sum),
                   num1 = sum(num)) %>%
  arrange(desc(sum1))

target2 %>%
  filter(sum1 >= 10000) %>%
  ggplot(aes(x=시군구,y=sum1,fill=시군구)) + geom_bar(stat="identity")

#주중, 주말 별 연령대 분포
kk<-dplyr::mutate(kk,주중주말= 
         as.factor(ifelse(kk$요일%in% c("금","토","일"),"주말","주중")))

summary(kk)

kk %>% group_by(주중주말,연령대) %>% summarise(sum=sum(통화건수))

#########################
## 각자 전략을 작성해보기
#########################

# 왜 그렇게 했는지 충분한 근거과 그림이 있어야 됩니다!
# ex) 단순히 전체 지역에서 통화건수를 기반으로 높은 지역을 찾기
# ex) 가장 높은 연령대를 찾고 그 연령대의 전화가 많은 지역을 찾기
# ex) 시간에 따른증가, 분산등을 활용하면 더욱 좋은 방향!



## 가설 검정을 2회이상 진행하기!
# ex) 특정 시간 차이가 있는가?
# ex) 성별, 특정 지역별 차이가 있는가?
# ex) 구매건수별 주문전화 상관관계가 얼마나 큰가?

#######################
#### 코드 작성



#######################
