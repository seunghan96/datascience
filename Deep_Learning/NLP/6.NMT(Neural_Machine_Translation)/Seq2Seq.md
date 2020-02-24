# [ seq2seq ]

## 1. Introduction
- 입력 sequence로부터 다른 도메인의 sequence를 출력하는 모델이다
- ex) 챗봇, 기계 번역

크게 두 개의 아키텍쳐로 구성되어 있다 ( Encoder & Decoder )
1) Encoder : input 데이터를 context vector로 압축시키는 역할을 한다
2) Deooder : Encoder에서 출력된 context vector를 받아서, 번역된 단어들을 순차적으로 출력한다

Encoder와 Decoder의 내부는 RNN, LSTM, GRU 등의 셀로 구성되어 있다. </br>
( RNN, LSTM, GRU 등에 대한 내용은 이미 알고 있다 가정하고 생략한다 )
</br>
<img src="https://wikidocs.net/images/page/24996/%EB%8B%A8%EC%96%B4%ED%86%A0%ED%81%B0%EB%93%A4%EC%9D%B4.PNG" width="800" /> </br>
https://wikidocs.net/images/
</br>
</br>

## 2. Encoder & Decoder of seq2seq

### (1) Encoder
- 각각의 단어는 embedding을 통해 vector로 바뀐 뒤에 Encoder의 입력으로 들어가게 된다.
</br>
<img src="https://wikidocs.net/images/page/24996/%EC%9E%84%EB%B2%A0%EB%94%A9%EB%B2%A1%ED%84%B0.PNG" width="550" /> </br>
https://wikidocs.net/images/page/24996

- 하나의 cell은 각각의 시점에 2개의 입력을 받는다 </br>
  1 ) t-1 시점에서의 hidden state (은닉 상태)
  2 ) t(현재) 시점에서의 input vector
</br>

### (2) Decoder
- Encoder의 마지막 cell의 hidden state인 'context vector'를 첫 번째  hidden state의 값으로 사용한ㄷ
- Decoder의 cell이 출력하는 output은, Dense Layer를 거치고 마지막으로 Softmax 함수를 통해 "각 단어들이 나올 확률"을 예측값으로 반환한다
</br>

<img src="https://wikidocs.net/images/page/24996/decodernextwordprediction.PNG" width="350" /> </br>
https://wikidocs.net/images/page/24996
</br>

#### Teacher Forcing (교사 강요 )
- 개념 : train 시, decoder의 입력으로 이전 decoder cell의 output이 아닌 "실제 값"을 입력값으로 하는 방법
- 이유 : 만약 예측이 틀렸는데도 불구하고, 계속 다음 cell의 입력으로 사용할 경우, 전체적인 예측을 어렵게 할 수 있기 때문이다!
</br>
</br>

## 3. seq2seq with python
- seq2seq을 이용한 NMT 생성하기
- character-level NMT

### (1) import dataset
- 총 170,651개의 문장
- source langauge(영어) & target language(프랑스어) pair
```
import pandas as pd
lines = pd.read_csv('fra.txt', names=['src','tar'], sep='\t')

len(lines)
170651
```

- 30000개의 문장만 sample하여 진행
```
lines = lines.sample(30000)
```

### (2) data preprocessing
- 번역 문장(target language)인 French에는 sos(start of sequence)와 eos(end of sequence)를 넣어줘야 한다 </br>
  ( sos 대신 '\t', eos 대신 '\n' )
```
lines.tar = lines.tar.apply(lambda x :'\t' + x +'\n')
```

- 글자 집합 생성 </br>
( token 단위가 '단어'가 아닌 '글자'이므로 )
```
src_vocab = set()
for line in lines.src:
    for char in line:
        src_vocab.add(char)

tar_vocab = set()
for line in lines.tar:
    for char in line:
        tar_vocab.add(char)
```

```
src_vocab_size = len(src_vocab)+1
tar_vocab_size = len(tar_vocab)+1
print(src_vocab_size)
print(tar_vocab_size)

102
74
```

```
src_vocab = sorted(list(src_vocab))
tar_vocab = sorted(list(tar_vocab))
```

- 각 글자에 index를 부여한다
```
src2index = dict([(word, i+1) for i, word in enumerate(src_vocab)])
tar2index = dict([(word, i+1) for i, word in enumerate(tar_vocab)])

print(src2index)
{' ': 1, '!': 2, '"': 3, '$': 4, '%': 5, "'": 6, ',': 7, '-': 8, '.': 9, '0': 10, '1': 11, '2': 12, '3': 13, '4': 14, '5': 15, '6': 16, '7': 17, '8': 18, '9': 19, ':': 20, ';': 21, '?': 22, 'A': 23, 'B': 24, 'C': 25, 'D': 26, 'E': 27, 'F': 28, 'G': 29, 'H': 30, 'I': 31, 'J': 32, 'K': 33, 'L': 34, 'M': 35, 'N': 36, 'O': 37, 'P': 38, 'Q': 39, 'R': 40, 'S': 41, 'T': 42, 'U': 43, 'V': 44, 'W': 45, 'X': 46, 'Y': 47, 'Z': 48, 'a': 49, 'b': 50, 'c': 51, 'd': 52, 'e': 53, 'f': 54, 'g': 55, 'h': 56, 'i': 57, 'j': 58, 'k': 59, 'l': 60, 'm': 61, 'n': 62, 'o': 63, 'p': 64, 'q': 65, 'r': 66, 's': 67, 't': 68, 'u': 69, 'v': 70, 'w': 71, 'x': 72, 'y': 73, 'z': 74, '\xa0': 75, '«': 76, '»': 77, 'À': 78, 'Â': 79, 'Ç': 80, 'É': 81, 'Ê': 82, 'Ô': 83, 'à': 84, 'á': 85, 'â': 86, 'ç': 87, 'è': 88, 'é': 89, 'ê': 90, 'ë': 91, 'î': 92, 'ï': 93, 'ô': 94, 'ù': 95, 'û': 96, 'œ': 97, '\u2009': 98, '\u200b': 99, '’': 100, '\u202f': 101}
```

- encoder 및 decoder의 input으로 넣기 전에, 정수 인코딩을 해준다
```
encoder_input = []

for line in lines.src:
    temp_X = []
    for w in line: 
        temp_X.append(src2index[w])
    encoder_input.append(temp_X)
```

```
decoder_input = []

for line in lines.tar:
    temp_X = []
    for w in line:
        temp_X.append(tar2index[w])
    decoder_input.append(temp_X)
```

```
print(encoder_input[:3])

[[42, 63, 61, 1, 66, 63, 62, 54, 60, 53, 9], [38, 53, 62, 67, 53, 67, 8, 68, 69, 1, 65, 69, 53, 1, 58, 53, 1, 64, 63, 69, 66, 66, 49, 57, 67, 1, 64, 49, 66, 60, 53, 66, 1, 84, 1, 42, 63, 61, 75, 22], [28, 49, 57, 68, 8, 57, 60, 1, 49, 69, 67, 67, 57, 1, 51, 56, 49, 69, 52, 1, 51, 56, 49, 65, 69, 53, 1, 58, 63, 69, 66, 101, 22]]
```

- target word 앞에 붙어 있는 '\t'를 제거한다 </br>
( '\t'의 index =1 -> 모든 문장 앞에서 제거하기 )
```
decoder_target = []

for line in lines.tar:
    t=0
    temp_X = []
    for w in line:
        if t>0:
            temp_X.append(tar2index[w])
        t=t+1     
    decoder_target.append(temp_X)
```

```
print(decoder_target[:3])

[[23, 23, 8, 22, 45, 3, 12, 9, 10, 3, 6, 26, 65, 48, 61, 50, 52, 7, 3, 21, 67, 67, 65, 56, 49, 68, 67, 56, 62, 61, 20, 3, 67, 48, 67, 62, 52, 49, 48, 9, 62, 65, 54, 3, 4, 12, 11, 11, 11, 11, 15, 13, 3, 6, 23, 31, 7, 3, 5, 3, 4, 15, 12, 16, 15, 14, 13, 18, 3, 6, 63, 56, 67, 56, 67, 61, 48, 67, 62, 59, 52, 7, 2], [23, 23, 8, 22, 45, 3, 12, 9, 10, 3, 6, 26, 65, 48, 61, 50, 52, 7, 3, 21, 67, 67, 65, 56, 49, 68, 67, 56, 62, 61, 20, 3, 67, 48, 67, 62, 52, 49, 48, 9, 62, 65, 54, 3, 4, 13, 15, 12, 14, 13, 14, 15, 3, 6, 23, 31, 7, 3, 5, 3, 4, 15, 17, 18, 13, 12, 10, 18, 3, 6, 21, 56, 57, 56, 7, 2], [23, 23, 8, 22, 45, 3, 12, 9, 10, 3, 6, 26, 65, 48, 61, 50, 52, 7, 3, 21, 67, 67, 65, 56, 49, 68, 67, 56, 62, 61, 20, 3, 67, 48, 67, 62, 52, 49, 48, 9, 62, 65, 54, 3, 4, 13, 12, 12, 14, 10, 11, 3, 6, 23, 31, 7, 3, 5, 3, 4, 18, 16, 19, 10, 14, 15, 3, 6, 66, 48, 50, 65, 52, 51, 50, 52, 59, 67, 56, 50, 7, 2]]
```
