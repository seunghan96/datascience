# [ Decision Tree & Random Forest 요약 ]

## 1. Decision Tree
- 의사 결정 나무 : 질문에 맞게 data를 분류해나감 ( node & branch 구조 )
- classification & regression 모두 가능
- "어떠한 기준"을 가지고 data를 구분해나가야 잘 구분했다고 할 수 있는가?
</br>

**Terminology** 
- root node : 뿌리 node, 가장 시작이 되는 node ( 모든 데이터가 포함되어있음 ) </br>
- decision node : (특정 기준을 가지고) split이 이루어지는 node </br>
- terminal node : 더 이상 split이 발생하지 않는 최하단의 node </br>
</br>

**Classification & Regression**
- classification : data가 속하게 될 최종 predicted class를, 각 data가 속한 terminal node의 "major vote"에 따라 결정
- regression : data가 속하게 될 최종 predicted value를, 각 data가 속한 terminal node의 "y값의 평균"에 따라 결정
</br>

**Split Criterion**
- "split을 얼마나 잘 했는지 평가하는 지표!" </br>
 ( 어떠한 질문을 던져서 data를 node에서 split해 나갈 때, split을 잘했다고 할 수 있가? )
- 해결하고자 하는 문제가 classification이냐, regression이냐에 따라 다름!

- ex) regression ( response variable : numerical ): RSS (Residual Sum of Squares) </br>
      classification ( response variable : categorical ) : Gini Index(지니계수), Entropy,  χ2 -statistics
</br>

#### (1) Classification Tree 

#### (2) Regression Tree

