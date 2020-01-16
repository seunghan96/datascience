# Word2vec Parameter Learning Explained 요약

word2vec는 이산형인 word를 연속형인 vector로 표현하는 대표적인 방법이다. <br />
CBOW(continuous bag-of-word)와 skip-gram이 word2vec의 대표적인 모델이다. <br />

## 1. CBOW (Continous Bag-of-Word)
### 1.1 One-word context
하나의 context word로 하나의 target word를 예측하는 모델이다.<br />
모델의 구조를 들여다보면 다음과 같다.<br />
<img src="http://images2015.cnblogs.com/blog/464052/201605/464052-20160510143230327-1799851943.png" width="450" height="250" />

INPUT 
- one-hot encoding된 하나의 context word
- dimension : 1xV ( V : 총 단어의 개수 ) <br /> <br />

HIDDEN LAYER ( W )
1) W(vxn)
- weight between input & hidden
- dimension : VxN
- <a href="https://www.codecogs.com/eqnedit.php?latex=h&space;=&space;W^\textup{T}x&space;=&space;v^\textup{T}_{wI}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?h&space;=&space;W^\textup{T}x&space;=&space;v^\textup{T}_{wI}" title="h = W^\textup{T}x = v^\textup{T}_{wI}" /></a> (수식1)  

2) W'(nxv)
- weight between hidden & output
- dimension : NxV
- predict되는 단어의 score을 반환한다
- <a href="https://www.codecogs.com/eqnedit.php?latex=u_{j}&space;=&space;v'_{w_{j}}^\textup{T}h" target="_blank"><img src="https://latex.codecogs.com/gif.latex?u_{j}&space;=&space;v'_{w_{j}}^\textup{T}h" title="u_{j} = v'_{w_{j}}^\textup{T}h" /></a> (수식2)  <br /> <br />

OUTPUT
- hidden layer에서 출력되는 score를 softmax 함수를 통해 각 단어로 예측할 확률을 반환한다 <br />
<a href="https://www.codecogs.com/eqnedit.php?latex=p(w_{j}|w_{I})&space;=&space;y_{j}&space;=&space;\frac{exp(u_{j})}{\sum_{j'=1}^{V}exp(u_{j'})}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?p(w_{j}|w_{I})&space;=&space;y_{j}&space;=&space;\frac{exp(u_{j})}{\sum_{j'=1}^{V}exp(u_{j'})}" title="p(w_{j}|w_{I}) = y_{j} = \frac{exp(u_{j})}{\sum_{j'=1}^{V}exp(u_{j'})}" /></a> (수식3) <br /> 
- 위 식에, 수식1 & 수식2를 대입하면 다음과 같이 정리할 수 있다 <br />
<a href="https://www.codecogs.com/eqnedit.php?latex=p(w_{j}|w_{I})&space;=&space;y_{j}&space;=&space;\frac{{v'_{w_{j}}}^{T}v_{w_{I}}}{\sum_{j'=1}^{V}exp({v'_{w_{j'}}}^{T}v_{w_{I}})}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?p(w_{j}|w_{I})&space;=&space;y_{j}&space;=&space;\frac{{v'_{w_{j}}}^{T}v_{w_{I}}}{\sum_{j'=1}^{V}exp({v'_{w_{j'}}}^{T}v_{w_{I}})}" title="p(w_{j}|w_{I}) = y_{j} = \frac{{v'_{w_{j}}}^{T}v_{w_{I}}}{\sum_{j'=1}^{V}exp({v'_{w_{j'}}}^{T}v_{w_{I}})}" /></a> (수식4) <br />  <br />

OBJECTIVE FUNCTION <br />
<a href="https://www.codecogs.com/eqnedit.php?latex=p(w_{j}|w_{I})&space;=&space;y_{j}&space;=&space;\frac{{v'_{w_{j}}}^{T}v_{w_{I}}}{\sum_{j'=1}^{V}exp({v'_{w_{j'}}}^{T}v_{w_{I}})}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?p(w_{j}|w_{I})&space;=&space;y_{j}&space;=&space;\frac{{v'_{w_{j}}}^{T}v_{w_{I}}}{\sum_{j'=1}^{V}exp({v'_{w_{j'}}}^{T}v_{w_{I}})}" title="p(w_{j}|w_{I}) = y_{j} = \frac{{v'_{w_{j}}}^{T}v_{w_{I}}}{\sum_{j'=1}^{V}exp({v'_{w_{j'}}}^{T}v_{w_{I}})}" /></a> (수식4)를 최대화하는 것이다 <br /> 


- 수식 5,6,7

### 1.2 Multi-word context
위의 1.1 One-word context에서, input이 하나의 context가 아니라 여러 개의 context word라는 점 외에 동일하다.<br />
input context words의 평균 벡터를 인풋으로 받는다.<br />
- 수식 17, 18
모델의 구조는 다음과 같이 표현될 수 있다.<br />
<img src="https://static.packt-cdn.com/products/9781786465825/graphics/B05525_03_05.jpg" width="450" height="450" />

OBJECTIVE FUNCTION
- 다음의 loss function을 최소화하는 것이다
- 수식 19,20,21

## 2. Skip-Gram Model
CBOW의 반대라고 보면 된다. 모델의 구조를 들여다보면 다음과 같다<br />
이번에는 반대로, input으로 target word가 들어가고, output으로 context word가 들어가게 된다. 그 외의 사항은 동일하다 <br />
<img src="http://www.claudiobellei.com/2018/01/06/backprop-word2vec/Skipgram.png" width="450" height="450" />

OUTPUT LAYER
- CBOW는 예측하는 대상이 하나의 단어이기 때문에 한개의 multinomial distribution이 output으로 출력되지만, Skip-Gram같은 경우에는 여러 개의 단어이기 때문에 C개의 multinomial distribution을 출력한다.
- 수식 25
 
OBJECTIVE FUNCTION
- 다음의 loss function을 최소화하는 것이다
- 수식 27,28,29
