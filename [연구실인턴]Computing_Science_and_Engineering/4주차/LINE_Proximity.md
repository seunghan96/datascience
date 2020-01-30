# LINE (Large-scale Information Network Embedding)
### Proximity : First-order Proximity & Second-order Proximity </br>  </br>

### 1. Line with First-order Proximity  </br>
이 proximity를 objective function으로 사용 하는 이유는, "나(하나의 vertex)랑 직접적으로 연결 되어있는 vertex(node)는 나와 가까운 위치에 임베딩
되도록 훈련하기 위해서"라고 할 수 있다. 그리고 이것은 두 node의 연결 여부 및 연결 강도만을 고려하기 때문에, undirected graph에서만 적용 가능하다.
수식적으로 살펴보자.  </br> 

하나의 undirected edge (i,j)가 있다고 하자. 이 edge의 양 끝에 연결된 두 개의 vertex는 vi와 vj이고, </br> 
이 둘의 joint probability는 다음과 같다.  ( 아래 식에서 ui는 vertex vi의 embedding 이후의 low-dimensional 표현이다 ) </br> </br>
(식1) <a href="https://www.codecogs.com/eqnedit.php?latex=p_1(v_i,v_j)&space;=&space;\frac{1}{1&plus;exp(-\vec{u}_i^T\cdot\vec{u}_j)}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?p_1(v_i,v_j)&space;=&space;\frac{1}{1&plus;exp(-\vec{u}_i^T\cdot\vec{u}_j)}" title="p_1(v_i,v_j) = \frac{1}{1+exp(-\vec{u}_i^T\cdot\vec{u}_j)}" /></a>
 </br> </br>  
직관적으로 생각해서, 두 node의 vector의 내적 값이 크면, (즉 두 vector가 유사하면) 위 p값은 커질 것이고, 작아지면 p값도 작아질 것이다. 이 식을 다음과 같이 <a href="https://www.codecogs.com/eqnedit.php?latex=p(\cdot&space;,\cdot&space;)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?p(\cdot&space;,\cdot&space;)" title="p(\cdot ,\cdot )" /></a>로 줄여서 표현하자. 그리고 이것의 empirical probability는, 다음과 같이 '모든 edge들의 weight의 합에서 특정 edge의 weight가 차지하는 비중'으로 표현할 수 있다.
</br> </br>  
(식2) <a href="https://www.codecogs.com/eqnedit.php?latex=\hat{p}_i(i,j)&space;=&space;\frac{w_i_j}{W}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\hat{p}_i(i,j)&space;=&space;\frac{w_i_j}{W}" title="\hat{p}_i(i,j) = \frac{w_i_j}{W}" /></a>
</br> </br>  
그러므로, first order proximity를 잘 반영한 objective function은 다음과 같이 두개의 
