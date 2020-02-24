# [ Attention ]

## 1. seq2seq의 문제점
- 1 ) 고정된 크기의 vector에 모든 정보를 압축하기 때문에, 정보 손실이 불가피하다!
- 2 ) 문장이 길어질 경우, vanishing gradient 문제는 어쩔 수 없다

이를 해결하기 위한 기법이 'attention (mechanisim)'이다
</br>
</br>

이를 그림으로 간단히 표현하면, 다음과 같이 나타낼 수 있다
</br>
<img src="https://mogren.one/graphics/illustrations/2016-09-29/rnn-encoder-decoder-attention.svg" width="550" /> </br>
https://mogren.one/graphics/illustrations/2016-09-29/rnn-encoder-decoder-attention.svg
</br>
seq2seq와 유사해보이지만, 'attention'이라는 것이 추가된 것을 확인할 수 있다. 이 attention이 어떠한 역할을 하고, 어떠한 방식으로
vanishing gradient 문제를 해결할 수 있는지 살펴 보자
</br>
</br>

## 2. Attention Function
- key idea : decoder에서 단어를 예측하여 출력값을 내는 매 시점마다, 'encoder의 전체 입력 문장'을 다시 참고한다!
- 전체 문장을 다시 참고할 때, 모든 단어를 동일한 비율로 참고하지 않는다! 

**"해당 시점에서 예측해야 할 단어와 연관이 있는 입력 단어에 보다 집중한다"**
</br>

그러기 위해, 우선 key-value의 dictionary 형식부터 알아보자. </br>
아래 보이는 바와 같이, 각각의 key에는 이에 해당하는 value를 가지고 있다.

```
dict = {"2017" : "Transformer", "2018" : "BERT"}
```

- dictionary의 key값
```
dict.keys()

dict_keys(['2017', '2018'])
```

- dictionary의 value값
```
dict.values()

dict_values(['Transformer', 'BERT'])
```
</br>

이것이 어떻게 Attention mechanism에 적용되는지, 다음 그림을 통해 확인해보자 
</br>
<img src="https://wikidocs.net/images/page/22893/%EC%BF%BC%EB%A6%AC.PNG" width="550" /> </br>
https://wikidocs.net/images/page/22893 </br>

Attention에서 계산되는 attention value은 다음과 같은 방식으로 계산된다. 
- step 1) 주어진 Query에 대해서, 모든 key와의 유사도를 구한다
- step 2) 계산한 유사도와, (key와 매핑되어있는) value를 함께 고려하여 값을 계산한다  
- step 3) value값을 모두 더해서 return한다 (weighted sum)

### Q,K,V
위 식에서 Q,K,V는 각각 다음에 해당한다
- Q : t시점의 decoder cell에서의 hidden state
- K & V : 모든 시점의 encoder에서의 hidden state
</br>
</br>

## 3. Dot-Product Attention
- 여러 attention 기법 중, 가장 간단한 기법이다

다음 그림을 통해 dot-product attention을 이해해보자
</br>
https://wikidocs.net/images/page/22893/dotproductattention1_final.PNG
</br>
위 그림에서 Decoder의 세 번째 LSTM셀은, 출력 단어를 예측하기 위해 Encoder의 모든 input 단어들을 다시 참고한다. 
그 참고하는 정도는, input 단어별로 모두 다르다. 그 정도는, Encoder에서 나온 모든 출력값들에 따라 정해진다 (위 그림에서의 softmax 함수 결과값 ). 이렇게 각기 다른 input 단어들의 영향도를 고려한 값을 모두 더한다. 그렇게 나온 하나의 값은 Decoder로 전송된다!
</br>
<br>

## 4. Attention Value
### algorithm
seq2seq에서, Decoder가 출력값을 낼 때 다음과 같은 2가지 값을 input으로 밭는다는 것을 이전 포스트에서 확인했다
- 1 ) t-1 시점의 hidden state
- 2 ) t-1 시점에서 출력된 output

attention mechanism은 위의 두 개의 값 외에도, 다음과 같은 값을 추가로 필요로 한다
- 3 ) Attention Value (at)

### Attention Value를 구하는 4가지 Step
- step 1) Attention Score 구하기
- step 2) Softmax를 통해 Attention Distribution 구하기
- step 3) Attention Value 구하기
- step 4) Attention Value와 Decoder의 t시점의 hidden state과의 연결

#### STEP 1) Attention Score 구하기
