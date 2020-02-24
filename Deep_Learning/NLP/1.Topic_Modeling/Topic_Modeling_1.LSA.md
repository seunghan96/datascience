# [ Topic Modeling ]
Topic Modeling은 말 그대로 글 속의 숨겨진 "주제"를 통계적인 기법을 사용해서 찾아내는 것이라고 할 수 있다. </br>
이러한 Topic Modeling의 방법에는 크게 (1) **LSA** (Latent Semantic Analysis, 잠재의미분석)와, (2) **LDA** (Latent Dirichlet Allocation)가 있다.

# 1. LSA

## 1) Introduction
- Topic Modeling에 아이디어를 제공한 알고리즘
- 등장 배경 : DTM(Document-Term Matrix), TF-IDF(Term-Frequency Inverse Document Matrix) 등은 '단어의 빈도 수'를 기반으로 하지만, '단어의 의미'는 고려하지 못함. 그래서 이를 위한
대안으로, DTM의 잠재된(latent) 의미를 끌어내는 방법으로서 등장!
- 추후, LDA가 LSA의 단점을 보완!
</br>

## 2) Singular Value Decomposition
- LSA의 경우, SVD ( Singular Value Decomposition, 특이값 분해 )를 이용한다 </br>

#### SVD (Singular Value Decomposition)
A가 mxn의 행렬일 때, 다음과 같이 3개의 행렬 곱으로 분해하는 것! 
</br></br>
<a href="https://www.codecogs.com/eqnedit.php?latex=A&space;=&space;UDV^T" target="_blank"><img src="https://latex.codecogs.com/gif.latex?A&space;=&space;UDV^T" title="A = UDV^T" /></a>
</br></br>
( 구체적인 내용은 선형대수학을 참고! )
</br>
</br>

## 3) Truncated SVD
- LSA의 경우, Full SVD에서 나온 3개의 행렬에서, 일부 벡터들을 삭제시킨 'Truncated SVD(절단된 SVD)"를 사용한다
- Truncated SVD는 대각 행렬 D의 대각 원소의 값 중, 상위값 t개만 남기고 나머지는 지운다 </br>
  ( Truncated SVD를 만들면, 값의 손실이 발생하는 것은 불가피 하다 )
- 마찬가지로, U 행렬과 V행렬도 t열까지만 남기고 지운다
- 여기서 't'는, 우리가 찾고자 하는 Topic의 수를 반영한 hyperparameter이다 </br>
  ( t를 크게 잡으면 기존의 행렬 A로부터 다양한 의미를 가져갈 수 있지만, t를 작게 잡아야 노이즈를 제거할 수 있다 )

```python
s = "Python syntax highlighting"
print s
```
