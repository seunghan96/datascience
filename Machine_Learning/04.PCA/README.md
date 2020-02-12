# PCA (Principal Component Analysis)
- 주성분분석 ( data를 구성하는 주성분(Principal Component)를 찾아냄 )
- 주성분? </br>
 **그 방향으로 데이터들의 분산이 가장 큰 방향 벡터**
</br>
 <img src="https://miro.medium.com/max/462/1*QALwLkPJG45E7_DsOccdaw.png" width="300" /> </br>
 https://miro.medium.com/max/462/1*QALwLkPJG45E7_DsOccdaw.png
 </br>
 
 ### dimension reduction with PCA
- 차원 축소(dimension reduction)의 방법 중 하나!
- 분산이 가장 큰 축의 방향으로 사영(projection)시킴
- 가장 분산이 큰 n개의 주성분으로 차원 축소
- n개의 주성분만으로도 전체 데이터를 얼마나 설명할 수 있는지(explained variance ratio)를 확인
- visualization을 위해서 사용
</br>
<img src="https://liorpachter.files.wordpress.com/2014/05/pca_figure1.jpg" width="300" /> </br>

#### PCA는 변수들 간의 선형(linear)조합(linear)으로 새로운 주성분 생성. 하지만 AutoEncoder는 비선형(non-linear)조합을 가능하게 하여, 더 뛰어난 차원 축소를 할 수 있음!
