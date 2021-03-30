# 데이터 분석가 _ james         \
#                                \
# 스크립트 실행(Run a script)    \
##  : Windows : 'Ctrl + Enter'   \
##  : MAC     : 'Command + Enter'\
#---------------------------------

#1. 상관관계분석(Correlation) :연속형 데이터로 진행한다. 범주형으로는 X


height<-c(164,175,166,185)
weight<-c(62,70,64,86)

cor(height,weight)
round(cor(height,weight),3)

cor.test(height,weight) #피어슨 상관계수분석. x,y변수 값 각각 입력필요. 데이터프레임평태 불가.

# install.packages("moonBook")
library(moonBook)
data(acs)
#install.packages("psych")
library(psych)
str(acs)
acs2<-acs[,c(1,6:9)]
cor(acs2)


#na가 존재할시 na 제외후 계산
cor(acs2,use="na.or.complete")

#산점도행렬
pairs.panels(acs2)


#install.packages("PerformanceAnalytics");  
library(PerformanceAnalytics)
#산점도행렬
chart.Correlation(acs2, histogram=TRUE, pch=19)

#cor.test: x,y두개 변수


#킹콩 data의 추가 -> 데이터 하나의 큰 영향
dat<-data.frame(
  a=c(15,20,25,27,31,25,23,23,42,12,34,23,40),
  b=c(50,55,52,52,56,54,62,56,70,46,43,50,54)
)
plot(dat$a,dat$b)
abline(lm(dat$b~dat$a))
cor(dat$a,dat$b)


#outlier 추가              #상관계수에서는 outlier영향을 많이 받기 떄문에 처리에 유의해야함. 
dat[14,]<-c(200,230)
plot(dat$a,dat$b)
abline(lm(dat$b~dat$a))
cor(dat$a,dat$b)

#heatmap expression
# install.packages("corrplot")
library(corrplot)

corrplot(cor(acs2,use="na.or.complete"))
corrplot(cor(acs2,use="na.or.complete"),method="square")
corrplot(cor(acs2,use="na.or.complete"),method="ellipse")
corrplot(cor(acs2,use="na.or.complete"),method="number")
corrplot(cor(acs2,use="na.or.complete"),method="shade")
corrplot(cor(acs2,use="na.or.complete"),method="color")
corrplot(cor(acs2,use="na.or.complete"),method="pie")


#cor의 비모수적인 표현들
#1. spearman
#2. kendall's tau
cor(height,weight)
cor(height,weight,method="spearman")
cor(height,weight,method="kendall")

?cor

############### 연습문제 ###############

data(iris)
#1. iris에서 연속형 데이터를 갖고 상관관계를 구하고 Sepal.Length와 가장 상관있는 변수는 무엇인가?
#(2가지 이상의 시각화를 그려보시오)
pairs.panels(iris[,1:4])

#####
data(mtcars)
head(mtcars)
#mpg에서 qesc까지의 변수를 갖고 상관관계를 구하시오


##################################

#2. 2 집단에대한 평균비교 t-test

t_data<-data.frame(
  group=c(1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2),
  score=c(100,100,80,50,40,90,20,50,50,70,30,40,30,70,30,40,30,60,30,60),
  age=c(80,20,30,70,90,20,30,60,50,50,20,30,20,20,25,10,13,12,11,10))

ggplot(t_data,aes(x=factor(group),y=score,fill=factor(group))) + geom_boxplot()

#정규성검정

#정규성 검정 -  shapiro
shapiro.test(t_data$score)


#등분산성 검정

t_data_1<-t_data[t_data$group==1,]
t_data_2<-t_data[t_data$group==2,]

var.test(t_data_1$score,t_data_2$score)

#t_test방법 2가지 존재

#1번 t.test방법
t.test(t_data_1$score,t_data_2$score,var.equal=T) #var.equal=T 가 기본값. F일 경우에는 써주어야 함.

#결과: 유의확률이 0.05보다 작아서 대립가설 채택(score 평균은 같은 수준이 아니다. )

#2번 t.test방법
t.test(score~group,data=t_data,var.equal=T)


#등분산이 아닐경우
var.test(t_data_1$age,t_data_2$age)
t.test(t_data_1$age,t_data_2$age,var.equal=F)



#대응 T-test의 수행(전/후비교) - paried=T를 붙여줌

before_op = c(137,119,117,122,132,110,114,117)
after_op = c(126,111,117,116,135,110,113,112)

t.test(before_op,after_op,paired=T)

#결과: 유의확률이 0.05보다 크므로 귀무가설 채택 (차이가 없다. 값은 3.5 차이 나지만, 통계쩍으로는 차이 없는 수준) 

mid = c(16, 20, 21, 22, 23, 22, 27, 25, 27, 28)
final = c(19, 20, 24, 24, 25, 25, 26, 26, 28, 32)

t.test(mid,final, paired=TRUE)



################## T검정 연습해보기 ###################

# 1
a = c(175, 168, 168, 190, 156, 181, 182, 175, 174, 179)
b = c(185, 169, 173, 173, 188, 186, 175, 174, 179, 180)

### 다음 데이터를 갖고 T검정을 하시오 (정규성 생략)

var.test(a,b)
t.test(a,b, var.equal=T)
#유의확률이 0.356으로 유의수준 0.05보다 크므로 채택. 두 집단의 차이는 없다. 
#(귀무가설: a집단과 b집단의 차이가 없다.)

# 2
data(mtcars)
# am 변수에 따라 mpg가 차이가 있는지 확인하시오

######################################################


#3.3개이상의 평균비교 시 분산분석 - Anova(Analysis of Variance)

#install.packages("laercio")

anova_data<-data.frame(
  group=c(1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3),
  score=c(50.5, 52.1, 51.9, 52.4, 50.6, 51.4, 51.2, 52.2, 51.5, 50.8,47.5, 47.7, 46.6, 47.1, 47.2, 47.8, 45.2, 47.4, 45.0, 47.9,46.0, 47.1, 45.6, 47.1, 47.2, 46.4, 45.9, 47.1, 44.9, 46.2))

ggplot(anova_data,aes(x=factor(group),y=score,fill=factor(group))) + geom_boxplot()

tapply(anova_data$score,anova_data$group,mean)
tapply(anova_data$score,anova_data$group,max)

#등분산성 test
bartlett.test(score~as.factor(group),data=anova_data)

#oneway.test
oneway.test(score~group,data=anova_data,var.equal = T)


?aov
a1<-aov(score~group,data=anova_data)
summary(aov(score~group,data=anova_data))



#사후분석
library(laercio)
LDuncan(a1, "group")


#group에 해당하는 부분이 문자형 이어야함
TukeyHSD(aov(score~as.character(group),data=anova_data))
plot(TukeyHSD(aov(score~as.character(group),data=anova_data)))



######################
#### 등분산이 아닐경우

anova_data2<-data.frame(
  group=c(1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3),
  score=c(70, 30, 20.3, 85.3, 50.6, 51.4, 51.2, 52.2, 51.5, 50.8,47.5, 47.7, 46.6, 47.1, 47.2, 47.8, 45.2, 47.4, 45.0, 47.9,46.0, 47.1, 45.6, 47.1, 47.2, 46.4, 45.9, 47.1, 44.9, 46.2))

#등분산성 test
bartlett.test(score~as.factor(group),data=anova_data2)


#oneway.test
oneway.test(score~group,data=anova_data2,var.equal = F)

a2<-aov(score~group,data=anova_data2)
summary(aov(score~group,data=anova_data2))

#사후분석
library(laercio)
LDuncan(a2, "group")

#group에 해당하는 부분이 문자형 이어야함
TukeyHSD(aov(score~as.character(group),data=anova_data2))
plot(TukeyHSD(aov(score~as.character(group),data=anova_data2)))


################## F검정 연습해보기 ###################
data(iris)
#1. iris에서 Species마다 Sepal.Width의 차이가 있는지 확인하시오
# 사후 검정과 해석을 적으시오



#2 mtcars데이터에서 gear따라 mpg의 차이가 있는지 확인하시오
# 사후 검정과 해석을 적으시오


#######################################################

#문자형 데이터분석
data(acs)
head(acs)

# 성별과 비만은 연관이 있을까?

table(acs$sex,acs$obesity)

acs %>% 
  dplyr::count(sex,obesity) %>%
  ggplot(aes(x=sex,y=n,fill=obesity)) + geom_bar(stat="identity",position = "dodge")


chisq.test(acs$sex,acs$obesity,correct = F)
chisq.test(table(acs$sex,acs$obesity))

# correct?
# 비 연속적 이항분포에서 확률이나 비율을 알기 위하여 연속적 분포인
# 카이제곱 분포를 이용할 떄는 연속성을 가지도록 비연속성을 교정해야할 필요하 있을 떄 사용하는 방법
# 보통 2X2 행렬에서 자주 사용함


install.packages("gmodels")
library(gmodels)

CrossTable(acs$sex,acs$obesity,chisq=T,prop.t=F)
CrossTable(table(acs$sex,acs$obesity))
0.089 + 0.175 + 0.045 + 0.088

# 일반횟수
# 카이 제곱 ( 기대치 비율 )
# 행을 기준으로 비율 값 ( 가로로 읽는다. )
# 컬럼을 기준으로 비율 값 ( 세로로 읽는다. )
# 전체를 기준으로 비율 값

# 성별과 비만은 연관이 있을까?

table(acs$sex,acs$smoking)

acs %>% 
  dplyr::count(sex,smoking) %>%
  ggplot(aes(x=sex,y=n,fill=smoking)) + geom_bar(stat="identity",position = "dodge")

chisq.test(acs$sex,acs$smoking,correct = F)
chisq.test(table(acs$sex,acs$smoking),correct = F)


#자료 생성
dat <- matrix(c(20,24,15,5),ncol=2)
row.names(dat) <- c("흡연","비흡연")
colnames(dat)<- c("정상","비정상")
dat



xtab <- matrix(c(384, 536, 335,951, 869, 438),nrow=2)
dimnames(xtab) <- list(
  stone = c("yes", "no"),
  age = c("30-39", "40-49", "50-59")
)

colSums(xtab)
prop.trend.test(xtab[1,],colSums(xtab))
mosaicplot(t(xtab),col=c("deepskyblue", "brown2"))
# 나이 비율이 동일하지 않다


################## 카이제곱 연습해보기 ###################
# 1

data("survey")
# survey 데티어에서 Sex변수와 Smoke가 연관이 있는지 검정하여라
# 시각화 포함


# 2
delivery = read.csv('SKT.csv', fileEncoding='UTF-8')
head(delivery)
# 요일별 업종의 차이가 있는지 검정하여라


#######################################################
