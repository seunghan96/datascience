# [ seq2seq ]

## 1. Model 소개
- 입력 sequence로부터 다른 도메인의 sequence를 출력하는 모델이다
- ex) 챗봇, 기계 번역

크게 두 개의 아키텍쳐로 구성되어 있다 ( Encoder & Decoder )
1) Encoder : input 데이터를 context vector로 압축시키는 역할을 한다
2) Deooder : Encoder에서 출력된 context vector를 받아서, 번역된 단어들을 순차적으로 출력한다

Encoder와 Decoder의 내부는 RNN, LSTM, GRU 등의 셀로 구성되어 있다. </br>
( RNN, LSTM, GRU 등에 대한 내용은 이미 알고 있다 가정하고 생략한다 )
</br>
<img src="https://wikidocs.net/images/page/24996/%EB%8B%A8%EC%96%B4%ED%86%A0%ED%81%B0%EB%93%A4%EC%9D%B4.PNG" width="800" /> </br>
https://wikidocs.net/images/page/24996/%EB%8B%A8%EC%96%B4%ED%86%A0%ED%81%B0%EB%93%A4%EC%9D%B4.PNG
</br>

