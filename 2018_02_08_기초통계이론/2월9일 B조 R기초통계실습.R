# [1]. R 기초통계량 함수.

#프로야구 데이터
bp<-read.csv('bp2014.csv')
head(bp)
x<-bp$salary #야구선수들의 연봉을 x로 저장.
#1.평균 : mean()
mean(x,trim=0,na.rm=F)

# x : 데이터
# trim : 절삭평균의 제외할 비율
# na.rm : 결측값(NA)값의 제외 유무(TRUE이면 결측값 제외)

#2.중앙값 : median()
median(x, na.rm=F)

#3.최빈값
#R에는 최빈값을 구하는 함수가 없으므로 만들어 사용.

Mode<-function(x) {
  ux<-unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

sort(table(x),decreasing=TRUE)



### 퍼짐정도 ###
#4.분산,표준편차 : var(),sd()
var(x,na.rm = FALSE)
sd(x)

# x, y : R 개체(벡터 또는 행렬, 데이터 프레임)
# na.rm : 결측값(NA)값의 제외 유무(TRUE이면 결측값 제외)


#5.최대값,최소값 : max(), min()
max(x, na.rm=FALSE)
min(x, na.rm=FALSE)

#6.range() : 범위(최소값,최대값)
range(x)
min(x)
max(x)


#7.분위수 함수 : quantile()

quantile(x, probs=c(0,0.25,0.5,0.75,1), na.rm=FALSE) 
quantile(x, probs=seq(0,1,0.25), na.rm=FALSE) 

# probs : 구하고자 하는 분위수 비율

#8.요약값 출력 : summary()
# • 최소값, Q1, 중앙값, 평균, Q3, 최대값

summary(x)


### 확률분포의 비대칭 정도 ###
#9. 왜도,첨도 : 'fBasics' 패키지 사용
#R에 왜도와 첨도를 위한 함수가 내장되어 있지 않기 때문에 별도 패키지(fBasics)를 설치해야 합니다.

install.packages('fBasics')
library(fBasics)

hist(x)

skewness(x) # 왜도 : 값이 매우 왼쪽에 치우쳐 있음.

#왜도 -정규분포 평균과 일치하면 왜도값 0
#        평균보다 오른쪽으로 값이 치우쳐 있으면 음수
#        평균보다 왼쪽으로 값이 치우쳐 있으면 양수

kurtosis(x) # 첨도 : 관측값이 정규분포보다 뾰족한가 아닌가를 가늠하는 척도.
# 0보다 작으면 정규분포보다 완만, 0보다 크면 정규분포보다 뾰족한 모양.
#값이 27.1153 이므로 매우 뾰족.



############################
### 예제 ###############

#mtcars 데이터 내의 disp 변수를 사용.
V1<-mtcars$disp

### 최빈값 함수 생성 ###
Mode<-function(x) {
   ux<-unique(x)
   ux[which.max(tabulate(match(x, ux)))]
   }

### 대표값 ###
mean(V1)
median(V1)
mean(V1,trim=0.1)
Mode(V1)

### 산포도 ###
max(V1)-min(V1) # 범위
var(V1) # 분산
sd(V1) # 표준편차
sqrt(var(V1)) # 표준편차
quantile(V1,probs=c(0.25,0.5,0.75)) # 사분위수
IQR(V1) # 사분위범위
sd(V1)/mean(V1) # 변동계수

### 비대칭도 ###
skewness(V1) # 값이 왼쪽으로 조금 치우쳐져있음.
kurtosis(V1) # 0보다 작으므로 정규분포보다 완만함.

############################################################################################
# [2]. 범주형 자료 분석

# (1) 적합도 검정(goodness of fit test) : 관측값들이 어떤 이론적 분포를 따르고 있는지를 검정. 한 개의 요인을 대상으로 함 
# (2) 독립성 검정(test of independence) : 서로 다른 요인들에 의해 분할되어 있는 경우 그 요인들이 관찰값에 영향을 주고 있는지 아닌지, 요인들이 서로 연관이 있는지 없는지를 검정. 두 개의 요인을 대상으로 함.



#1. 적합도 검정
# => k개의 범주 (혹은 계급)을 가지는 한 개의 요인(factor)에 대해서 어떤 이론적 분포를 따르고 있는지를 검정하는 방법입니다. 

##  가설  ##

# [귀무가설 H0] : 관측값의 도수와 가정한 이론 도수(기대 관측도수)가 동일하다
# => ( p1 = p10, p2 = p20, ..., pk = pko )

# [대립가설 H1] : 적어도 하나의 범주 (혹은 계급)의 도수가 가정한 이론 도수(기대 관측도수)와 다르다
# => (적어도 하나의 pi는 가정된 값 pi0과 다르다)


## 예제 문제
#유전학자 멘델은 콩 교배에 대한 유전의 이론적 모형으로서 잡종비율을 A : B : C = 2 : 3 : 5 라고 주장하였다.
#이 이론의 진위를 가리기 위해 두 콩 종자의 교배로 나타난 100개의 콩을 조사하였더니 A형 19개, B형 41개, C형 40개였다.
#이러한 관찰값을 얻었을 때 멘델 유전학자의 이론이 맞다고 할 수 있는지를 유의수준 α = 0.05 에서 검정하여라.

ob <- c(19, 41, 40)
prob <- c(0.2, 0.3, 0.5)

chisq.test(ob,p=prob)

#P-value가 0.04776 이므로 유의수준 α 0.05보다 작으므로 귀무가설 H0를 기각하고 대립가설 H1을 채택한다.
#멘델이 주장한 콩의 잡종비율 이론적 분포는 적합하지 않다"고 판단.



##########################################################
# [3] 범주형 데이터의 이원분할표 
X.Table<-matrix(c(54,3,7,12),ncol=2)
rownames(X.Table)<-c("p.buckled","p.unbuckled")
colnames(X.Table)<-c("c.buckled","c.unbuckled")
dimnames(X.Table)=list(c("p.buckled","p.unbuckled"),c("c.buckled","c.unbuckled"))
X.Table



#####################
# 주변분포 작성하기 #

#행 주변분포

margin.table(X.Table, margin=1) # 행 주변분포
rowSums (X.Table, na.rm = FALSE) # 행 주변분포

#열 주변분포
margin.table(X.Table, margin=2) # 열 주변분포
colSums (X.Table, na.rm = FALSE) # 열 주변분포

#행, 열 평
colMeans(X.Table, na.rm = FALSE)
rowMeans(X.Table, na.rm = FALSE)


# 교차표의 % #
prop.table(X.Table) # 전체 %
prop.table(X.Table, margin=1) # 행 %
prop.table(X.Table, margin=2) # 열 %


# 퍼센트 교차표 #
addmargins(prop.table(X.Table)) # 전체 %


########################################################
# [4] 독립성 검정

# 두 개의 범주형 변수간에 관련성에 대해 알아보고자 할때
# • 두 변수간의 독립성여부에 대한 검정
# H0 : 두 범주형 변수간에 독립이다.
# H1 : 두 변주형 변수간에 독립이 아니다

# 카이제곱 검정을 통해 통계적으로 연관성,독립 검정

# 독립성 검정 # 
X<-matrix(c(54,63,45,56), ncol=2)
dimnames(X)=list(c("고수입","저수입"),c("고등학교_졸업","고등학교_미졸업"))
chi.Result<-chisq.test(x)
chi.Result

#독립성 검정에서 해당 통계량 출력 가능#
attributes(chi.Result)


########################################################
# [5] 정규성 검정.
#• 가설
# H0 : 정규분포를 따른다
# H1 : 정규분포를 따르지 않는다

##shapiro wilk normality test
data<-sample(50:100,100,replace=TRUE)
hist(data,col="yellow",las=1)
shapiro.test(data)

data2<-rnorm(100,50,10)
hist(data2,col="green",las=1)
shapiro.test(data2)

##히스토그램과 qqplot
hist(bp$salary)
hist(bp$weight)


qqnorm(bp$salary)
qqnorm(bp$weight)

########################################################
# [6] t-검정, F-검정
##단일표본 t-test(특정 집단의 평균이 어떤 숫자와 같은지 다른지를 비교)
#먼저 특정집단의 데이터가 정규성을 만족해야하
t.test(x,mu=?)

##독립표본 t-test(서로 다른 두개의 그룹 간 평균의 차이가 유의미한가? )
#한화와 넥센 선수들의 평균 연봉은 차이가 있을까?

A <- bp$salary[bp$team == "한화"]
B <- bp$salary[bp$team =="넥센"]

# t-test를 위해서는 등분산성과 정규성이 만족되어야 한다.
# 등분산성 확인을 위해 F 검정을 실시
var.test(A,B)

#등분산성 확인 후 t-test
t.test(A,B,paired=F,var.equal=T,alternative=c("two.sided"))

##  paired의 경우 대응표본 t-test즉 집단의 전 후 차이를 비교하기위해 사용 여기서는 F
##  var.equal은 분산 동일성 여부
##  alternative =c("two.sided","less","greater") 양측검정과 단측검정
##  신뢰범위는 디폴트 0.95로 저장


######################################################################################
#[7] 일원배치 분산분석(One way Anova)
## 2개의 모집단에 대한 평균을 비교 분석하는 통계적 기법으로 t-test를 사용했다면 
## 비교하고자 하는 집단이 3개 이상일 경우에는 분산분석을 이용
## One way anova 는 1개의 요인내에 요인수준들의 집단간 평균차이 비교


analysis<-aov(대상변수~그룹변수,data=데이터명)  #그룹변수는 factor형이어야한다
summary(analysis) #분산분석의 요약값 출력

## position별로 salary의 차이가유의한가?

str(bp)
unique(bp$position)
analysis<- aov(salary~position,data=bp)
summary(analysis)

####################################################################################
#[8] 이원배치 분산분석(Two way Anova)

anova(lm(formula))
#– Formula
#• 종속변수~요인1+요인2 : 반복이 없는 경우
#• 종속변수~요인1*요인2 : 반복이 있어 교호작용까지 검정하는 경우

##position 과 team에 따라 salary가 다를까?
analysis<-aov(대상변수~그룹변수1+그룹변수2,data=데이터명)
analysis<-aov(salary~position+team,data=bp)
analysis2 <- aov(salary~position*team,data=bp)
str(bp)
summary(analysis2)

