results<-read.csv("http://www.openwith.net/wp-content/uploads/2016/08/sms_results.csv")
head(results) #predict_type 이 ham 일때 prob_spam 0에 가까움. 반대의 경우 1에 가깝다.

head(subset(results,actual_type!=predict_type)) #results 에서 예측값과 측정값이 다른 예제만 보여줌

#(1)results로 confusion matrix(혼돈행렬)만들어 (2)모델 평가하기
#(1)혼돈행렬 만드는 방법
#방법1) table()
#방법2) CrossTable()
#방법3) confusionmatrix()
#(2)평가 방법
#방법1)confusion matrix로부터 나온 각종 통계량 ex)정확도,정밀도,재현율 등등
#방법2)ROC 커브
#방법3)카파통계량

#(1)혼돈행렬 만들기 
#table()
table(results$actual_type,results$predict_type,dnn = c("actual","predict"))
#CrossTable()
#install.packages("gmodels")
library(gmodels)
CrossTable(results$actual_type,results$predict_type)
#confusionmatrix()
#install.packages("caret")
library(caret)
confusionMatrix(results$predict_type,results$actual_type,positive = "spam")  #confusionMatrix(예측값,실제값)
#positive: an optional character string for the factor level that corresponds to a "positive" result 

#(2) 모델 평가
#방법1) 각종통계량 계산
#a) 직접계산
accuracy<-(1202+154)/sum(table(results$actual_type,results$predict_type,dnn = c("actual","predict")));accuracy
precision<-154/ (154+9);precision  #스팸으로 예측된 것 중 실제로 스팸인 비율 
recall<-154/(29+154);recall   #실제로 스팸인데 스팸이라고 예측된 비
#b)confusionMatrix() 함수 결과로 판단
confusionMatrix(results$predict_type,results$actual_type,positive = "spam") #sensitivity==recall , ppv==precision

#방법2) ROC curve
#install.packages("ROCR")
library(ROCR)
results_pred<-prediction(predictions=results$prob_spam,labels=results$actual_type) 
perf<-performance(results_pred,measure="tpr",x.measure = "fpr")  #tpr:True Positive Rate=sensitivity , fpr:False Positive Rate=1-specificity
#measure: 평가에 사용할 성능 측정 값 , x.measure: 두번째 성과지표
plot(perf,main="Spam ROC curve")
perf<-performance(results_pred,measure="auc") 
str(perf) # AUC=y.value 0.983  #0.5<auc<1, 1로 갈수록 좋

#방법3) 카파통계량
#a) 직접 계산
pr_a<-accuracy
pr_e<-0.7840
k=(pr_a-pr_e)/(1-pr_e);k   
#b) irr 패키지 / vcd 패키지
