# LINE (Large-scale Information Network Embedding)
### Proximity : First-order Proximity & Second-order Proximity </br>  </br>

### 1. LINE with First-order Proximity  </br>
이 proximity를 objective function에서 사용하는 이유는, "나(하나의 vertex)랑 직접적으로 연결 되어있는 vertex(node)는 나와 가까운 위치에 임베딩
되도록 훈련하기 위해서"라고 할 수 있다.(보다 자세한 내용은 이전 포스트 참조) 그리고 이것은 두 node의 연결 여부 및 연결 강도만을 고려하기 때문에, undirected graph에서만 적용 가능하다.
수식적으로 살펴보자.  </br> 

하나의 undirected edge (i,j)가 있다고 하자. 이 edge의 양 끝에 연결된 두 개의 vertex는 vi와 vj이고, </br> 
이 둘의 joint probability는 다음과 같다.  ( 아래 식에서 ui는 vertex vi의 embedding 이후의 low-dimensional 표현이다 ) </br> </br>
(식1) <a href="https://www.codecogs.com/eqnedit.php?latex=p_1(v_i,v_j)&space;=&space;\frac{1}{1&plus;exp(-\vec{u}_i^T\cdot\vec{u}_j)}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?p_1(v_i,v_j)&space;=&space;\frac{1}{1&plus;exp(-\vec{u}_i^T\cdot\vec{u}_j)}" title="p_1(v_i,v_j) = \frac{1}{1+exp(-\vec{u}_i^T\cdot\vec{u}_j)}" /></a>
</br> </br> 
직관적으로 생각해서, 두 node의 vector의 내적 값이 크면, (즉 두 vector가 유사하면) 위 p값은 커질 것이고, 작아지면 p값도 작아질 것이다. 이 식을 다음과 같이 <a href="https://www.codecogs.com/eqnedit.php?latex=p_1(\cdot&space;,\cdot&space;)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?p_1(\cdot&space;,\cdot&space;)" title="p_1(\cdot ,\cdot )" /></a>로 줄여서 표현하자. 그리고 이것의 empirical probability는, 다음과 같이 '모든 edge들의 weight의 합에서 특정 edge의 weight가 차지하는 비중'으로 표현할 수 있다.
</br> </br> 
(식2) <a href="https://www.codecogs.com/eqnedit.php?latex=\hat{p}_i(i,j)&space;=&space;\frac{w_i_j}{W}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\hat{p}_i(i,j)&space;=&space;\frac{w_i_j}{W}" title="\hat{p}_i(i,j) = \frac{w_i_j}{W}" /></a>
</br> 위 값도 다음과 같이 <a href="https://www.codecogs.com/eqnedit.php?latex=\hat{p_1}(\cdot&space;,\cdot&space;)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\hat{p_1}(\cdot&space;,\cdot&space;)" title="\hat{p_1}(\cdot ,\cdot )" /></a>로 줄여서 표현한다.
</br> </br> 
그러므로, first order proximity를 잘 반영한 objective function은 다음과 같이 2개의 값의 거리(d)로 나타낼 수 있다.</br> </br> 
(식3)<a href="https://www.codecogs.com/eqnedit.php?latex=O_1&space;=&space;d(\hat{p}(\cdot&space;,\cdot&space;),p_1(\cdot&space;,\cdot&space;))" target="_blank"><img src="https://latex.codecogs.com/gif.latex?O_1&space;=&space;d(\hat{p}(\cdot&space;,\cdot&space;),p_1(\cdot&space;,\cdot&space;))" title="O_1 = d(\hat{p}(\cdot ,\cdot ),p_1(\cdot ,\cdot ))" /></a> </br> </br> 
여기서 거리 d는 KL-divergence로 표현되며, 이를 정리하면 다음과 같은 식으로 표현할 수 있다.</br> </br> 
(식4)<a href="https://www.codecogs.com/eqnedit.php?latex=O_1&space;=&space;-\sum_{(i,j)\in&space;E}^{&space;}w_i_jlogp_1(v_i,v_j)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?O_1&space;=&space;-\sum_{(i,j)\in&space;E}^{&space;}w_i_jlogp_1(v_i,v_j)" title="O_1 = -\sum_{(i,j)\in E}^{ }w_i_jlogp_1(v_i,v_j)" /></a>

따라서 위 값을 minimize하는 방향으로 optimize를 할 경우, first-order proximity를 잘 반영하는 network embedding model을 만들 수 있을 것이다.</br> </br> 

### 2. LINE with Second-order Proximity
이 proximity를 objective function에서 사용하는 이유는, "나(하나의 vertex)와 직접적인 연관이 어떨지는 모르겠지만, 나와 공유하고 있는 친구(연결되어 있는 주변의 vertex)가 유사한 어떤 vertex가 있다면, 나와 그 vertex는 가까운 위치에 임베딩 되도록 훈려하기 위해서"라고 할 수 있다.
second order proximity는 first order와는 다르게, directed graph뿐만 아니라 undirected graph에서도 사용할 수 있다는 장점이 있다. 여기서 특이한 점은, 하나의 vertex가 이를 대표하는 하나의 vector가 아니라 두개의 vector가 있다는 것이다. 즉, 하는 역할이 두 가지 있는데, 하나는 기존과 같이 "(1) 자기 자신을 나타내는 vector"이고, 또 다른 하나는 "(2) 다른 vertices들의 context를 나타내는 vector"이다. 그래서 vertex i가 가지는 두 개의 vector은 각각 (1) <a href="https://www.codecogs.com/eqnedit.php?latex=\vec{u}_i" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\vec{u}_i" title="\vec{u}_i" /></a>(vertex itself) 와, (2) <a href="https://www.codecogs.com/eqnedit.php?latex=\vec{u'}_i" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\vec{u'}_i" title="\vec{u'}_i" /></a>(context of other vertices)이다. ( 이 둘을 앞으로 각각 'vector itself'하고 'context vector'라고 표현하겠다 )</br> 
따라서, 하나의 directed edge (i,j)에, 우리는 우선 vector i에 의해 생성된 vector j의 context vector의 probability를 다음과 같이 정의한다.</br> </br> 
(식5) <a href="https://www.codecogs.com/eqnedit.php?latex=p_2(v_j|v_i)&space;=&space;\frac{exp(\vec{u_j'}^T\cdot&space;\vec{u}_i)}{\sum_{k=1}^{|V|}exp(\vec{u_k'}^T\cdot&space;\vec{u}_i)}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?p_2(v_j|v_i)&space;=&space;\frac{exp(\vec{u_j'}^T\cdot&space;\vec{u}_i)}{\sum_{k=1}^{|V|}exp(\vec{u_k'}^T\cdot&space;\vec{u}_i)}" title="p_2(v_j|v_i) = \frac{exp(\vec{u_j'}^T\cdot \vec{u}_i)}{\sum_{k=1}^{|V|}exp(\vec{u_k'}^T\cdot \vec{u}_i)}" /></a>

( 여기서 |V|는 vertice의 수를 나타낸다 )</br> </br> 
여기서 식(5)을 확장해서 적용하면, 


