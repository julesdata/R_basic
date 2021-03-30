# 데이터 분석가 _ james        \
#                                \
# 스크립트 실행(Run a script)    \
##  : Windows : 'Ctrl + Enter'   \
##  : MAC     : 'Command + Enter'\
#---------------------------------

# 기초통계

#평균
mean(
  x,
  na.rm=FALSE,  # 평균 계산 전 NA를 제거할지 여부
)

#분산
var(
  x,
  na.rm=FALSE,
)

#표준편차
sd(
  x,
  na.rm=FALSE,
)

#사분위수
quantile(1:10,0.7)

####
mean(1:5)
var(1:5)
sum((1:5-mean(1:5))^2)/(5-1)  # 분모로 n-1이 사용됨을 확인할 수 있음
sd(1:5)
summary(1:11)


########### 범주형
table(
  ...  # 팩터로 해석할 수 있는 하나 이상의 객체
)

which.max(
  x   # 숫자 벡터
)


(x <- factor(c("a", "b", "c", "c", "c", "d", "d")))
table(x)             # 팩터의 각 레벨(level)별 빈도수를 구한다.

which.max(table(x))  # 가장 큰 값이 저장된 셀의 색인은 3
names(table(x))[3]   # 가장 큰 값이 저장된 셀의 이름


# 주변비율
prop.table(
  x,
  margin=NULL
)

x1 <- data.frame(x1=sample(1:5,20,replace = T),x2=sample(1:5,20,replace = T))

prop.table(table(x1))
prop.table(table(x1),1)
prop.table(table(x1),2)



##추출

sample(
  x,    # 표본을 뽑을 데이터 벡터. 만약 길이 1인 숫자 n이 지정되면 1:n에서 표본이 선택된다.
  size, # 표본의 크기
  replace=FALSE, # 복원 추출4 여부
  # 데이터가 뽑힐 가중치. 예를 들어, x=c(1, 2, 3)에서 2개의 표본을 뽑되 각 표본이 뽑힐 확률을
  # 50%, 20%, 30%로 하고자 한다면 size=2, prob=c(5, 2, 3)을 지정한다.
  # prob나 prob에 지정한 값의 합이 1일 필요는 없다.
  prob=NULL
)

sample(1:10, 5)
sample(1:10, 5, replace=TRUE)


## 층화추출

install.packages("sampling")
library(sampling)

sampling::strata(
  data,             # 데이터 프레임 또는 행렬
  stratanames=NULL, # 층화 추출에 사용할 변수들
  size,             # 각 층의 크기
  # - srswor : 비복원 단순 임의 추출(Simple Random Sampling WithOut Replacement)
  method=c("srswor")
)

(x <- strata(c("Species"), size=c(3, 3, 3), method="srswor", data=iris))
strata(c("Species"), size=c(3, 1, 1), method="srswr", data=iris)




###### 이산확률 분포

library(ggplot2)

# 난수 생성
RB = sample( c(0,1) , 400 , prob = c(0.4,0.6), replace=T)

ggplot(NULL) +
  geom_bar(aes(x = as.factor(RB), fill = as.factor(RB))) +
  theme_bw() +
  xlab("") + ylab("") +
  scale_x_discrete(labels = c("실패","성공")) +
  theme(legend.position = 'none')  

#이항분포 추출

# 동전을 5번 던졌을 경우 앞면이 나오는 횟수
rbinom(n=100,size=5,prob=0.5)
# n = 시도 횟수
# size = 동전을 던진 횟수
# prop = 성공할 확률

data.frame(n = rbinom(n=10,size=5,prob=0.5)) %>% ggplot(aes(x=n))+geom_bar()
data.frame(n = rbinom(n=30,size=5,prob=0.5)) %>% ggplot(aes(x=n))+geom_bar()
data.frame(n = rbinom(n=50,size=5,prob=0.5)) %>% ggplot(aes(x=n))+geom_bar()
data.frame(n = rbinom(n=100,size=5,prob=0.5)) %>% ggplot(aes(x=n))+geom_bar()
data.frame(n = rbinom(n=10000,size=5,prob=0.5)) %>% ggplot(aes(x=n))+geom_bar()

# 확률을 확인
dbinom(x=3,size=5,prob=0.5) #3번 앞면
dbinom(x=4,size=5,prob=0.5) #4번 앞면

# 누적 확률 확인
pbinom(q=2, size = 5, prob = 0.5) # 2 이하 성공
pbinom(q=3, size = 5, prob = 0.5) # 3 이하 성공


###############
#연속 확률 분포

# 구간으로 정의되는 분포
R = rnorm(n = 100000, mean = 0, sd = 1)

ggplot(NULL) +
  geom_histogram(aes(x = R, y= ..density..),binwidth = 0.2,fill = "white",col = 'black') +
  scale_y_continuous(expand = c(0,0),limits = c(0,0.5)) +
  scale_x_continuous(limits = c(-3,3)) + 
  xlab("")

# 정규분포

rnorm() # 평균과 분산에 해당하는 랜덤 샘플
dnorm() # 확률 밀도함수
pnorm() # 누적 분포함수
qnorm() # 분쉬수 함수

# 평균이 10이고 표준편차가 2인 샘플 30개가 필요해
rnorm(n=30, mean = 10, sd =2)



# 
dnorm(1.96,mean = 0, sd=1) # 1.96의 밀도함수는?
qnorm(0.975,mean = 0, sd=1) # 0.975 누적합수의 x축은?

#1.96까지의 누적 분포함순는?
pnorm(1.96)


# install.packages("reshape")
library(reshape)
library(dplyr)

k1 = c()
p1 = c()

for(k in seq(-15,15,by = 0.01)){
  p = dnorm(x = k,mean = 0,sd = 1)
  k1 = c(k1,k)
  p1 = c(p1,p)
}

k2 = c()
p2 = c()

for(k in seq(-15,15,by = 0.01)){
  p = dnorm(x = k,mean = 0,sd = 5)
  k2 = c(k2,k)
  p2 = c(p2,p)
}

DF = data.frame(
  k = k1,
  p1 = p1,
  p2 = p2
)

DF %>%
  gather("variable","value",p1:p2) %>%
  ggplot() +
  geom_line(aes(x = k, y = value, col = as.factor(variable))) +
  geom_vline(xintercept = 0,linetype = 'dashed') +
  theme(legend.position = 'none') +
  scale_y_continuous(expand = c(0,0))


x1 = rnorm(n = 1000, mean = 20, sd = 5)
x2 = scale(x1)

DF = data.frame(
  x1 = x1,
  x2 = x2
)

DF %>% 
  gather("variable","value") %>%
  mutate(variable = ifelse(variable == "x1", "비표준화","표준화")) %>%
  ggplot() +
  geom_density(aes(x = value, fill = variable), alpha = 0.4) +
  theme_bw() +
  theme(legend.position = c(0.8,0.6)) +
  xlab("") + ylab("") + labs(fill = "")


# 문제) 어느 실험실의 연구원이 어떤 식물로부터 하루 동안 추출하는 호르몬의 양은 평균이 30.2mg, 
# 표준편차가 0.6mg인 정규분포를 따른다고 한다. 어느 날 이 연구원이 하루 동안 추출한 호르몬의 양이 29.6mg 이상이고 
# 31.4mg 이하일 확률을 오른쪽 표준정규분포표를 이용하여 구한 것은?(2016년 9월 모의고사 가형 10번)

Z1 = (29.6-30.2) / 0.6
Z2 = (31.4-30.2) / 0.6

k1 = c()
p1 = c()

for(k in seq(-5,5,by = 0.01)){
  p = dnorm(x = k,mean = 0,sd = 1)
  k1 = c(k1,k)
  p1 = c(p1,p)
}

ggplot(NULL) +
  geom_line(aes(x = k1, y = p1)) +
  geom_area(aes(x = ifelse(k1 > -1 & k1 <  2, k1, 0), y = p1),fill = 'royalblue',
            alpha = 0.4) +
  theme_bw() +
  scale_x_continuous(breaks = seq(-5,5, by = 1)) +
  scale_y_continuous(expand = c(0,0),limits = c(0,0.45)) +
  xlab("") + ylab("")

pnorm(2,mean = 0, sd=1) - pnorm(-1, mean=0, sd=1)

#95% 신뢰 구간은?

ggplot(NULL) +
  geom_line(aes(x = k1, y = p1)) +
  geom_area(aes(x = ifelse(k1 > -1.96 & k1 <  1.96, k1, 0), y = p1),fill = 'royalblue',
            alpha = 0.4) +
  theme_bw() +
  scale_x_continuous(breaks = seq(-5,5, by = 1)) +
  scale_y_continuous(expand = c(0,0),limits = c(0,0.45)) +
  xlab("") + ylab("")

pnorm(1.96,mean = 0, sd=1) - pnorm(-1.96, mean=0, sd=1)




###### PT에 있는 문제 풀어보기
# [2015학년도 수능] 어느 연구소에서 토마토 모종을 심은 지 주가 지났을 때, 
# 줄기의 길이를 조사한 결과 토마토 줄기의 길이는 평균이 
# 30cm 표준편차가 2cm인 정규분포를 따른다고 한다. 
# 이 연구소에서 토마토 모종을 심은 지 주가 지났을 때, 
# 토마토 줄기 중 임의로 선택한 줄기의 길이가 27cm이상이고 32cm 이하일 확률을 
# 오른쪽 표준정규분포표를 이용하여 구한 것은? [3점]



#2
data(mtcars)
# mtcars 데이터에서 mpg는 평균 23이다 라고 말할 수 있는가?
# 가설검정하여라



##############################


## 추가적으로 알면 좋은 부분들

set.seed(1234) # 랜덤을 고정하는 방법
sample(1:6,10,replace = T)


# 중심극한 정리
z<-c()
for(i in 1:10){
  z <- c(z,round(mean(sample(1:6,6,replace = T)),2))
}

ggplot(NULL) +
  geom_bar(aes(x = as.factor(z), fill = as.factor(z))) +
  theme_bw() +
  xlab("") + ylab("") +
  theme(legend.position = 'none')  


z<-c()
for(i in 1:1000){
  z <- c(z,round(mean(sample(1:6,6,replace = T)),2))
}

ggplot(NULL) +
  geom_bar(aes(x = as.factor(z), fill = as.factor(z))) +
  theme_bw() +
  xlab("") + ylab("") +
  theme(legend.position = 'none')  
