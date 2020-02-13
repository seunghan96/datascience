# [ Decision Tree & Random Forest 요약 ]

## 1. Decision Tree
- 의사 결정 나무 : 질문에 맞게 data를 분류해나감 ( node & branch 구조 )
- classification & regression 모두 가능
- "어떠한 기준"을 가지고 data를 구분해나가야 잘 구분했다고 할 수 있는가? </br> 
 ( "특정 값 이상/이하를 묻는 numeric 기준" & "특정 클래스에 속하는지 여부를 묻는 categorical 기준" 모두 가능 ) </br> </br>
<img src="https://miro.medium.com/max/564/0*ToYXqRes95eMvIKV.png" width="330" /> </br>
https://miro.medium.com/max/564/0*ToYXqRes95eMvIKV.png
</br>

**Terminology** 
- root node : 뿌리 node, 가장 시작이 되는 node ( 모든 데이터가 포함되어있음 ) </br>
- decision node : (특정 기준을 가지고) split이 이루어지는 node </br>
- terminal node : 더 이상 split이 발생하지 않는 최하단의 node </br>
<img src="https://miro.medium.com/max/688/1*bcLAJfWN2GpVQNTVOCrrvw.png" width="550" /> </br>
https://miro.medium.com/max/688/1*bcLAJfWN2GpVQNTVOCrrvw.png
</br>

**Classification & Regression**
- classification : data가 속하게 될 최종 predicted class를, 각 data가 속한 terminal node의 "major vote"에 따라 결정
- regression : data가 속하게 될 최종 predicted value를, 각 data가 속한 terminal node의 "y값의 평균"에 따라 결정
</br>

**Split Criterion ( = Impurity Measures )**
- "split을 얼마나 잘 했는지 평가하는 지표!" </br>
 ( 어떠한 질문을 던져서 data를 node에서 split해 나갈 때, split을 잘했다고 할 수 있가? )
- 해결하고자 하는 문제가 classification이냐, regression이냐에 따라 다름!

- ex) regression ( response variable : numerical ): RSS (Residual Sum of Squares) </br>
      classification ( response variable : categorical ) : Gini Index(지니계수), Entropy,  χ2 -statistics
</br>

#### (1) Gini Index
<a href="https://www.codecogs.com/eqnedit.php?latex=I(A)&space;=&space;1&space;-&space;\sum_{k=1}^{m}p_k^2" target="_blank"><img src="https://latex.codecogs.com/gif.latex?I(A)&space;=&space;1&space;-&space;\sum_{k=1}^{m}p_k^2" title="I(A) = 1 - \sum_{k=1}^{m}p_k^2" /></a> </br>
- 작을 수록 좋은 split
- p = (split 기준에 의해 나누어진) 구역에 속하는 class k의 비율
- I(A) = 0 ( 해당 구역에 전부 동일한 class의 데이터들만 있을 때 ) -> 최상
- 모든 class가 동일하게 하나의 구역에 있을 때 최대의 값을 가짐 -> 최악 </br>
<img src="https://miro.medium.com/max/1794/1*F_AmlAXtZRNP3lRupjX24A.jpeg" width="550" /> </br>
https://miro.medium.com/max/1794/1*F_AmlAXtZRNP3lRupjX24A.jpeg </br>

간단한 예시로 위 그림을 참고하면, A보다 B의 split이 더 잘 이루어진 것을 확인할 수 있다. 직관적으로 보면, B의 split에서 N1(node1)는 C1를 대표하고(C1은 4개, C0는 1개), N2(node2)는 C0를 대표(C0는 5개, C1는 2개)한다고 할 수 있다. 이에 반해 A의 split은 두 개의 node(N1,N2)에 C1과 C2가 골고루 섞여들어가있는, 즉 잘 분류해내지 못한 것을 확인할 수 있다. 이를 수치적으로 Gini Index를 통해 확인해보면, A split에서의 두 개의 node에서는 각각 0.4898, 0.480의 gini index로 대표되는 불순도 값을 가지지만, B split에서는 각각 0.320, 0.4082로 A split보다 더 낫다는 것을 알 수 있다. Tree들을 비교하는 데에 있어서, 생기기 되는 모든 node들의 gini index값을 평균내서 사용한다. </br>

#### (2) Entropy

(1) Gini Index와 (2) Entropy 두 개의 impurity measures를 보면 알 수 있 듯, 모든 데이터가 "완벽히 분류"될 때 까지 계속 split을 해나간다면 최상의 결과, 즉 가장 낮은 impurity값을 가질 수 있다. 하지만, 이는 overfitting 문제를 가져올 수 있다. 그렇기 떄문에 반드시 split이 많이 이루어진 fully grown tree가 최상이라고 할 수 없다. 이를 해결하기 위한 방법에는 여러가지가 있다.


### **Avoid Overfitting**


