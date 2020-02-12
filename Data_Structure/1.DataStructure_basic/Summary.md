# SUMMARY

### 1. Array & Queue
- Array : 같은 종류의 데이터를 효율적으로 관리 & 순차적으로 저장
- Queue : FIFO 구조 ( <-> Stack ) </br>
  * Enqueue : queue에 데이터를 넣음
  * Dequeue : queue에서 데이터를 꺼냄
  * 종류) Queue, LifoQueue, PriorityQueue
</br>

### 2. Stack
- 한쪽 방향에서만 데이터를 넣거나 뺼 수 있음
- LIFO 구조 ( <-> Queue )
- push() & pop()
</br>

### 3. Linked List
- 연결 리스트 ( 떨어진 곳에 존재하는 데이터를 화살표로 연결 )
- node & pointer
- 장점) 데이터 공간 미리 할당할 필요 없음 
- 단점) 연결 위한 별도 공간 필요 & 탐색 시간 소요
</br>

### 4. Hash Table
- key & value 구조 ( python : dictionary 구조 )
- hash : 임의의 값을 고정된 길이로 변환시켜즘!
- hash table : key값의 연산에 의해 직접 접근 가능한 구조
- hashing function : key -> 데이터 위치 찾아줌
- Hash Collision  </br>
   1) Chaining 기법 : open hashing / 해쉬 테이블 외의 공간 이용
   2) Linear Probing 기법 : close ashing / 해쉬 테이블 내의 공간 이용 ( 다른 빈 공간 활용 )
</br>

### 5. Time Complexity
- Big O 표기법 ( 알고리즘 최악의 실행 시간 ) </br>
  ( 그 외 : 오메가 (최상), 세타 (평균) )
</br>

### 6. Tree
- depth가 h : Time Complexity는 O(h)
- n개 노드 -> h = log2(n) -> Time Complexity는 O(log2(n))
- Binary Tree ( 왼쪽에 작은 값, 오른쪽에 큰 값 )
</br>

### 7. Heap
- Tree 기반 ( Complete Binary Tree : 데이터 채워나갈 때, 왼쪽 최하단 node부터 채움 )
- 최대 & 최소값 빠르게 찾기! ( Max Heap & Min Heap )

