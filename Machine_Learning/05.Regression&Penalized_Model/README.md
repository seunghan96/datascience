# Penalized Model
- linear regression에서 overfitting이 발생할 경우, weight에 penalty를 부과하는 방식으로 이를 해소!
- 크게 3가지 방법 : 
 1) Ridge ( L2 regularization )
 2) Lasso ( L1 regularization
 3) Elastic Net ( L1+L2 regularization )
</br>
</br>

### 1. Ridge ( L2 regularization )
- weight에 어떤 식으로 penalty를 부여? </br>

<a href="https://www.codecogs.com/eqnedit.php?latex=L(x,y)&space;=&space;\sum_{i=1}^{n}(y_i&space;-&space;h_\theta(x_i))^2&space;&plus;&space;\lambda\sum_{i=1}^{n}\theta_i^2" target="_blank"><img src="https://latex.codecogs.com/gif.latex?L(x,y)&space;=&space;\sum_{i=1}^{n}(y_i&space;-&space;h_\theta(x_i))^2&space;&plus;&space;\lambda\sum_{i=1}^{n}\theta_i^2" title="L(x,y) = \sum_{i=1}^{n}(y_i - h_\theta(x_i))^2 + \lambda\sum_{i=1}^{n}\theta_i^2" /></a>
</br>
- penalty 계수(lambda)가 0에 가까워질수록, 일반 linear regression과 비슷해짐 </br>
  penalty 계수(lambda)가 무한대로 갈 수록, weight들은 0으로 수렴
- weight가 0에 가까워 질 수 있으나, 정확히 0이 될 수는 없음! ( penalty term을 보면 '제곱'이 있음 )
</br>

### 2. Lasso ( L1 regularization )
- weight에 어떤 식으로 penalty를 부여? </br>

<a href="https://www.codecogs.com/eqnedit.php?latex=L(x,y)&space;=&space;\sum_{i=1}^{n}(y_i&space;-&space;h_\theta(x_i))^2&space;&plus;&space;\lambda\sum_{i=1}^{n}|\theta_i|" target="_blank"><img src="https://latex.codecogs.com/gif.latex?L(x,y)&space;=&space;\sum_{i=1}^{n}(y_i&space;-&space;h_\theta(x_i))^2&space;&plus;&space;\lambda\sum_{i=1}^{n}|\theta_i|" title="L(x,y) = \sum_{i=1}^{n}(y_i - h_\theta(x_i))^2 + \lambda\sum_{i=1}^{n}|\theta_i|" /></a>
</br>
- penalty 계수(lambda)가 0에 가까워질수록, 일반 linear regression과 비슷해짐 </br>
  penalty 계수(lambda)가 무한대로 갈 수록, weight들은 0으로 수렴 ( 실제로 0 될 수도 )
- weight가 정확히 0이 될 수 있음 -> perform model selection
</br>

### 3. Elastic Net ( L1+L2 regularization )
- Ridge와 Lasso의 L1,L2 norm을 둘 다 사용!
- 수식 : </br>
<a href="https://www.codecogs.com/eqnedit.php?latex=L(x,y)&space;=&space;\sum_{i=1}^{n}(y_i&space;-&space;h_\theta(x_i))^2&space;&plus;&space;\lambda_1\sum_{i=1}^{n}|\theta_i|&space;&plus;&space;\lambda_2\sum_{i=1}^{n}\theta_i^2" target="_blank"><img src="https://latex.codecogs.com/gif.latex?L(x,y)&space;=&space;\sum_{i=1}^{n}(y_i&space;-&space;h_\theta(x_i))^2&space;&plus;&space;\lambda_1\sum_{i=1}^{n}|\theta_i|&space;&plus;&space;\lambda_2\sum_{i=1}^{n}\theta_i^2" title="L(x,y) = \sum_{i=1}^{n}(y_i - h_\theta(x_i))^2 + \lambda_1\sum_{i=1}^{n}|\theta_i| + \lambda_2\sum_{i=1}^{n}\theta_i^2" /></a>
</br>

### Ridge, Lasso, Elastic Net
<img src="https://cdn-images-1.medium.com/max/1200/0*kuuC8_3Q2YjoLoqt.png" width="550" /> </br>
https://cdn-images-1.medium.com/max/1200/0*kuuC8_3Q2YjoLoqt.png
</br>

### 적절한 lambda 값은? </br>
Cross Validation을 시행하여 MSE를 가장 작게 만드는 lambda값 선택!  </br>
<img src="https://i.stack.imgur.com/bzG36.png" width="350" /> </br>
