* 분석을 진행하기에 앞서, 향후 작업에 필요한 audience_profile 파일은 용량이 커서 폴더에 넣지 못했습니다. raw_data 폴더에 audience_profile 파일을 넣으신 후 진행해주시기 바랍니다.

1. preprocess.py 실행
목표: Audience 데이터 유무로 aud_train_merged / no_aud_train_merged 형성

(1) directory 지정(일단 관계자 분께서 지정하실 수 있도록 input 처리하였습니다.)
(2) test set에도 사용할 label encoder와 scaler가 각각 label_classes , scaler 파일에 저장됩니다.
(audience가 있는 데이터 label encoder는 label_classes/aud_classes에, audience가 없는 데이터는 label_classes/no_aud_classes에 저장됩니다.)
(3) 최종 전처리된 파일은 preprocessed_data로 aud_train_merged와 no_aud_train_merged로 따로 저장됩니다.

2. modeling.py 실행
목표: audience가 있는 데이터용 모델(aud_model) , audience가 없는 데이터용 모델(no_aud_model) 형성

* deepctr 모델 설치 필요합니다.
(1) directory 지정
(2) 전처리한 데이터 불러오기
(3) 최종 실행시 saved_model 파일에 aud_model.h5 , no_aud_model.h5로 각각의 모델이 저장됩니다.

3. predict.py 실행
목표: test set 전처리 및 저장된 모델로 예측

(1) directory 지정
(2) train data를 전처리한 방식과 같이 전처리
(3) 학습 후 최종 결과를 prediction_result에 저장
