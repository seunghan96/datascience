# [ Decision Tree & Random Forest 요약 ]

## 1. Decision Tree
- 의사 결정 나무 : 질문에 맞게 data를 분류해나감 ( node & branch 구조 )
- classification & regression 모두 가능
- "어떠한 기준"을 가지고 data를 구분해나가야 잘 구분했다고 할 수 있는가? </br> 
 ( "특정 값 이상/이하를 묻는 numeric 기준" & "특정 클래스에 속하는지 여부를 묻는 categorical 기준" 모두 가능 ) </br> </br>
<img src="https://miro.medium.com/max/564/0*ToYXqRes95eMvIKV.png" width="330" /> </br>
https://miro.medium.com/max/564/0*ToYXqRes95eMvIKV.png
</br>

### (1) Terminology
- root node : 뿌리 node, 가장 시작이 되는 node ( 모든 데이터가 포함되어있음 ) </br>
- decision node : (특정 기준을 가지고) split이 이루어지는 node </br>
- terminal node : 더 이상 split이 발생하지 않는 최하단의 node </br>
</br>
<img src="https://miro.medium.com/max/688/1*bcLAJfWN2GpVQNTVOCrrvw.png" width="550" /> </br>
https://miro.medium.com/max/688/1*bcLAJfWN2GpVQNTVOCrrvw.png
</br>

### (2) Classification & Regression
- classification : data가 속하게 될 최종 predicted class를, 각 data가 속한 terminal node의 "major vote"에 따라 결정
- regression : data가 속하게 될 최종 predicted value를, 각 data가 속한 terminal node의 "y값의 평균"에 따라 결정
</br>

### (3) Split Criterion 
- "split을 얼마나 잘 했는지 평가하는 지표!" </br>
 ( 어떠한 질문을 던져서 data를 node에서 split해 나갈 때, split을 잘했다고 할 수 있가? )
- 사용하는 지표는, 해결하고자 하는 문제가 classification이냐, regression이냐에 따라 다름!
- impurity measures : classification에서의 split criterion </br>
  ( node에 얼마나 다양한 class의 데이터 들이 속해 있는지! 다양하다=불순하다 -> bad classification )
- ex) regression ( response variable : numerical ): RSS (Residual Sum of Squares) </br>
      classification ( response variable : categorical ) : Gini Index(지니계수), Entropy,  χ2 -statistics 
</br>

#### a. [Impurity Measure] Gini Index
<a href="https://www.codecogs.com/eqnedit.php?latex=I(A)&space;=&space;1&space;-&space;\sum_{k=1}^{m}p_k^2" target="_blank"><img src="https://latex.codecogs.com/gif.latex?I(A)&space;=&space;1&space;-&space;\sum_{k=1}^{m}p_k^2" title="I(A) = 1 - \sum_{k=1}^{m}p_k^2" /></a> </br>
- 작을 수록 좋은 split
- p = (split 기준에 의해 나누어진) 구역에 속하는 class k의 비율
- I(A) = 0 ( 해당 구역에 전부 동일한 class의 데이터들만 있을 때 ) -> 최상
- 모든 class가 동일하게 하나의 구역에 있을 때 최대의 값을 가짐 -> 최악 </br>
<img src="https://miro.medium.com/max/1794/1*F_AmlAXtZRNP3lRupjX24A.jpeg" width="550" /> </br>
https://miro.medium.com/max/1794/1*F_AmlAXtZRNP3lRupjX24A.jpeg </br>

간단한 예시로 위 그림을 참고하면, A보다 B의 split이 더 잘 이루어진 것을 확인할 수 있다. 직관적으로 보면, B의 split에서 N1(node1)는 C1를 대표하고(C1은 4개, C0는 1개), N2(node2)는 C0를 대표(C0는 5개, C1는 2개)한다고 할 수 있다. 이에 반해 A의 split은 두 개의 node(N1,N2)에 C1과 C2가 골고루 섞여들어가있는, 즉 잘 분류해내지 못한 것을 확인할 수 있다. 이를 수치적으로 Gini Index를 통해 확인해보면, A split에서의 두 개의 node에서는 각각 0.4898, 0.480의 gini index로 대표되는 불순도 값을 가지지만, B split에서는 각각 0.320, 0.4082로 A split보다 더 낫다는 것을 알 수 있다. Tree들을 비교하는 데에 있어서, 생기기 되는 모든 node들의 gini index값을 평균내서 사용한다. </br>
</br>

#### b. [Impurity Measure] Entropy & Information Gain
<a href="https://www.codecogs.com/eqnedit.php?latex=entropy(A)&space;=&space;-&space;\sum_{k=1}^{m}p_klog_2(p_k)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?entropy(A)&space;=&space;-&space;\sum_{k=1}^{m}p_klog_2(p_k)" title="entropy(A) = - \sum_{k=1}^{m}p_klog_2(p_k)" /></a> </br>
[Entropy]
- p = (split 기준에 의해 나누어진) 구역에 속하는 class k의 비율 ( gini index의 p값과 동일 )
- (최상) 0 ~ (최악) log2(m) ( m : class의 종류 수 ) </br>

[Information Gain]
- split에 의해 얼마나 entropy를 줄였는지! (아래 예시 통해 확인)
</br>

<img src="https://steemitimages.com/640x0/http://www.grroups.com/uploads_media/1f21ba57ce751fd55c3a80e9090d01db%20%281%29.png" width="470" /> </br> 
https://steemitimages.com/640x0/http://www.grroups.com/uploads_media/1f21ba57ce751fd55c3a80e9090d01db%20%281%29.png
</br>
위의 예시처럼, 각각의 node별로 entropy값을 구할 수 있다. 30개의 data가 parent node에 있고, 어떠한 기준에 의해 이 데이터가 각각 17개,13개로 두 개의 child node로 split되었다. 이때, parent node(30개)의 entropy는 0.996, child node1(17개)의 entropy는 0.78, child node2(13개)의 entropy는 0.39이다. 나누어진 두 개의 child node들의 weighted(data 개수에 대해) average entropy는 0.615이다. 즉, 이번 split을 통해 0.996-0.615=0.381만큼의 entropy 값을 줄인 것이다. 이 값(0.381)이 바로 information gain이다.
</br>

### overfitting problem
위 impurity measures ( (1) Gini Index와 (2) Entropy & Information )를 보면 알 수 있 듯, 모든 데이터가 "완벽히 분류"될 때 까지 계속 split을 해나간다면 최상의 결과, 즉 가장 낮은 impurity값을 가질 수 있다. 하지만, 이는 overfitting 문제를 가져올 수 있다. 그렇기 떄문에 반드시 split이 많이 이루어진 fully grown tree가 최상이라고 할 수 없다. 이를 해결하기 위한 방법에는 여러 가지가 있다.


## (3) **Avoid Overfitting**
tree가 지나치게 커지는 것(즉, 너무 많은 split을 하는 것)을 방지하기 위한 방법으로 크게 (1)pre-pruning(사전 가지치기)와 (2)post-pruning(사후 가지치기)가 있다. 말 그대로 pre-pruning은 나무의 성장이 어느 정도 수준에 도달하면 더 이상 split을 하지 않는 것을 말하고, post-pruning은 일단 나무를 끝까지 다 만들고 난 이후 일정 기준으로 가지치기를 하는 것을 말한다. 그 중에서 (1) pre-pruning에 대해 다룰 것이다.
</br>
<img src="https://www.isip.piconepress.com/courses/msstate/ece_8463/lectures/current/lecture_27/lecture_27_07_00.gif" width="450" /> </br>
https://www.isip.piconepress.com/courses/msstate/ece_8463/lectures/current/lecture_27/lecture_27_07_00.gif

#### [prepruning] cost complexity pruning
단어 cost complexity에서 알 수 있듯 complexity(복잡도 / 복잡하다=split이 많이 이루어진다=node수가 많아진다)에 cost(=penalty)를 부여하는 개념이다. 이는 node의 개수에 따라 cost를 부과하는 방식으로 tree의 과도한 성장을 막을 수 있다. 수식을 보면 다음과 같다.</br>
<a href="https://www.codecogs.com/eqnedit.php?latex=CC(T)&space;=&space;Err(T)&space;&plus;&space;\alpha&space;L(T)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?CC(T)&space;=&space;Err(T)&space;&plus;&space;\alpha&space;L(T)" title="CC(T) = Err(T) + \alpha L(T)" /></a> </br> </br>
- CC(T) = cost complexity of tree
- Err(T) = proportion of misclassified data in the training dataset
- L(T) = number of leaves(=nodes)
- alpha : **penalty factor**
</br>
위 식을 통해서 계산된 cost complexity (=CC(T))가 가장 낮은 경우를 고르면, 이전 보다는 overfitting이 어느 정도 해소된 tree를 만들 수 있을 것이다.


