# [ BLEU ( Bilingual Evaluation Understudy Score ) ]
BLEU는 기계 번역(Neural Machine Translation)의 성능이 얼마나 뛰어난지 측정하는 대표적인 score이다. 이번 포스트의 목적은, BLEU
의 개념에 대해 이해하고 이를 python code로 구현하는 것이다.

## 1. Introduction
#### BLEU 요약
- key idea : 기계 번역 결과와, 사람이 직접 번역한 결과가 얼마나 유사한지 측정
- 측정 기준 : n-gram에 기반
- 장점 : 언어에 구애 받지 않고, 속도가 빠르다
- 높을수록 좋은 성능을 의미

#### BLEU 식
</br>
<a href="https://www.codecogs.com/eqnedit.php?latex=BLEU&space;=&space;exp(\sum_{n=1}^{N}w_nlogp_n)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?BLEU&space;=&space;exp(\sum_{n=1}^{N}w_nlogp_n)" title="BLEU = exp(\sum_{n=1}^{N}w_nlogp_n)" /></a>
</br>
</br>
어떻게 해서 위와 같은 식이 나오게 되었는지 알아보자.

## 2. Unigram Precision (단어 개수 count로 측정)
우선, BLEU score를 구하기 위해 '기계가 번역한 문장'(Ca (Candidate))와,
'사람이 번역한 문장'(Ref (Reference))이 있어야 한다. </br>
간단한 예시로, 다음과 같은 2개의 Ca 와 3개의 Ref가 있다고 하자.  </br>

```
- Ca1 : It is a guide to action which ensures that the military always obeys the commands of the party.

- Ca2 : It is to insure the troops forever hearing the activity guidebook that party direct.

- Ref1 : It is a guide to action that ensures that the military will forever heed Party commands.

- Ref2 : It is the guiding principle which guarantees the military forces always being under the command of the Party.

- Ref3 : It is the practical guide for the army always to heed the directions of the party.
```

우리의 목표는, 이 두 개의 기계가 번역한 문장(Ca)중,
어느 것이 실제 정답이라고 할 수 있는 '사람이 번역한 문장(Ref)'와 유사한지 측정하여 가장 잘 번역한 문장을
채택하는 것이다. 이를 판단하기 위한 지표인 Unigram Precision의 식은 다음과 같다
</br>
<a href="https://www.codecogs.com/eqnedit.php?latex=Unigram\;&space;Precision&space;=&space;\frac{the\;&space;number\;&space;of\;Ca\;words(unigrams)\;which\;occur\;in\;any\;Ref}{the\;total\;number\;of\;words\;in\;the\;Ca}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?Unigram\;&space;Precision&space;=&space;\frac{the\;&space;number\;&space;of\;Ca\;words(unigrams)\;which\;occur\;in\;any\;Ref}{the\;total\;number\;of\;words\;in\;the\;Ca}" title="Unigram\; Precision = \frac{the\; number\; of\;Ca\;words(unigrams)\;which\;occur\;in\;any\;Ref}{the\;total\;number\;of\;words\;in\;the\;Ca}" /></a>
</br>
