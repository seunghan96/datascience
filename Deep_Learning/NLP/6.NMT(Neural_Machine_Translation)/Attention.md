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

이것이 어떻게 Attention mechanism에 적용되는지, 다음 그림을 통해 확인해보자 </br>
