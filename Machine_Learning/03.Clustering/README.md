# Clustering 요약
- clustering : 비슷한 데이터끼리 묶기
- unsupervised learning
- ex) K-means, DBSCAN, Agglomerative Clustering (Hierarchical)
- metric : silhouette score (-1 ~ 1) </br>
 ( 동일한 cluster내의 data끼리는 가깝게, 다른 cluster의 data끼리는 멀게끔 하는 것이 좋은 clustering )
</br>

## 1. K-means
- '거리' 기반 clustering method
- k개의 군집으로 data를 clustering함 ( 직접 k값을 정해줘야함 )
- 알고리즘 
</br>
<img src="https://media.springernature.com/original/springer-static/image/art%3A10.1007%2Fs00521-013-1437-4/MediaObjects/521_2013_1437_Figa_HTML.gif", width="650" /> </br>
 step 1) k개의 임의의 centroid(clustering의 중심점)을 잡음.  </br>
 step 2) (k개를 제외한) 나머지 data들을, k개의 centroid 중 가장 가까이 위치한 centroid에 할당 (같은 cluster로 편성) </br>
 step 3) 생성된 k개의 cluster의 centroid를 update해준다 </br>
   ( = 가장 중심이 되는 data(즉 다른 data들과의 distance 합이 가장 작은 data)를 centroid로 바꿔준다 ) </br>
 step 4) centroid가 더 이상 바뀌지 않을 때 까지 step2 & step3를 반복한다 </br>
</br>
<img src="https://stanford.edu/~cpiech/cs221/img/kmeansViz.png", width="380" /> </br>
https://stanford.edu/~cpiech/cs221/img/kmeansViz.png
</br>

## 2. DBSCAN
- Density-Based Spatial Clustering of Applications with Noise
- '밀도' 기반 clustering method
- 특정 점(core point)를 기준으로 일정 거리(e) 내에, data가 x개 이상 있으면 같은 cluster로!
- parameter : </br>
   e(epsilon) : 특정 점으로 부터 떨어진 일정 거리 </br>
   m(minPts) : 하나의 cluster를 이루기 위한 최소한의 data 개수
</br>

<img src="https://media.geeksforgeeks.org/wp-content/uploads/20190515220731/bacc6e04-0a54-4206-9cd2-f024cbe98df22.png" width="380" /> </br>
https://media.geeksforgeeks.org/wp-content/uploads/20190515220731/bacc6e04-0a54-4206-9cd2-f024cbe98df22.png
- 용어 : </br>
   core point : cluster의 대표(중심)이 되는 data </br>
   border point : minPts 조건을 충족 못해 core point는 안되지만, 다른 core point가 형성한 cluster내에 속하는 data </br>
   noise point : 그 어떤 cluster에도 속하지 않는 data </br>
</br>
<img src="https://t1.daumcdn.net/cfile/tistory/99CC563359E057BA25" width="380" /> </br>
https://t1.daumcdn.net/cfile/tistory/99CC563359E057BA25

## 3. Agglomerative Clustering

## [metric] Silhouette Score
