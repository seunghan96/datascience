# [ seq2seq ]

## 1. Introduction
- 입력 sequence로부터 다른 도메인의 sequence를 출력하는 모델이다
- ex) 챗봇, 기계 번역

크게 두 개의 아키텍쳐로 구성되어 있다 ( Encoder & Decoder )
1) Encoder : input 데이터를 context vector로 압축시키는 역할을 한다
2) Deooder : Encoder에서 출력된 context vector를 받아서, 번역된 단어들을 순차적으로 출력한다

Encoder와 Decoder의 내부는 RNN, LSTM, GRU 등의 셀로 구성되어 있다. </br>
( RNN, LSTM, GRU 등에 대한 내용은 이미 알고 있다 가정하고 생략한다 )
</br>
<img src="https://wikidocs.net/images/page/24996/%EB%8B%A8%EC%96%B4%ED%86%A0%ED%81%B0%EB%93%A4%EC%9D%B4.PNG" width="800" /> </br>
https://wikidocs.net/images/
</br>

### (1) Encoder
- 각각의 단어는 embedding을 통해 vector로 바뀐 뒤에 Encoder의 입력으로 들어가게 된다.
</br>
<img src="https://wikidocs.net/images/page/24996/%EC%9E%84%EB%B2%A0%EB%94%A9%EB%B2%A1%ED%84%B0.PNG" width="550" /> </br>
https://wikidocs.net/images/page/24996

- 하나의 cell은 각각의 시점에 2개의 입력을 받는다 </br>
  1 ) t-1 시점에서의 hidden state (은닉 상태)
  2 ) t(현재) 시점에서의 input vector
</br>

### (2) Decoder
- Encoder의 마지막 cell의 hidden state인 'context vector'를 첫 번째  hidden state의 값으로 사용한ㄷ
- Decoder의 cell이 출력하는 output은, Dense Layer를 거치고 마지막으로 Softmax 함수를 통해 "각 단어들이 나올 확률"을 예측값으로 반환한다
</br>

<img src="https://wikidocs.net/images/page/24996/decodernextwordprediction.PNG" width="350" /> </br>
https://wikidocs.net/images/page/24996

#### Teacher Forcing (교사 강요 )
- 개념 : train 시, decoder의 입력으로 이전 decoder cell의 output이 아닌 "실제 값"을 입력값으로 하는 방법
- 이유 : 만약 예측이 틀렸는데도 불구하고, 계속 다음 cell의 입력으로 사용할 경우, 전체적인 예측을 어렵게 할 수 있기 때문이다!
