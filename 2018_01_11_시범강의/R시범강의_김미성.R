
# R script에서 실행은 우측 상단의 'Run' 또는 ctrl+R


######################### 제 3장 데이터 타입 #########################

# 변수에 값을 할당할 때는 <- 또는 = 를 사용한다
a <- 2
b <- "hello"

# class() : 타입 판별 (numeric, character, logical 등)
class(a)
class(b)

# 변수명 주의 (첫 글자는 문자 또는 '.'으로 시작해야 하며, '.'으로 시작한다면 '.' 뒤에는 숫자가 올 수 없다.)
a1 <- 1
2a <- 1
.x <- 1  
.2 <- 1

# 변수 목록 및 삭제
ls()               # 현재 생성된 변수들을 보여줌
rm( list = ls() )  # 모든 변수 제거


# NA(Not Available) : Missing Value
a <- NA
is.na(a)  # a가 NA이면 TRUE를 반환
a + 1     # NA는 연산 불가


### R의 기본형은 벡터 (스칼라는 길이가 1인 벡터로 볼 수 있다.)

x <- c(1,2,3)  # c() 안에 값들을 나열

# 벡터의 인자들은 한 가지 타입이어야 한다. 만약 다를 경우, 한 가지 타입으로 자동 변환된다.
x <- c(1,2,"hello")
x  # 1, 2는 numeric인데 character로 변환됨
class(x)

# 벡터 생성하는 다른 방법들
seq(1, 10, 1)  # sequance (from, to, by)
x <- 1:10      # 1부터 10까지의 숫자
rep ( c(1,2), 5 )        # c(1,2)를 5번 반복
rep( c(1,2), each = 5 )  # 1, 2를 각각 5번 반복

# Index
x <- c("a", "b", "c", "d")
x[1]    # R에서 인덱스는 1부터 시작
x[-2]   # 두번째 값을 제외
x[1:3]  # 벡터도 가능
length(x)  # 벡터의 길이

# 벡터의 연산
"a" %in% c("a", "b", "c")  # 값이 벡터에 포함되어 있는가
x <- 1:5
x+1  # 각각의 값에 연산을 수행
sum(x)
mean(x)

# NA 처리
x <- c(1:4, NA); x
mean(x)
mean(x, na.rm=T)  



## factor : 범주형 변수를 위한 데이터 타입

sex <- factor ("m", level = c("m", "f"))  # 일반적으로 첫번째 argument는 데이터, 그 뒤는 옵션 (?factor 참조)
                                          # 옵션 이름을 안 쓰고 순서만 맞춰도 됨
sex
factor("m") # level을 지정하지 않으면 데이터가 가진 level만을 표시
levels(sex)   # level만 확인하고 싶을 때
nlevels(sex)  # level의 개수
class(sex)  # argument가 벡터일 때는 값의 타입(numeric, character, logical 등), 그 외는 데이터 타입(factor, matrix, list, data.frame 등) 반환


## list : 다양한 타입의 값들을 혼합해서 저장 가능 (분석 결과가 list 형태로 출력되는 경우가 많다.)

x <- list ( name ="foo", height =c(1, 3, 5))  # character 벡터와 numeric 벡터 혼합
x

# list 내의 데이터 접근
x$name  # x라는 list 안의 name이라는 데이터를 가져옴
x <- 1:5; y <- 6:10  # ex) 선형회귀분석
lm <- lm(y ~ x)
lm$fitted.values     # $를 쳤을 때 나오는 것들이 list 요소들


## matrix

A <- matrix( 1:6 , nrow = 2 )           # nrow : 행의 개수, ncol : 열의 개수 (둘 중 하나만 쓰면 됨)
A <- matrix( 1:6 , nrow = 2, byrow=T )  # byrow=T : 행부터 채우기 (T=TRUE)

# 행렬에서의 Index
A[1,2]  # [행, 열]
A[1, ]  # 1행을 모두 가져옴
nrow(A); ncol(A)

# 행렬의 연산 (다중회귀분석에서 자주 쓰이는 것)
t(A)        # transpose
A %*% t(A)  # 행렬곱(내적)
solve(A %*% t(A))    # 역행렬


### data.frame (R에서 가장 중요한 데이터 타입)

# 행렬과 마찬가지의 모습을 하고 있지만 행렬과 달리 다양한 변수, 관측치(observations), 범주 등을 표현하기 위해 특화되어있다.
# 여러 가지 데이터 타입을 혼용해서 사용할 수 있어, 데이터를 불러오면 기본적으로 data frame의 형식으로 저장됨
df <- data.frame( x = c(1, 2, 3, 4, 5), y = c(2, 4, 6, 8, 10), z = c('M', 'F', 'M', 'F', 'M') )
df

# 데이터 프레임 내의 접근
df$x     # list와 같은 접근
df[,1]   # matrix와 같은 접근
df[1,2]
df[,"x"]  

# 데이터 프레임 살펴보기
dim(df)             # 5개의 observation과 3개의 변수 (5행 3열)
head(df); tail(df)  # 앞 6개와 뒤 6개 observation을 보여줌
names(df)           # 변수들의 이름

# NA 처리
df[2,2] <- NA
complete.cases(df)  # 각 행이 NA를 포함하고 있지 않는지 판별
na.omit(df)         # NA가 포함된 항을 제거



######################### 제 4장 제어문, 연산, 함수 #########################

### if문

a <- 1

if ( a==1 ) {          # a가 1인지 판별할 때 == 을 씀
  print('TRUE')
  print('hello')
} else {               
  print('FALSE')
  print('world')
}

if ( a!=1 ) {          # !는 not을 의미
  print('FALSE')
}

ifelse( a==1, 'TRUE', 'FALSE' )


### for문

for( i in 1:10 ) {
  print(i)
}

### while문

i <- 0

while(i < 10) {
 print(i)
 i <- i + 1
}



### fuction

# '함수명 <- function(인자, 인자, ...) { 함수 본문 }'

f <- function(x) {
  if (x==1) {
   return("T")
  } else {
   return("F")
  }
}

f(1)
f(2)

# return()이 생략된다면 함수 내 마지막 문장의 반환값이 함수의 반환값이 된다.



## Scope : 코드에 기술한 변수 등을 지칭하는 이름이 어디에서 사용 가능한 지를 정하는 규칙

# 콘솔에서 변수를 선언하면 모든 곳에서 사용 가능한 변수가 된다.
n <- 1
f <- function() {
 print(n)
}
f()

# 함수 내부에서 변수 이름이 주어졌을 때 그 변수를 찾는 범위는 함수 내부가 우선된다.
n <- 100
f <- function() {
 n <- 1
 print(n)
}
f()

# 함수 내부에서 정의한 이름은 바깥에서 접근할 수 없다.
rm( list = ls() )
f <- function() {
 x <- 1
 print(x)
}
f()
x





##### Quiz


# 1. sum() 함수와 똑같은 기능을 하는 함수를 for문을 이용하여 작성하시오.


# 2. which.max() 함수와 똑같은 기능을 하는 함수를 for문, if문을 이용하여 작성하시오.

x<-c(2,5,3,1,4)
which.max(x)  # max 값의 index를 반환해주는 함수

