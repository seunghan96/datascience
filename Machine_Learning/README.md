# Machine Learning Study
#### 데이터 전처리부터, 머신러닝의 다양한 기법들을 이론적으로 학습하고, 여러 라이브러리를 활용하여 코드 실습을 진행
- 교재, 블로그, 논문 및 학회 스터디 자료 등을 참고하여 학습
- 학회에서 직접 강의한 자료들도 함께 있음
#### Study 방식 
- (이론) 수리.통계적으로 모델에 대한 학습 
- (실습) 패키지를 활용하여 실제 데이터에 적용하여 연습
#### 기간 : 2019.01 ~ </br> </br> 

## 목차

### 1. Data Cleansing & Visualization
- pandas, numpy를 활용한 데이터 분석
- matplotlib, seaborn을 이용한 EDA 및 시각화
- [학회 발표자료] : "DataCleansing_Visualization_이승한.pdf" </br> </br> 

### 2. Logistic Regression
- 보다 자세한 내용은 아래 자료 참고 https://github.com/seunghan96/datascience/tree/master/%5B%EC%97%B0%EA%B5%AC%EC%8B%A4%EC%9D%B8%ED%84%B4%5DComputational_Science_and_Engineering
- Binary Classifion (Logistic Regression) & Multi-class Classification (OVR, OVO) </br> </br> 

### 3. Clustering
- 세 가지 클러스터링 기법에 대해 학습
- 거리 기반의 K-Means, 밀도 기반의 DBSCAN, 계층형의 Agglomerative Clustering
- (Deep Learning을 이용한 Clustering) SOM은 아래 자료 참고 https://github.com/seunghan96/datascience/tree/master/%5B%EA%B5%90%EB%82%B4%EC%88%98%EC%97%85%5DYonsei/DeepLearning_R
- 기타) 연세빅데이터 경진대회에서 PACKUS사의 고객 세분화를 위해 SOM(Self Organizing Map)기법 사용 </br> </br> 

### 4. PCA
- 선형대수 스터디에서 이론적으로 학습한 뒤, 코드를 통해 실습 </br> </br> 

### 5. Regression & Penalized Model
- Ridge(L2 regularization), Lasso(L1 regularization), Elastic Net
- https://github.com/seunghan96/datascience/tree/master/%5B%EA%B5%90%EB%82%B4%EC%88%98%EC%97%85%5DYonsei/DeepLearning_R 에서도 참고 가능
 </br> </br> 
 
### 6. Decision Tree & Random Forest
- Tree 기반의 모델에 대해 학습
- Decision Tree에 대한 실습과, 이를 병합한 앙상블 기법인 Random Forest Classifier & Regressor, Bagging등 </br> </br> 

### 7. Ensembles
- RF, Bagging등은 앞서 학습
- 1 ) Boosting ( GBM, XGBoost, LGBM 등 )
- 2 ) Multi-Class classification model인 OVR, OVO 
- 3 ) Stacking </br> </br> 

### 8. Recommendation System
- Latent Factor Model, Collaborative Filtering
- IGA works competition (CTR 예측)에, FM(Factorization Machine) 활용 ( 추후 업로드 예정 ) </br> </br> 

### 9. Association Rule
- Market Basket Analysis ( Support, Confidence, Lift 등의 지표 )
- "mlxtend, apyori" package 활용
- Gephi를 이용한 visualization
- [학회 발표자료] : "Association_Analysis_이승한.pdf" </br> </br> 

### 10. Support Vector Machine
- SVC (Classification)
- SVR (Regression)
- kernel에 따라 학습에 오랜 시간이 걸릴 수 있는 점을 보완하기 위해 Bagging의 base estimator로 LinearSVM 사용
- [학회 발표자료] : "SVM_이승한.pdf" </br> </br>  

### 11. Bokeh
- Bokeh를 이용한 다양한 interactive plot 그려보기 </br> </br>  

### 12. Interpretation of Black Box model
- 모델의 복잡도가 높아짐에 따라 떨어지게 되는 모델의 해석력
- 이를 해석하기 위한 다양한 지표들 O
- 가장 기본적이고 사용하기 쉬운, Feature Importance -> unstability의 문제점
- 이를 보완한 다양한 지표들 ( LIME, SHAP, PDP, ICE plot )  </br> </br>  

### 13. Bayesian Optimization
- Hyperparameter tuning 시, 자주 사용하는 search 방식인 grid search / random search
- 이 방식들보다 효율적인 방식으로 optimize!
- Exploration & Exploitation
