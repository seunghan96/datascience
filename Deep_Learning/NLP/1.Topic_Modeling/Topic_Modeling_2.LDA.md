# [ Topic Modeling ]
Topic Modeling은 말 그대로 글 속의 숨겨진 "주제"를 통계적인 기법을 사용해서 찾아내는 것이라고 할 수 있다. </br>
이러한 Topic Modeling의 방법에는 크게 (1) **LSA** (Latent Semantic Analysis, 잠재의미분석)와, (2) **LDA** (Latent Dirichlet Allocation)가 있다.

# 2. LDA

## 1) Introduction
- 가정 : "문서는 Topic들의 혼합으로 구성되어 있고", "각각의 Topic은 확률 분포에 기반하여 단어를 생성" </br>
 ( "나는 문서 작성을 위해서, 이러한 주제들을 넣을것이고, 이런 주제들을 이루기 위해 이런 단어들을 넣을 것이야!" )
- 즉, 데이터가 주어지면 LDA는 '문서가 생성되넌 과정을 역추적'하는 것이라고 볼 수 있다
</br>

## 2) Assumption
각각의 문서는 다음과 같은 가정을 거쳐서 작성이 되었다고 가정함
- step 1) 문서에 사용할 단어의 개수 N을 정한다
- step 2) 문서에 사용할 Topic의 혼합을, 확률분포에 기반하여 결정한다 </br>
  ( ex. 스포츠 30%, 과일 40%, 연애 40% )
- step 3) 문서에 사용할 각 단어를 정함
- step 4) Topic 분포에서, topic T를 확률적으로 고른다 </br>
  ( ex. 스포츠는 30%의 확률로 뽑히고, 연애는 40%의 확률로 뽑힌다 )
- step 5) 선택된 topic T에서, 단어의 출현 확률 분포에 기반해서 문서에 사용할 단어를 고른다
</br>

## 3) LDA Algorithm
- step 1) LDA에게 Topic의 개수 k 입력 </br>
  ( 그러면, LDA는 k개의 토픽이 전체 문서들에 걸쳐 분포되어 있다고 가정한다 )
  
- step 2) 단어에 Topic 할당 </br>
  ( 모든 단어들에게 반드시 하나의 Topic을 랜덤하게 할당한다. 이러한 Topic을 이후 단계에서 계속 update할 것이다 )
  
- step 3) Topic Update  </br>
  ( 모든 단어들은, 자기 자신은 '잘못된' topic에 할당되었다고 생각하고, 자신을 제외한 나머지 단어들은 '옳은' topic에 할당되어 
  있다고 생각하고 update가 이루어진다. 각각의 단어들은 아래의 기준에 따라 topic이 update된다 )
 ```
 기준 1)  P( t | d ) : 문서 d의 단어 들 중, Topic t에 해당하는 단어들의 비율
 기준 2)  P( w | t ) : 단어 w를 가지고 있는 모든 문서들 중, Topic t가 할당된 비율
 ```
 
#### EXAMPLE
다음과 같이 apple, banana, dog, cute, book 등의 단어로 구성된 두 개의 문서가 있다고 해보자. 여기서, 우리는 첫 번째 문서 (doc1)의 세 번째 
단어인 apple을 update하고자 한다. ( 해당 단어 외의 나머지 단어들은 모두 topic이 '옳게' 할당되어 있다고 가정한다 )
</br>

<img src="https://wikidocs.net/images/page/30708/lda1.PNG" width="400" /> </br>
https://wikidocs.net/images/page/30708/lda1.PNG

기준 1)
- doc1의 (apple을 제외한) 4개의 단어는 각각 2개의 주제 A,B가 50:50으로 분포되어 있다. 따라서 apple은 Topic A,B에 모두 속할 가능성이 있다
</br>

기준 2)
- 'apple'이란 단어를 포함한 모든 문서(doc1,doc2) 각각에 어떤 Topic이 있는지를 확인해본다.
- 그 결과, doc1에서도 100% (1/1)로 topic B에 할당되어 있고, doc2에서도 100% (2/2)로 topic B에 할당되어 있는 것을 확인할 수 있다. 
- 이를 통해, doc1의 세 번째 단어인 apple을 'topic B'에 할당한다. 이러한 과정을 반복하여, 모든 단어들이 topic을 update해나간다.
