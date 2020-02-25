# [ BLEU ( Bilingual Evaluation Understudy Score ) ]
BLEU는 기계 번역(Neural Machine Translation)의 성능이 얼마나 뛰어난지 측정하는 대표적인 score이다. 이번 포스트의 목적은, BLEU
의 개념에 대해 이해하고 이를 python code로 구현하는 것이다.
</br>

## 1. Introduction
### BLEU 요약
- key idea : 기계 번역 결과와, 사람이 직접 번역한 결과가 얼마나 유사한지 측정
- 측정 기준 : n-gram에 기반
- 장점 : 언어에 구애 받지 않고, 속도가 빠르다
- 높을수록 좋은 성능을 의미

### BLEU 식
</br>
<a href="https://www.codecogs.com/eqnedit.php?latex=BLEU&space;=&space;exp(\sum_{n=1}^{N}w_nlogp_n)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?BLEU&space;=&space;exp(\sum_{n=1}^{N}w_nlogp_n)" title="BLEU = exp(\sum_{n=1}^{N}w_nlogp_n)" /></a>
</br>
</br>
어떻게 해서 위와 같은 식이 나오게 되었는지 알아보자.
</br>
</br>
</br>

## 2. Unigram Precision (단어 개수 count로 측정)
우선, BLEU score를 구하기 위해 '기계가 번역한 문장'(Ca (Candidate))와,
'사람이 번역한 문장'(Ref (Reference))이 있어야 한다. 간단한 예시로, 다음과 같은 2개의 Ca 와 3개의 Ref가 있다고 하자.  </br>

```
- Ca1 : It is a guide to action which ensures that the military always obeys the commands of the party.

- Ca2 : It is to insure the troops forever hearing the activity guidebook that party direct.

- Ref1 : It is a guide to action that ensures that the military will forever heed Party commands.

- Ref2 : It is the guiding principle which guarantees the military forces always being under the command of the Party.

- Ref3 : It is the practical guide for the army always to heed the directions of the party.
```
</br>

우리의 목표는 이 두 개의 기계가 번역한 문장(Ca)중 어느 것이 실제 정답이라고 할 수 있는 '사람이 번역한 문장(Ref)'와 유사한지 
측정하여 가장 잘 번역한 문장을 채택하는 것이다. 이를 판단하기 위한 지표인 Unigram Precision의 식은 다음과 같다
</br>
</br>
<a href="https://www.codecogs.com/eqnedit.php?latex=Unigram\;&space;Precision&space;=&space;\frac{the\;&space;number\;&space;of\;Ca\;words(unigrams)\;which\;occur\;in\;any\;Ref}{the\;total\;number\;of\;words\;in\;the\;Ca}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?Unigram\;&space;Precision&space;=&space;\frac{the\;&space;number\;&space;of\;Ca\;words(unigrams)\;which\;occur\;in\;any\;Ref}{the\;total\;number\;of\;words\;in\;the\;Ca}" title="Unigram\; Precision = \frac{the\; number\; of\;Ca\;words(unigrams)\;which\;occur\;in\;any\;Ref}{the\;total\;number\;of\;words\;in\;the\;Ca}" /></a>
</br>
</br>
Ca1 문장의 18개의 단어 중, 1개를 제외한 17개의 단어가 Ref1,Ref2,Ref3 중 하나에 포함되어 있다. 따라서, Ca1의 Unigram Precision
은 17/18이라고 할 수 있다. 이와 같은 방식으로 Ca2의 Unigram Precision을 구하면, 8/14가 나온다. 이 기준에 따르면, Ca1이 Ca2보다 더 나은 
번역이라고 할 수 있다.
</br>
하지만 이와 같은 방법에는 한계가 있는데, 뒤에서 알아보자.
</br>
</br>
</br>

## 3. Modified Unigram Precision
key idea : "중복을 제거함으로써 보정하기"
</br>
### Unigram Precision의 문제점
아래와 같은 candidate 문장은 번역이 매우 엉망임에도 불구하고 Unigram Precision score는 1로, 최고의 번역으로 평가받게된다.
</br>
```
- Ca : the the the the the the the

- Ref1 : the cat is on the mat

- Ref2 : there is a cat on the mat

```
candiadate에는 'the'라는 단어가 7번 나온 것이 전부인데, 'the'라는 문장이 모두 Ref1,Ref2에 등장하여 Unigram Precision Score이 1이 되었다. 따라서 이를 측정할 새로운 count 방법이 필요하다. 이를 해결하기 위해 앞서 봤던 Unigram Precision 식의 count를 다음과 같이 수정한다
</br>
</br>
<a href="https://www.codecogs.com/eqnedit.php?latex=Count_{clip}&space;=&space;min(Count,\;&space;Max\_Ref\_Count)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?Count_{clip}&space;=&space;min(Count,\;&space;Max\_Ref\_Count)" title="Count_{clip} = min(Count,\; Max\_Ref\_Count)" /></a>
</br>
</br>
여기서 max_ref_count는, 최대로 많이 등장한 ref에서의 count를 의미한다. 앞의 예시에 적용하자면, ca의 'the'가 ref1에서는 2번, ref2에서는 1번 사용되었기 떄문에 max_ref_count는 2가 된다. 따라서 count값은 기존에는 7이었지만, 이제는 min(7,2)=2로 줄어들게 됨을 확인할 수 있다. 이와 같은 count방식을 통해 중복을 제거할 수 있다. 위 count식을 기존의 unigram precision에 넣은 것을 'Modified Unigram Precision'이라하고, 식으로 정리하면 다음과 같다.
</br>
</br>
<a href="https://www.codecogs.com/eqnedit.php?latex=Modified\;Unigram\;&space;Precision&space;=&space;\frac{\sum_{unigram&space;\in&space;Candiate}^{&space;}Count_{clip}(unigram)}{\sum_{unigram&space;\in&space;Candiate}^{&space;}Count(unigram)}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?Modified\;Unigram\;&space;Precision&space;=&space;\frac{\sum_{unigram&space;\in&space;Candiate}^{&space;}Count_{clip}(unigram)}{\sum_{unigram&space;\in&space;Candiate}^{&space;}Count(unigram)}" title="Modified\;Unigram\; Precision = \frac{\sum_{unigram \in Candiate}^{ }Count_{clip}(unigram)}{\sum_{unigram \in Candiate}^{ }Count(unigram)}" /></a>
</br>
</br>
이에 따르면, 기존의 Ref1의 score는 1(=7/7)에서 2/7로 보정되게 된다.
</br>
</br>
</br>

## 4. Modified Unigram Precision 구현
```
from collections import Counter
import numpy as np
from nltk import ngrams
```
</br>

- token 속의 n-gram을 count해주는 함수
```
def simple_count(tokens,n):
    return Counter(ngrams(tokens,n))
```

```
Counter(ngrams('I want rice with kimchi',2))

Counter({('I', ' '): 1,
         (' ', 'w'): 2,
         ('w', 'a'): 1,
         ('a', 'n'): 1,
         ('n', 't'): 1,
         ('t', ' '): 1,
         (' ', 'r'): 1,
         ('r', 'i'): 1,
         ('i', 'c'): 1,
         ('c', 'e'): 1,
         ('e', ' '): 1,
         ('w', 'i'): 1,
         ('i', 't'): 1,
         ('t', 'h'): 1,
         ('h', ' '): 1,
         (' ', 'k'): 1,
         ('k', 'i'): 1,
         ('i', 'm'): 1,
         ('m', 'c'): 1,
         ('c', 'h'): 1,
         ('h', 'i'): 1})
```
</br>

#### Example 1
```
candidate = "It is a guide to action which ensures that the military always obeys the commands of the party."

tokens = candidate.split()
result = simple_count(tokens, 1) # n=1 : Unigram
print(result)

Counter({('the',): 3, ('It',): 1, ('is',): 1, ('a',): 1, ('guide',): 1, ('to',): 1, ('action',): 1, ('which',): 1, ('ensures',): 1, ('that',): 1, ('military',): 1, ('always',): 1, ('obeys',): 1, ('commands',): 1, ('of',): 1, ('party.',): 1})
```

#### Example 2
```
candidate2 = 'the the he he the the the'

tokens2 = candidate2.split() 
result2 = simple_count(tokens2, 1)
print(result2)

Counter({('the',): 5, ('he',): 2})
```
</br>

#### count_clip : 단순 count대신, 수정된 count
```
def count_clip(ca,ref_list,n):
    ca_cnt = simple_count(ca,n)
    temp= dict()
    
    for ref in ref_list:
        ref_cnt = simple_count(ref,n)
        
        for n_gram in ref_cnt:
            if n_gram in temp:
                temp[n_gram] = max(ref_cnt[n_gram], temp[n_gram])
            else:
                temp[n_gram] = ref_cnt[n_gram]
    
    return {n_gram:min(ca_cnt.get(n_gram,0),temp.get(n_gram,0))
           for n_gram in ca_cnt}
```

```
ca = 'the the the the the the the'

ref_list = [
    'the cat is on the mat',
    'there is a cat on the mat'
]
```

```
result = count_clip(ca.split(), list(map(lambda ref: ref.split(), ref_list)),1)
print(result)

{('the',): 2}
```
</br>

#### Modified Precision
```
def mod_precision(ca,ref_list,n):
    # 분자
    clip = count_clip(ca,ref_list,n)
    total_clip = sum(clip.values())
    
    # 분모
    ct = simple_count(ca,n)
    total_ct = sum(ct.values())
    
    if total_ct ==0:
        total_ct=1
    
    return (total_clip/total_ct)        
```

```
result3 = mod_precision(ca.split(),list(map(lambda ref: ref.split(), ref_list)),1)
reslut3

0.2857142857142857
```
</br>
</br>

## 5. N-gram
"순서를 고려"하기 위해, 기존의 unigram을 n-gram으로 확장하여 BLEU score를 계산할 수 있다. 이전과 같이 예시를 통해 이해해보자.
```
- Ca1 : It is a guide to action which ensures that the military always obeys the commands of the party.

- Ca2 : It is to insure the troops forever hearing the activity guidebook that party direct.

- Ca3 : the that military a is It guide ensures which to commands the of action obeys always party the.

- Ref1 : It is a guide to action that ensures that the military will forever heed Party commands.

- Ref2 : It is the guiding principle which guarantees the military forces always being under the command of the Party.

- Ref3 : It is the practical guide for the army always to heed the directions of the party.
```
위 예시 문장에서 Ca3의 (modified) Unigram Precision은 Ca1과 동일하다 ( 순서만 뒤바뀌어 있을 뿐, 구성된 단어와 단어의 개수는 전부 동일하다 ). 하지만 실제로 이는 어순에 맞지 않은 형편없는 문장이다. 이러한 문제점을 보완하여 보다 정밀하게 평가하기 위해, N-gram을 이용한 precision을 도입한 것이다.
</br>
n-gram을 이용하여 다음의 예시 문장들을 파악해보자.
```
- Ca1 : the the the the the the the

- Ca2 : the cat the cat on the mat

- Ref1 : the cat is on the mat

- Ref2 : there is a cat on the mat
```

위 식에서 Ca2의 bi-gram(n-gram에서 n=2) 정확도는 어떻게 되는 지 알아보자.
</br>

우선, 분자인 Count_clip 값 부터 알아보자. 그러기 위해, 이 문장에서 생기는 bigram의 조합을 알아야 한다. 그리고 해당 조합이 ref1와 ref2에 얼마나 등장하는지를 파악해야한다. 이를 통해 얻어낸 각각의 bigram에 대한 count_clip값은 다음과 같다.
- the cat : min(1,1) = 1
- cat the : min(0,0) = 0
- cat on : min(1,1) = 1
- on the : min(2,1) = 1
- the mat : min(2,1) = 1
따라서 분자인 count_clip은 4가 된다 
</br>

그 다음 분모인 count값은, 해당 문장(Ca2)에 등장하는 bi-gram수로, 7-1(bigram이므로)=6이 된다.
따라서, 위 식의 최종적인 bigram 정확도는 4/6이 됨을 알 수 있다.
</br>
</br>

## 6. BLEU의 일반화 식
BLEU에 n-gram을 적용한 일반화된 식은 다음과 같다.
</br>
</br>
<a href="https://www.codecogs.com/eqnedit.php?latex=p_n&space;=&space;\frac{\sum_{n-gram&space;\in&space;Candiate}^{&space;}Count_{clip}(n-gram)}{\sum_{n-gram&space;\in&space;Candiate}^{&space;}Count(n-gram)}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?p_n&space;=&space;\frac{\sum_{n-gram&space;\in&space;Candiate}^{&space;}Count_{clip}(n-gram)}{\sum_{n-gram&space;\in&space;Candiate}^{&space;}Count(n-gram)}" title="p_n = \frac{\sum_{n-gram \in Candiate}^{ }Count_{clip}(n-gram)}{\sum_{n-gram \in Candiate}^{ }Count(n-gram)}" /></a>
</br>
</br>
p1은 unigram, p2는 bigram... pn은 n-gram의 경우를 의미한다.</br>
이 여러 n-gram들을 조합하여 사용할 경우, 다음과 같은 최종적인 BLEU 식이 나오게 된다.
</br>
</br>
<a href="https://www.codecogs.com/eqnedit.php?latex=BLEU&space;=&space;exp(\sum_{n=1}^{N}w_nlogp_n)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?BLEU&space;=&space;exp(\sum_{n=1}^{N}w_nlogp_n)" title="BLEU = exp(\sum_{n=1}^{N}w_nlogp_n)" /></a>
</br>
</br>
</br>

## 7. Brevity Penalty
이는 짧은 문장 길이에 대해 penalty를 부여하는 것이다. 예를들어, '안녕'이란 말을 듣고 'Hi'를 제대로 번역한 번역기가 있다고 하자. 물론 아주 정확하게 번역해 낸 것은 맞다. 하지만, 이는 (다른 긴 문장들에 비해) 맞히기 매우 쉬웠던 과제이고, 이에 따라 해당 모델(번역기)가 아주 잘했다고 칭찬하기는 또 어렵다. 그래서 '문장 길이'도 함께 고려하기 위해 등장한 것이 바로 이 Brevity Penalty이다.
</br>
</br>
이를 감안한 BLEU score은 다음과 같다. (기존의 BLEU에 BP를 곱한것에 불과하다. Penalty를 주고 싶지 않다면 BP=1로 하면 된다)
</br>
</br>
<a href="https://www.codecogs.com/eqnedit.php?latex=BLEU&space;=&space;BP&space;\times&space;exp(\sum_{n=1}^{N}w_nlogp_n)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?BLEU&space;=&space;BP&space;\times&space;exp(\sum_{n=1}^{N}w_nlogp_n)" title="BLEU = BP \times exp(\sum_{n=1}^{N}w_nlogp_n)" /></a>
</br>
</br>
그렇다면 어떠한 식으로 penalty를 부여하는가? 즉, BP는 어떻게 계산이 되는가?
</br>
</br>
<a href="https://www.codecogs.com/eqnedit.php?latex=BP&space;=&space;\left\{\begin{matrix}&space;1&space;\;\;\;\;\;\;\;\;\;\;&space;if&space;\;&space;c>r\\&space;e^{1-r/c}\;\;\;\;&space;if&space;\;&space;c\leq&space;r&space;\end{matrix}\right." target="_blank"><img src="https://latex.codecogs.com/gif.latex?BP&space;=&space;\left\{\begin{matrix}&space;1&space;\;\;\;\;\;\;\;\;\;\;&space;if&space;\;&space;c>r\\&space;e^{1-r/c}\;\;\;\;&space;if&space;\;&space;c\leq&space;r&space;\end{matrix}\right." title="BP = \left\{\begin{matrix} 1 \;\;\;\;\;\;\;\;\;\; if \; c>r\\ e^{1-r/c}\;\;\;\; if \; c\leq r \end{matrix}\right." /></a>
</br>
</br>
- c : Candiate의 길이
- r : Cnadidate와 가장 길이 차이가 작은 Reference의 길이
이를 통해, 짧은 문장의 겨우에는 penalty가 커짐을 확인할 수 있다.
</br>
</br>

## 8. 최종적인 BLEU 구현
지금까지 배운 것을 python으로 구현해보자. 우선, Brevity Penalty term을 구현해보자

#### Brevity Penalty
- r : 가장 길이 차이가 작은 Ref의 길이
```
def close_ref(candidate,reference_list):
    ca_len = len(candidate)
    ref_lens = (len(ref) for ref in reference_list)
    closest_len = min(ref_lens, key=lambda ref_len : (abs(ref_len-ca_len), ref_len))
    return closest_len
```
</br>

- brevity penalty
```
def brevity_penalty(candidate, reference_list):
    ca_len = len(candidate)
    ref_len = close_ref(candidate,reference_list)
    if ca_len > ref_len:
        return 1
    elif ca_len == 0:
        return 0
    else :
        return np.exp(1-ref_len/ca_len)
```

#### 최종적인 BLEU Score
- unigram ~ 4-gram까지 모두 동일한 weight를 (0.25씩) 주는 것을 default값으로 한다
```
def BLEU(candidate,reference_list, weights=[0.25,0.25,0.25,0.25]):
    bp = brevity_penalty(candidate, reference_list)
    p_n = [mod_precision(candidate,reference_list,n=n) for n,_ in enumerate(weights,start=1)]
    score = np.sum([w_i*np.log(p_i) if p_i!=0 else 0 for w_i, p_i in zip(weights,p_n)])
    return bp*np.exp(score)
```
</br>
</br>

## 9. NLTK의 BLEU
- nltk에서 제공하는 bleu score와, 우리가 직접 구현한 bleu score이 동일한지 확인해보자. 그 결과, 이 둘은 일치하는 것을 확인할 수 있다!
```
import nltk.translate.bleu_score as bleu

candidate = 'It is a guide to action which ensures that the military always obeys the commands of the party'

references = [
    'It is a guide to action that ensures that the military will forever heed Party commands',
    'It is the guiding principle which guarantees the military forces always being under the command of the Party',
    'It is the practical guide for the army always to heed the directions of the party'
]
```

```
print(bleu.sentence_bleu(list(map(lambda ref: ref.split(), references)),candidate.split()))

0.5045666840058485
```

```
BLEU(candidate.split(), list(map(lambda ref: ref.split(), references)))

0.5045666840058485
```

