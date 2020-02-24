# [ Transformer ]

## 1. Introduction
- Transformer은 기존의 seq2seq과 다르게 , cell 안에 RNN,LSTM,GRU 등의 방식을 사용하지 않는다 </br>
  ( Attention을 RNN의 보정 용도가 아니라, 아예 Attention만으로 Encoder & Decoder 생성 )
- Encoder & Decoder의 구조는 유지한다
- Encoder & Decoder라는 단위가 1개가 아닌 N개를 사용할 수 있다 </br>
  ( 논문에서는 Encoder와 Decoder을 각각 6개 사용함 )

<img src="https://wikidocs.net/images/page/31379/transformer2.PNG" width="270" />
https://wikidocs.net/images/page/31379/ </br>
( 논문에서는 6개의 encoder-decoder 구조를 사용 )
</br>
</br>

<img src="https://wikidocs.net/images/page/31379/transformer4_final_final_final.PNG" width="550" /> </br>
https://wikidocs.net/images/page/31379/</br>
</br>
이 그림을 보면, Encoder로부터 정보를 받아 Decoder가 출력 결과를 만드는 구조는 동일하다. 다만 RNN은 사용하지 않음을 확인할 수 있다
</br>
</br>

## 2. Transformer의 hyperparameter
transformer에 대해 구체적으로 설명하기 이전에, 어떠한 hyperparameter들이 있는지 살펴보자

**hyperparameters**
- 1 ) d_model : Encoder & Decoder에서의 정해진 입력 & 출력의 크기 (즉, Embedding Vector의 크기 또한 d_model )
- 2 ) num_layers : Encoder & Decoder의 구성 층 수
- 3 ) num_heads : Transformer에서는 병렬로 Attention을 수행하는데, 이때의 병렬 개수
- 4 ) d_ff : Transformer 내부에 존재하는 Feed Forward 신경망의 은닉층 크기
</br>

## 3. Positional Encoding
RNN이 자연어 처리에서 많이 사용된 이유는, 단어를 "순차적으로 입력"받아 처리하는 RNN의 특징 때문이다! 
이것이 각 단어의 위치 정보를 알려줬기 때문이다. 하지만, Transformer은 RNN을 사용하지 않는다. 
대신에, Positional Encoding이라는 방법을 통해 단어의 위치(순서)를 파악한다. 
단어의 위치 정보를 얻기 위해, 각 단어를 임베딩 한 이후, 이에 위치 정보를 더한 다음 모델에 입력한다.
</br>
</br>
<img src="https://wikidocs.net/images/page/31379/transformer5_final_final.PNG" width="550" /> </br>
https://wikidocs.net/images/page/31379/
</br>
</br>

임베딩 벡터가 Encoder의 입력으로 사용되기 전에, 다음과 같이 Positional Encoding값이 더해진다
</br>
</br>
<img src="https://wikidocs.net/images/page/31379/transformer6_final.PNG" width="550" /> </br>
https://wikidocs.net/images/page/31379/
</br>
</br>

위 그림처럼 "벡터" 단위로 더해지는게 아니라, 사실은 Embedding Vector가 모여서 만들어진 "문장 벡터 행렬"에
"Positional Encoding 행렬"이 이루어진다
</br>
</br>
<img src="https://wikidocs.net/images/page/31379/transformer6_final.PNG" width="550" /> </br>
https://wikidocs.net/images/page/31379/
</br>
</br>

Positional Encoding의 값은 다음과 같다
</br>
</br>
<a href="https://www.codecogs.com/eqnedit.php?latex=PE_(pos,2i)&space;=&space;sin(pos/10000^{2i/d_{model}})" target="_blank"><img src="https://latex.codecogs.com/gif.latex?PE_(pos,2i)&space;=&space;sin(pos/10000^{2i/d_{model}})" title="PE_(pos,2i) = sin(pos/10000^{2i/d_{model}})" /></a>
</br>
<a href="https://www.codecogs.com/eqnedit.php?latex=PE_(pos,2i&plus;1)&space;=&space;cos(pos/10000^{2i/d_{model}})" target="_blank"><img src="https://latex.codecogs.com/gif.latex?PE_(pos,2i&plus;1)&space;=&space;cos(pos/10000^{2i/d_{model}})" title="PE_(pos,2i+1) = cos(pos/10000^{2i/d_{model}})" /></a>
</br>
</br>

## 4. Encoder
Encoder의 구조는 다음과 같이 생겼다
</br>
</br>
<img src="https://wikidocs.net/images/page/31379/transformer9.png" width="240" /> </br>
https://wikidocs.net/images/page/31379/transformer9.png
</br>

Encoder의 구조
- n개의 encoder를 가진다 ( = num_layers )
- Encoder를 하나의 '층'으로 생각해보자. 하나의 Encoder는 총 2개의 sub layer로 구성된다 </br>
  1 ) Self Attention </br>
  2 ) Position wise Feed Forward Neural Network
  
( Self Attention과 Position wise Feed Forward neural network이 무엇인지는 뒤에서 알아보자 )
</br>
</br>

## 5. Encoder의 Multi-head Attention

### (1) Multi-head Self Attention
### a) Self Attention
기존의 seq2seq에서 Attention의 Q,K,V
- 1 ) Q : t 시점의 Decoder cell에서의 Hidden state
- 2 ) K : 모든 시점의 Encoder cell에서의 Hidden states
- 3 ) V : 모든 시점의 Encoder cell에서의 Hidden states
</br>

t 시점의 Decoder state가 아니라, 전체 시점으로 일반화하면
- 1 ) Q : 모든 시점의 Decoder cell에서의 Hidden state
- 2 ) K : 모든 시점의 Encoder cell에서의 Hidden states
- 3 ) V : 모든 시점의 Encoder cell에서의 Hidden states
</br>

BUT, Transformer의 Self-Attention의 Q,K,V는 모두 같다!
- Q,K,V : 입력 문장의 모든 단어 벡터들
</br>

Self Attention을 사용하면 좋은 이유? ( 아래 Example 참고 )
- 아래 그림을 보면, 의미 상 it은 animal에 해당한다.
- 기계는 이를 '입력 문장 내의 단어들끼리의 유사도'를 통해 찾아낸다!
- (it은 animal, street 중 animal과 더 높은 유사도를 보인다)

#### Example 
</br>
<img src="https://wikidocs.net/images/page/31379/transformer10.png" width="260" /> </br>
https://wikidocs.net/images/page/31379

기존의 seq2seq의 attention은, 서로 다른 Encoder & Decoder 문장 사이의 연관성을 찾아냈기
때문에, 위 예시와 같은 정보는 찾아낼 수 없었다.
</br>
</br>

### b) Q,K,V vector
입력받은 단어 vector로 바로 Self-Attention? NO!

각 단어 vector로부터 Q,K,V벡터를 먼저 얻어낸다 ( 차원 축소가 이루어짐 )
- input 되는 단어 vector : d_model 차원 ( 논문에서 d_model = 512 )
- 차원 축소된 Q,K,V vector : d_model / num_heads 차원 ( 논문에서 num_heads = 8, 즉 64차원 )
</br>

### c) scaled-dot product attention
기존과(attention mechanism 참고) 유사하다. 구해낸 Q,K,V벡터를 사용하여 다음과 같은 순서로 cnotext vector를
구해낸다 ( Attention Score -> Attention Distribution -> Attention Value(Context Vector) )
</br>

차이점 : 단순 내적이 아니라, "특정 값으로 나눠준 attention 함수"를 사용한다
</br>
</br>
<a href="https://www.codecogs.com/eqnedit.php?latex=score(q,k)&space;=&space;q\cdot&space;k&space;/&space;\sqrt{n}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?score(q,k)&space;=&space;q\cdot&space;k&space;/&space;\sqrt{n}" title="score(q,k) = q\cdot k / \sqrt{n}" /></a>
</br>
</br>
아래 그림을 통해 쉽게 이해할 수 있다.
</br>
<img src="https://wikidocs.net/images/page/31379/transformer14_final.PNG" width="700" /> 
</br>
https://wikidocs.net/images/page/31379
</br>
</br>
위 그림에서는 'I'라는 단어의 Q 벡터에 대해 연산이 이루어졌다. 하지만, 행렬 연산으로 일괄적으로 처리하면, 이렇게 모든 Q벡터마다 일일히 따로 계산할 필요가 없다.
</br>
</br>

### d) 행렬 연산으로 일괄 처리

**[ STEP 1 ] Q, K, V행렬 구하기** 
</br>
실제로는 벡터 간의 연산이 아니라, 행렬로 한번에 연산이 이루어지기 때문에 Q,K,V 행렬을 우선 구해야 한다.
</br>

<img src="https://wikidocs.net/images/page/31379/transformer12.PNG" width="550" /> </br>
https://wikidocs.net/images/page/31379
</br>
</br>

**[ STEP 2 ] 행렬 연산을 통해 Attention Score 구하기** </br>
Q 행렬을 K 행렬의 전치행렬과 곱해준다
</br>

<img src="https://wikidocs.net/images/page/31379/transformer15.PNG" width="550" /> </br>
https://wikidocs.net/images/page/31379
</br>
</br>

**[ STEP 3 ] Attention Value 구하기** </br>
Attention Score에 Softmax함수를 사용하고, 이에 V 행렬을 곱한다
</br>

<img src="https://wikidocs.net/images/page/31379/transformer16.PNG" width="550" /> </br>
https://wikidocs.net/images/page/31379
</br>
</br>

위 연산을 거친 결과는, 정리하자면 다음과 같은 수식으로 표현할 수 있다.
</br>
</br>
<a href="https://www.codecogs.com/eqnedit.php?latex=Attention(Q,K,V)&space;=&space;softmax(\frac{QK^T}{\sqrt{d_k}})V" target="_blank"><img src="https://latex.codecogs.com/gif.latex?Attention(Q,K,V)&space;=&space;softmax(\frac{QK^T}{\sqrt{d_k}})V" title="Attention(Q,K,V) = softmax(\frac{QK^T}{\sqrt{d_k}})V" /></a>
</br>
</br>
### 행렬의 크기
입력 문장의 길이 : seq_len </br>
문장 행렬의 크기 : (seq_len, d_model) -> 이 문장 행렬을 통해 Q,K,V 행렬을 구하낟

Q & K 벡터의 크기 : d_k  </br>
V 벡터의 크기 : d_v
- Q 행렬 : (seq_len, d_k)
- K 행렬 : (seq_len, d_k)
- V 행렬 : (seq_len, d_v)

이에 따라, 자동으로 weight 행렬의 크기도 정해진다
- Wq 행렬 : (d_model,d_k)
- Wk 행렬 : (d_model,d_k)
- Wv 행렬 : (d_model,d_v)
</br>
( 논문에서 d_k와 d_v는 'd_model / num_head'로 동일하다 )
</br>
</br>
" 결과적으로, Attention Value 행렬(a)의 크기는 (seq_len, d_v)이다! "
</br>
</br>

### (2) Multi-head Attention
num_heads란 무엇일까? 왜 d_model의 차원으로 attention으로 하지 않고, 차원을 축소한 뒤 attention을 시행할까?
</br>
</br>
#### for "병렬 처리"
</br>
<img src="https://wikidocs.net/images/page/31379/transformer17.PNG" width="650" /> </br>
https://wikidocs.net/images/page/31379
</br>
</br>

d_model에서, d_model / num_heads으로 차원축소가 이루어진다! </br>
( num_heads개 병렬 Attention을 동시에 수행! )

병렬 처리를 하는 이유는, 보다 다양한 특징을 capture하기 위해서이다. </br>
이와 같이 병렬 attention을 모두 시행한 이후, attention head들을 전부 concatenate한다. </br>
( 연결된 attention head 행렬의 크기 : (seq_len, d_model) )
</br>
</br>
<img src="https://wikidocs.net/images/page/31379/transformer18_final.PNG" width="400" /> </br>
https://wikidocs.net/images/page/31379
</br>
</br>

이렇게 연결된 attention head들에, 가중치 행렬(Wo)를 곱해서 Multi-head Attention Matrix를 생성한다
</br>
</br>
<img src="https://wikidocs.net/images/page/31379/transformer19.PNG" width="650" /> </br>
https://wikidocs.net/images/page/31379
</br>
</br>

#### Multi-head Attention에 등장한 weight matrix 정리
- 1 ) Wq, Wk, Wv
- 2 ) Wo ( attention head 생성 후, 이에 곱하는 weight matrix )
</br>
weight matrix (Wq,Wk,Wv)의 값이 8개 Attention Head마다 모두 다르게 됨!


## 6. Position-wide FFNN (Feed Forward Neural Network)
- Encoder와 Decoder에서 모두 사용된다
- 연산 방식은 FC (Fully Connected)과 동일하다
</br>
<a href="https://www.codecogs.com/eqnedit.php?latex=FFNN(x)&space;=&space;MAX(0,&space;xW_1&space;&plus;&space;b1)W_2&space;&plus;&space;b_2" target="_blank"><img src="https://latex.codecogs.com/gif.latex?FFNN(x)&space;=&space;MAX(0,&space;xW_1&space;&plus;&space;b1)W_2&space;&plus;&space;b_2" title="FFNN(x) = MAX(0, xW_1 + b1)W_2 + b_2" /></a>
</br>
</br>
<img src="https://wikidocs.net/images/page/31379/positionwiseffnn.PNG" width="230" /> </br>
https://wikidocs.net/images/page/31379
</br>
</br>

행렬의 크기</br>
- 위 그림에서의 x는 앞에서 구한 Multi-head Attention의 크기와 같은 행렬이다
- W1의 shape : (d_model, d_ff)
- W2의 shape : (d_ff, d_model)
</br>

여기에서 사용되는 parameter들 (W1, b1, W2, b2)는 문장 별로 모두 동일하지만, Encoder층 마다는 다른 값을 가진다. </br>
아래 그림을 보면, 지금까지의 연산이 어떻게 이루어지는지 쉽게 이해할 수 있다.
</br>
</br>
<img src="https://wikidocs.net/images/page/31379/transformer20.PNG" width="650" /> </br>
https://wikidocs.net/images/page/31379
</br>
</br>
</br>

## 7. Residual Connection & Layer Normalization
아래 그림과 같이, Add와 Normalization의 과정이 추가된다.
</br>
</br>

### 1) Residual Connection
ResNet을 공부한 적이 있다면 잘 알 것이다. 입력 x와, 이를 input으로 나온 어떠한 함수값 F(x)를 더한 함수 H(x)를 의미한다. ( 여기서 F(x)는 Transformer의 sub layer가 된다 )
</br>
</br>
<img src="https://wikidocs.net/images/page/31379/transformer22.PNG" width="220" /> </br>
https://wikidocs.net/images/page/31379
