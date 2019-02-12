##################### 5장 : 데이터조작I ######################
#R은 다른 언어에 비해 속도가 느리다는 단점 
#-> for문 같은 루프 보다는 벡터로 처리하는 방식을 사용하거나
#-> 속도가 빠른 다양한 함수를 쓰는 것이 속도 높이는데 좋다.

################ 5-1. iris 데이터 ###############
#주로 테스트할 때 많이 사용되는, 내장되어 있는 데이터

head(iris) #앞에서부터 6개의 데이터 확인
str(iris) #구조 확인

iris3 #3차원 데이터
head(iris3)
str(iris3)
class(iris3)

?datasets
library(help=datasets) #데이터 셋 목록 살펴볼 수 있음

################ 5-2. 파일 입출력 ################
#csv파일 입출력
getwd() #현재 설정된 디렉토리 확인 
setwd("C:/Users/User/Desktop/boaz") #위치 설정

x<-read.csv("a.csv") #파일 불러오기
x
str(x)

#factor -> 문자열로의 변환
#방법 1
x$name<-as.character(x$name) # name 열을 문자열로 변환
str(x) #chr로 변환됨을 볼 수 있음
#방법 2
x<-read.csv("a.csv",stringsAsFactors = FALSE) # 처음부터 factor 말고 문자열로 받아들이기
str(x) #chr로 변환됨을 볼 수 있음

#header 행이 없는 파일
x<-read.csv("b.csv"); x #header=TRUE가 기본 옵션
x<-read.csv("b.csv", header=FALSE); x
names(x)<-c("id","name","score"); x #header의 이름을 지정

x<-read.csv("c.csv", stringsAsFactors = FALSE); x
str(x) # NIL을 문자열로 인식하여 나머지 숫자 변수도 문자열로 읽어버림

x<-read.csv("c.csv",stringsAsFactors = FALSE, na.strings = c("NIL")) # NIL을 NA로 가져옴
x
str(x) # 변수들이 숫자형으로 변환
is.na(x$score) # 가운데 변수 값이 NA인 것을 확인

x
write.csv(x, "test.csv", row.names=F) #행 번호를 저장하지 않도록 함
write.csv(x, "test1.csv", row.names = T)

################ 5-3. save(), load() #################
#workspace 저장
x<-1:5
y<-6:10
save(x,y,file="xy.RData") # 두 벡터를 xy.RData에 저장

rm(list=ls()) # 모든 객체 삭제 
x
y # 삭제된 것을 확인
load("xy.RData")
x
y # 객체를 불러들인 것을 확인

################ 5-4. rbind(), cbind() ################
#데이터를 합쳐 새로운 행렬 혹은 데이터 프레임을 생성
#rbind : 행 추가
#cbind : 열 추가

rbind(c(1,2,3),c(4,5,6)) # [1,2,3]의행과 [4,5,6]의 행을 합침
x<-data.frame(id=c(1,2),name=c("a","b"),stringsAsFactors = F); x
y<-rbind(x,c(3,"c")); y # x 데이터프레임에다가 id열에 3, name열에 c 추가/[3,c] 행을 추가

cbind(c(1,2,3),c(4,5,6)) # [1,2,3]의 한 열과 [4,5,6]의 한 열을 합침
y<-cbind(x,greek=c('alpha','beta')); y # 3열에다가 greek열로 alpha, beta추가
str(y) # greek 열의 데이터가 factor임을 확인할 수 있음

y<-cbind(x,greek=c('alpha','beta'),stringsAsFactors=F) #chr로 변호
str(y) #변환됨

################ 5-5. apply 함수들 ##############
#5-5-1. apply(행렬, 방향, 함수), 방향=1은 행, 2는 열
# 행렬의 행 또는 열 방향으로 특정 함수를 적용하는 데 사용됨

d<-matrix(1:9,ncol=3); d
apply(d,1,sum) # 방향의 숫자가 1이므로 각 행 안에서의 합을 구함
apply(d,2,sum) # 숫자가 2이므로 각 열 안에서의 합을 구함

class(iris)
head(iris)
# apply()를 사용해 iris 데이터에서 각 열의 합을 구해보자
apply(iris[,1:4], 2, mean)
#간단히 colMeans 함수를 이용해 구현 가능
colMeans(iris[,1:4])

#5-5-2 lapply(X,함수)
#X는 벡터, 리스트,데이터프레임. 함수는 각 요소에 적용할 함수
result<-lapply(1:3,function(x){x*2}) # 1,2,3으로 구성된 벡터에 각각의 숫자에 2배를 한 값을 구하는 함수
result # 결과는 리스트로 반환됨
unlist(result) # 함수 결과를 벡터로 변환

x<-list(a=1:3,b=4:6); x
lapply(x,mean) # a에 1,2,3 b에 4,5,6이 있는 리스트에서 각 변수마다 평균 계산

head(iris)
lapply(iris[, 1:4],mean) # 데이터프레임에도 lapply() 적용가능
unlist(lapply(iris[, 1:4],mean))

colMeans(iris[, 1:4]) # colMeans로 바로 계산도 가능

# 데이터 프레임-> 리스트 -> 데이터 프레임
# unlist로 리스트를 벡터로 변환 > matrix()로 벡터를 행렬로 변환
# > as.data.frame()을 이용해 행렬을 데이터프레임으로 변환
# > 마지막으로 names()를 이용해 리스트로부터 각 변수명을 얻어 데이터 프레임 각 열에 부여
d<-as.data.frame(matrix(unlist(lapply(iris[, 1:4],mean)),ncol=4,byrow=TRUE))
d

# do.call(호출할 함수, 파라미터), 단 속도가 느림.
data.frame(do.call(cbind, lapply(iris[, 1:4], mean)))
class(do.call(cbind, lapply(iris[, 1:4], mean)))
# lapply가 반환한 값들을 새로운 데이터 프레임으로 합치기 위해 cbind 이용
# do.call를 사용해 lapply()결과 리스트의 요소 하나하나를 cbind()의 파라미터로 넘겨줌

# 5-5-3. sapply(X, 함수), 결과를 리스트가 아닌 행렬이나 벡터로 반환
lapply(iris[, 1:4], mean) # 리스트로 결과 반환
class(lapply(iris[, 1:4], mean))
sapply(iris[, 1:4], mean) # 벡터로 결과 반환
class(sapply(iris[, 1:4], mean))

x<-sapply(iris[, 1:4], mean) # 벡터로 반환

as.data.frame(x) # sapply()에 의해 반환된 벡터는 as.data.frame()을 사용해 데이터 프레임으로 변환 가능
as.data.frame(t(x)) # 벡터를 t(x)로 전치시켜야 우리가 일반적으로 원하는 형태로 변환
sapply(iris, class) # 각 열에 저장된 데이터의 클래스 확인

y<-sapply(iris[, 1:4], function(x){x>3}) # sapply로 주어진 함수의 출력이 여러개라면 행렬이 반환됨
class(y) # 행렬이 반환이 된 것을 확인할 수 있음
head(y)

# 5-5-4. tapply(데이터, 색인, 함수)
# 색인(index)은 어느 그룹인지 표현하기 위한 factor형 데이터
# 그룹별 처리에 사용. 각 데이터가 속한 그룹별로 주어진 함수를 수행
tapply(1:10, rep(1,10), sum) #1부터 10까지 동일한 index 부여하고, 그룹 1에 대한 합을 구함

tapply(1:10, 1:10 %% 2 == 1, sum) # 짝수합과 홀수합을 각각 구함, %%:나머지

tapply(iris$Sepal.Length, iris$Species, mean) #Species 별 Sepal.Length 평균

# 5-5-5 mapply(함수, 인자1, 인자2,,,,)
# sapply()와는 달리 다수의 인자를 함수에 넘김

mapply(sum, 1:3, 4:6, 7:9)

mapply(mean, iris[, 1:4]) # 각 컬럼 별 평균 구하기

################ 5-6. doBy 패키지 ###############
install.packages("doBy")
library(doBy)
#doBy : summaryBy(), orderBy(), splitBy(), sampleBy()
# summary() :간단한 통계 분석, 요약
summary(iris) 

# summaryBy() : 특정 조건에 따라 요약
summaryBy(Sepal.Width ~ Species, iris)
summaryBy(Sepal.Width + Sepal.Length ~ Species, iris) # Sepal.width와 Sepal.Length를 Species에 따라서 살펴보기
# 'Sepal.Width + Sepal.Length ~ Species' 부분을 formula라고 하고 처리할 데이터를 수식으로 표현하는 것
# Sepal.Width와 Sepal.Length를 +로 연결해 이 두가지에 대한 값을 차례로 열으로 놓고, 각 행에는 Species를 배열하기 위해 ~Species

# orderBy() : 데이터를 정렬
orderBy(~ Sepal.Width, iris) # Sepal.Width 오름차순 
head(orderBy(~ Sepal.Width, iris)) # Sepal.Width 오름차순 

orderBy(~ Species + Sepal.Width, iris) # 모든 데이터를 Species, Sepal.Width 순으로 정렬 먼저 Species로 정렬된 후 Sepal.Width로
head(orderBy(~ Species + Sepal.Width, iris))

order(iris$Sepal.Width) # R에 기본적으로 내장된 order()함수. 주어진 값들을 정렬했을 때의 색인을 순서대로 반환.
iris[order(iris$Sepal.Width),]
head(iris[order(iris$Sepal.Width),])

# sampleBy()
sampleBy(~Species, frac=0.1, data=iris) #10%확률로, 임의로 샘플추출

#sample() : 주어진 데이터에서 임의로 샘플을 추출, 중복 등 옵션설정가느
sample(1:10, 5) # 1~10중 랜덤하게 5개
iris[sample(NROW(iris),5),] 
# NROW(iris)는 150

################ 5-7. split() ##############
#split(): 데이터를 분리
split(iris, iris$Species)   #species별로 분리
split(iris, iris$Sepal.Length)
class(split(iris, iris$Sepal.Length))

#species별로 sepal_width를 분리한뒤 그 값들의 평균값 계산
lapply(split(iris_data$sepal_width, iris_data$species), mean) 

################ 5-8. subset() ##################
#조건에 맞는 부분집합을 도출

#versicolor 종만 분류
subset(iris, Species =="versicolor")

#특정 column만 추출
#versicolor종 중에서 length열만 추출
subset(iris, select=c((Species =="versicolor"), Sepal.Length))

#특정 column 제외
#versicolor종 중에서 sepal_length열만 제외한뒤 추출
subset(iris, select=-c((Species =="versicolor"), Sepal.Length))

################ 5-9. merge() #############
#키 값을 기준으로 정렬한 뒤 합친다는 점에서 단순 결한인 cbind()와는 다르다
height = data.frame(name =c("A", "B", "C"), height = c(170, 160, 180))
weight = data.frame(name = c("B", "C", "A"), weight =c (60, 80, 70))
height; weight

cbind(height, weight)
merge(height, weight)

weight = data.frame(name=c("A", "D"), weight=c(60, 80))
merge(height, weight)
merge(height, weight, all=TRUE)

################ 5-10. sort(), order() ################
#length기준으로 정렬
sort(iris$Sepal.Length)

#내림정렬
sort(iris$Sepal.Length, decreasing=TRUE)
#오름정렬
sort(iris$Sepal.Length, decreasing=FALSE)

#order은 index값을 return 한다
x = c(50, 40, 10, 20, 30)
#작은값 기준
sort(x)
order(x)
#x의 순서는 x[3],x[4], x[5], x[2], x[1]
x[order(x)]
#큰값 기준
order(-x)
x[order(-x)]

#length와 width순으로 iris 값 order
head(iris[order(iris$Sepal.Length, iris$Sepal.Width), ])

################ 5-11. with(), within() ###########
#with(data, expresstion)를 사용하면 data 혹은 리스트와 같은 동일한 자료에 접근하여 조작을 동시에 수행할 수 있다.
head(iris)
summary(iris$Species)
with(iris, summary(Species))

#within은 데이터 수정시 사용된다
x=data.frame(val=c(10, 20, 30, 30, 30, NA, 40, 40, NA, 50, NA))
median(x$val,na.rm=T)
#NA값을 median로 치환
x=within(x, {val=ifelse(is.na(val), median(val, na.rm=TRUE), val)})
x

################ 5-12. attach(), detach() #########
#attach()를 사용하면 데이터에 바로 접근이 가능하다
#attach()를 통해 수정하는 경우 원 데이터값은 변형되지 않는다.
Sepal.Length
attach(iris)
Sepal.Length
detach(iris)
Sepal.Length

################ 5-13. which(), which.max(), which.min() ######
x=c(20,30,40,50,60,70,80)
#which()함수는 index값을 return 한다
which(x%%4 ==0)
#return 된 index값을 이용하여 실제 리스트값 출력
x[which(x%%4 ==0)] #4로 나누어지는 값 출력

#마찬가지로 which.min()은 최소값을 which.max()는 최대값의 index를 return 한다
which.max(x)
x[which.max(x)]

which.min(x)
x[which.min(x)]


################ 5-14. aggregate() #############
#aggregate(데이터, 조건, 함수) 또는 aggregate(formula,데이터, 함수)
#일반적인 그룹별 연산을 수행
aggregate(Sepal.Width~Species, iris, mean)

################ 5-15. stack(),unstack() ############
x = data.frame(Medication = c("A-1", "A-2", "A-3"), control=c(10, 20, 30), experiment=c(15, 23, 33));x
st_x=stack(x)
st_x

summaryBy(values ~ ind, st_x)
unstack(st_x, values~ind)




################ quiz ############
# R에 내장되어있는 iris 데이터를 이용하여
# iris의 종류(Species)별 꽃잎의 너비(Petal.Width)를 기준으로 내림차순으로 정렬하고,
# 이를 각 새로운 데이터셋(setosa_petal, versicolor_petal, viginica_petal)에 저장하시오.
# 단, 새로운 데이터셋에는 꽃잎의 너비(Petal.Width)와 꽃잎의 길이(Petal.Length)를 저장한다.