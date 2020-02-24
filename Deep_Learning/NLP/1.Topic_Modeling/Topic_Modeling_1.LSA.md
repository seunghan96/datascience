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
</br>

## 4) SVD with python

```python
import numpy as np
A=np.array([[0,0,0,1,0,1,1,0,0],[0,0,0,1,1,0,1,0,0],[0,1,1,0,2,0,0,0,0],[1,0,0,0,0,0,0,1,1]])
A, A.shape

(array([[0, 0, 0, 1, 0, 1, 1, 0, 0],
        [0, 0, 0, 1, 1, 0, 1, 0, 0],
        [0, 1, 1, 0, 2, 0, 0, 0, 0],
        [1, 0, 0, 0, 0, 0, 0, 1, 1]]), (4, 9))
```

### a. Full SVD
```python
U, s, VT = np.linalg.svd(A, full_matrices = True)
U.shape, s.shape, VT.shape


((4, 4), (4,), (9, 9))
```

```python
U.round(2)

array([[-0.24,  0.75,  0.  , -0.62],
       [-0.51,  0.44, -0.  ,  0.74],
       [-0.83, -0.49, -0.  , -0.27],
       [-0.  , -0.  ,  1.  ,  0.  ]])
```

```python
s.round(2)

array([2.69, 2.05, 1.73, 0.77])
```

### b. Truncated SVD
- t를 2로 정하여 Full SVD를 truncate

```python
S_ = S[:2,:2]
U_ = U[:,:2]
VT_ = VT[:2,:]
```

- U,S,V가 절단된 것을 확인할 수 있다
```python
U_

array([[-2.39751712e-01,  7.51083898e-01],
       [-5.06077194e-01,  4.44029376e-01],
       [-8.28495619e-01, -4.88580485e-01],
       [-9.04299898e-17, -4.11929620e-17]])
```

```
S_

array([[2.68731789, 0.        ],
       [0.        , 2.04508425]])
```
</br>

## 5. 실습 (fetch_20newsgroups)
### (1) import dataset
```python
import pandas as pd
from sklearn.datasets import fetch_20newsgroups
dataset = fetch_20newsgroups(shuffle=True,random_state=1, remove=('headers','footers','quotes'))
documents = dataset.data
```

- 총 11,314개의 문서가 있음을 확인할 수 있다
```python
len(documents)

11314
```

- 그 중 첫 번째 문서 확인
```
documents[1]

"\n\n\n\n\n\n\nYeah, do you expect people to read the FAQ, etc. and actually accept hard\natheism?  No, you need a little leap of faith, Jimmy.  Your logic runs out\nof steam!\n\n\n\n\n\n\n\nJim,\n\nSorry I can't pity you, Jim.  And I'm sorry that you have these feelings of\ndenial about the faith you need to get by.  Oh well, just pretend that it will\nall end happily ever after anyway.  Maybe if you start a new newsgroup,\nalt.atheist.hard, you won't be bummin' so much?\n\n\n\n\n\n\nBye-Bye, Big Jim.  Don't forget your Flintstone's Chewables!  :) \n--\nBake Timmons, III"
```

- 문서의 주제들
```
dataset.target_names

['alt.atheism',
 'comp.graphics',
 'comp.os.ms-windows.misc',
 'comp.sys.ibm.pc.hardware',
 'comp.sys.mac.hardware',
 'comp.windows.x',
 'misc.forsale',
 'rec.autos',
 'rec.motorcycles',
 'rec.sport.baseball',
 'rec.sport.hockey',
 'sci.crypt',
 'sci.electronics',
 'sci.med',
 'sci.space',
 'soc.religion.christian',
 'talk.politics.guns',
 'talk.politics.mideast',
 'talk.politics.misc',
 'talk.religion.misc']
```
</br>

### (2) data preprocessing
- 1) 영어가 아닌 모든 글자들은 공백으로 대체
- 2) 네 글자 이상의 단어들만 남기고 지우기
- 3) 모두 소문자로
```
news_df = pd.DataFrame({'document':documents})

news_df['clean_doc'] = news_df['document'].str.replace("[^a-zA-Z]", " ")
news_df['clean_doc'] = news_df['clean_doc'].apply(lambda x: ' '.join([w for w in x.split() if len(w)>3]))
news_df['clean_doc'] = news_df['clean_doc'].apply(lambda x: x.lower())
```

- BEFORE (전처리 이전)
```
news_df['document'][1]

"\n\n\n\n\n\n\nYeah, do you expect people to read the FAQ, etc. and actually accept hard\natheism?  No, you need a little leap of faith, Jimmy.  Your logic runs out\nof steam!\n\n\n\n\n\n\n\nJim,\n\nSorry I can't pity you, Jim.  And I'm sorry that you have these feelings of\ndenial about the faith you need to get by.  Oh well, just pretend that it will\nall end happily ever after anyway.  Maybe if you start a new newsgroup,\nalt.atheist.hard, you won't be bummin' so much?\n\n\n\n\n\n\nBye-Bye, Big Jim.  Don't forget your Flintstone's Chewables!  :) \n--\nBake Timmons, III"
```

- AFTER (전처리 이후)
```
news_df['clean_doc'][1]

'yeah expect people read actually accept hard atheism need little leap faith jimmy your logic runs steam sorry pity sorry that have these feelings denial about faith need well just pretend that will happily ever after anyway maybe start newsgroup atheist hard bummin much forget your flintstone chewables bake timmons'
```

- 불용어 (stop words) 처리 </br>
'the','a','she'등. 어디에나 자주 등장하여 주제를 결정하는 데에 영향을 미친다고 보기 어려운 용어들을 제거해준다! </br>
불용어 처리를 위해, 문서를 tokenize해준다 ( = 단어 단위로 split한다 )
```
from nltk.corpus import stopwords

stop_words = stopwords.words('english') # 1) 불용어 설정
tokenized_doc = news_df['clean_doc'].apply(lambda x : x.split()) # 2) tokenize
tokenized_doc = tokenized_doc.apply(lambda x : [item for item in x if item not in stop_words])
```
</br>

### (3) TF-IDF matrix
- 지금까지, 불용어를 제거하기 위해 tokenize했었다
- 하지만 TFIDF-Vectorizer는 (token화 되지 않은) text data를 입력으로 받기 때문에, 다시 역토큰화(Detokenization)을 해줘야 한다

```
detokenized_doc = []

for i in range(len(news_df)):
    t = ' '.join(tokenized_doc[i]) # token화된 단어들을 다시 연결시켜줌
    detokenized_doc.append(t)

news_df['clean_doc'] = detokenized_doc
news_df['clean_doc'][1]


'yeah expect people read actually accept hard atheism need little leap faith jimmy logic runs steam sorry pity sorry feelings denial faith need well pretend happily ever anyway maybe start newsgroup atheist hard bummin much forget flintstone chewables bake timmons'
```
( token화된 단어들이 다시 연결(detokenizeed)된 것을 확인할 수 있다 )

- 이렇게 연결된 단어들을 이제 TFIDF Vectorizer에 집어 넣는다.
- hyperparameter :  </br>
  max_features = 1000 ( 상위 1000개 단어만 보존한다 ) </br>
  max_df = 0.5 ( 전체 문서의 50% 이상에서 등장하는 단어들은 제외한다 ) </br>
  smooth_idf = True ( smoothing term! document frequency에 +1을 해준다 )

```
from sklearn.feature_extraction.text import TfidfVectorizer

vectorizer = TfidfVectorizer(stop_words='english',
                            max_features=1000, 
                            max_df = 0.5,
                             smooth_idf=True)

X = vectorizer.fit_transform(news_df['clean_doc'])
X.shape

(11314, 1000)
```
- (row) 11314개의 document
- (col) 상위 1000개
</br>

### (4) Topic Modeling
- 위에서 만들어진 TF-IDF 행렬을, Truncated SVD를 이용하여 분해한다
- 원래 기존 news data가 20개의 news category를 가지고 있었기 때문에, 20개의 topic을 가졌다고 가정하고 Topic Modeling을 한다 </br>
  ( topic의 숫자는 hyperparameter 'n_components'로 지정해준다 )
  
```
from sklearn.decomposition import TruncatedSVD

svd_model = TruncatedSVD(n_components=20, algorithm='randomized',
                        n_iter=100,random_state=122)
svd_model.fit(X)
```

- 20개의 topic이, 1000개의 단어의 일정 비율의 합으로 이루어진 것을 확인할 수 있다!
```
svd_model.components_.shape

(20, 1000)
```

```
terms = vectorizer.get_feature_names()
len(terms)

1000
```
</br>

### (5) Result
- 각각의 (20개의) 주제가 어떠한 단어들로 구성되었는지 확인할 수 있다
```
def get_topics(components, feature_names, n=5):
    for idx, topic in enumerate(components):
        print("Topic %d :" %(idx+1), [(feature_names[i], topic[i].round(3)) for i in topic.argsort()[:-n-1:-1]])

get_topics(svd_model.components_, terms)

Topic 1 : [('like', 0.214), ('know', 0.2), ('people', 0.193), ('think', 0.178), ('good', 0.151)]
Topic 2 : [('thanks', 0.329), ('windows', 0.291), ('card', 0.181), ('drive', 0.175), ('mail', 0.151)]
Topic 3 : [('game', 0.371), ('team', 0.324), ('year', 0.282), ('games', 0.254), ('season', 0.184)]
Topic 4 : [('drive', 0.533), ('scsi', 0.202), ('hard', 0.156), ('disk', 0.156), ('card', 0.14)]
Topic 5 : [('windows', 0.404), ('file', 0.254), ('window', 0.18), ('files', 0.161), ('program', 0.139)]
Topic 6 : [('chip', 0.161), ('government', 0.16), ('mail', 0.156), ('space', 0.151), ('information', 0.136)]
Topic 7 : [('like', 0.671), ('bike', 0.142), ('chip', 0.112), ('know', 0.111), ('sounds', 0.104)]
Topic 8 : [('card', 0.466), ('video', 0.221), ('sale', 0.213), ('monitor', 0.155), ('offer', 0.146)]
Topic 9 : [('know', 0.46), ('card', 0.336), ('chip', 0.176), ('government', 0.152), ('video', 0.144)]
Topic 10 : [('good', 0.428), ('know', 0.23), ('time', 0.188), ('bike', 0.114), ('jesus', 0.09)]
Topic 11 : [('think', 0.785), ('chip', 0.109), ('good', 0.106), ('thanks', 0.091), ('clipper', 0.079)]
Topic 12 : [('thanks', 0.368), ('good', 0.227), ('right', 0.216), ('bike', 0.21), ('problem', 0.209)]
Topic 13 : [('good', 0.362), ('people', 0.34), ('windows', 0.284), ('know', 0.262), ('file', 0.184)]
Topic 14 : [('space', 0.399), ('think', 0.233), ('know', 0.181), ('nasa', 0.152), ('problem', 0.13)]
Topic 15 : [('space', 0.316), ('good', 0.309), ('card', 0.226), ('people', 0.175), ('time', 0.145)]
Topic 16 : [('people', 0.482), ('problem', 0.2), ('window', 0.153), ('time', 0.147), ('game', 0.129)]
Topic 17 : [('time', 0.345), ('bike', 0.273), ('right', 0.256), ('windows', 0.2), ('file', 0.191)]
Topic 18 : [('time', 0.597), ('problem', 0.155), ('file', 0.15), ('think', 0.128), ('israel', 0.109)]
Topic 19 : [('file', 0.442), ('need', 0.266), ('card', 0.184), ('files', 0.175), ('right', 0.154)]
Topic 20 : [('problem', 0.33), ('file', 0.277), ('thanks', 0.236), ('used', 0.192), ('space', 0.132)]
```
</br>

## 6) LSA의 장.단점
장점
- 쉽고 빠르게 구현 가능하다
- 단어의 잠재적 의미를 이끌어낼 수 있다
- 문서의 유사도 계산 등에서 좋은 성능을 보인다
</br>

단점
- 새로운 데이터가 가될 경우, 다시 계산해야한다 </br>
 ( 새로운 정보 update가 어려움! LSA 보다 word2vec등이 인기 있는 이유 )
