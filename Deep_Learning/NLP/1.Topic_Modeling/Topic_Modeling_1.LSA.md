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
