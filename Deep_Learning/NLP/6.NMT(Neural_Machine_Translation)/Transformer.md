# [ Transformer ]

## 1. Introduction
- Transformer은 기존의 seq2seq과 다르게 , cell 안에 RNN,LSTM,GRU 등의 방식을 사용하지 않는다 </br>
  ( Attention을 RNN의 보정 용도가 아니라, 아예 Attention만으로 Encoder & Decoder 생성 )
- Encoder & Decoder의 구조는 유지한다
- Encoder & Decoder라는 단위가 1개가 아닌 N개를 사용할 수 있다 </br>
  ( 논문에서는 Encoder와 Decoder을 각각 6개 사용함 )


https://wikidocs.net/images/page/31379/transformer2.PNG
( 논문에서는 6개의 encoder-decoder 구조를 사용 )


https://wikidocs.net/images/page/31379/transformer4_final_final_final.PNG
이 그림을 보면, Encoder로부터 정보를 받아 Decoder가 출력 결과를 만드는 구조는 동일하다. 다만 RNN은 사용하지 않음을 확인할 수 있다
</br>
</br>

## 2. Transformer의 hyperparameter
transformer에 대해 구체적으로 설명하기 이전에, 어떠한 hyperparameter들이 있는지 살펴보자

hyperparameter
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
https://wikidocs.net/images/page/31379/transformer5_final_final.PNG
</br>

임베딩 벡터가 Encoder의 입력으로 사용되기 전에, 다음과 같이 Positional Encoding값이 더해진다
</br>
https://wikidocs.net/images/page/31379/transformer6_final.PNG
</br>

위 그림처럼 "벡터" 단위로 더해지는게 아니라, 사실은 Embedding Vector가 모여서 만들어진 "문장 벡터 행렬"에
"Positional Encoding 행렬"이 이루어진다
</br>
https://wikidocs.net/images/page/31379/transformer6_final.PNG
</br>

Positional Encoding의 값은 다음과 같다
</br>
<a href="https://www.codecogs.com/eqnedit.php?latex=PE_(pos,2i)&space;=&space;sin(pos/10000^{2i/d_{model}})" target="_blank"><img src="https://latex.codecogs.com/gif.latex?PE_(pos,2i)&space;=&space;sin(pos/10000^{2i/d_{model}})" title="PE_(pos,2i) = sin(pos/10000^{2i/d_{model}})" /></a>
</br>
<a href="https://www.codecogs.com/eqnedit.php?latex=PE_(pos,2i&plus;1)&space;=&space;cos(pos/10000^{2i/d_{model}})" target="_blank"><img src="https://latex.codecogs.com/gif.latex?PE_(pos,2i&plus;1)&space;=&space;cos(pos/10000^{2i/d_{model}})" title="PE_(pos,2i+1) = cos(pos/10000^{2i/d_{model}})" /></a>
</br>
