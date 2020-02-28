# EM Algorithm 
## 1) Latent Variable Models

### a. Latent Variable Models
A latent variable model is a model that relates observable variables to latent variables. So, what is latent variable?
</br>

*(wikipedia) Latent variables (as opposed to observable variables) are variables that are not directly observed but are rather inferred (through a mathematical model) from other variables that are observed (directly measured)*
</br>

For example, your company is trying to recruit a person. And there are many things to consider for who to choose. There may be variables such as
'age','GPA','IQ score', etc... Those are all 'observable variables', which you can score in numerically. With those variables, you make
a new variable "Intelligence", which is a not direcly observable variable. This "Intelligence" is a 'latent variable'. And latent variable models are models
that use such variables.
</br>

So, what is good about latent variable models? </br>
They are simple models, with fewer parameters. Also, latent variables are sometimes meaningful. Look at the example above. We can say the new latent variable
'Intelligence" as the meaningful factor when considering who to choose as a new employee.
</br>
</br>

### b. Probalistic Clustering
Clustering is an unsupervised ML, which groups similar data into the same group. 
There are two big types of clustering, which are "hard" clustering and "soft" clustering.
</br>

Hard clustering assigns each data into only one cluster. On the other hand, soft clustring assigns each data several clusters with a different weight. It assign each data point a 'probability distribution' over clusters.
For example, if there are three clusters A,B,C, one data point x_1 can belong to 0.6*A + 0.2*B + 0.2*C.
</br>
<img src="https://image.slidesharecdn.com/textclustering-150803041805-lva1-app6891/95/text-clustering-41-638.jpg?cb=1438575615" width="550" /> </br>
https://image.slidesharecdn.com/textclustering-150803041805-lva1-app6891/95
</br>
</br>

These are the main two reasons why we want to cluster data in a soft way
</br>

**[1] better in tuning hyper parameter** </br>
The good thing about clustering in probabilistic way is that it is much more better in tuning hyperparameters. Let's take an
example of 'the number of clusters'. In GMM(Gaussian Mixture Model), which is one way of soft clustering, the log likelihood of training dataset
will be higher(get better) if the number of cluster increases. But it doesn't mean that it is always good to have a larger number of clusters, since the validation
dataset will show a decrease in the log likelihood after a certain point. But in the case of hard clustering(ex. K-means), no matter of the training dataset and the validation dataset,
larger number of cluster always shows a smaller loss, which makes us hard to decide how many clusters to make.

**[2] generating new data points** </br>
We may want to build a generative model of our data. If we treat everything probabilistically, we may sample new data from our model. 
For example, in the case of face image, sampling new images from the same probability distributions means that we can generate fake face from scratch.
</br>
</br>

### c. GMM (Gaussian Mixture Model)
How can we model our data probabilistically? One good way is using GMM, a Gaussian Mixture Model. </br>
Gaussian mixture model is a probabilistic model that assumes all the data points are generated from a mixture of a finite number of Gaussian distributions with unknown parameters. (scikit-learn).
</br>
</br>
<img src="https://miro.medium.com/max/753/1*lTv7e4Cdlp738X_WFZyZHA.png" width="550" /> </br>
https://miro.medium.com/max/753/1*lTv7e4Cdlp738X_WFZyZHA.png
</br>
</br>
In this case, we assume that each data point come from one of the three Gaussians. Each Gaussians represents one cluster. It means that the more Guassians you use in the mixture,
the more cluster you are using. 
</br>
Let's look at how one data point gets its cluster. </br>
The density of each data points is the weighted sum of three Gaussian densities, like the expression below.
</br>
</br>
<a href="https://www.codecogs.com/eqnedit.php?latex=p(x|\theta)&space;=&space;\pi_1N(x|\mu_1,\Sigma&space;_1)&space;&plus;&space;\pi_2N(x|\mu_2,\Sigma&space;_2)&space;&plus;&space;\pi_3N(x|\mu_3,\Sigma&space;_3)" target="_blank"><img src="https://latex.codecogs.com/gif.latex?p(x|\theta)&space;=&space;\pi_1N(x|\mu_1,\Sigma&space;_1)&space;&plus;&space;\pi_2N(x|\mu_2,\Sigma&space;_2)&space;&plus;&space;\pi_3N(x|\mu_3,\Sigma&space;_3)" title="p(x|\theta) = \pi_1N(x|\mu_1,\Sigma _1) + \pi_2N(x|\mu_2,\Sigma _2) + \pi_3N(x|\mu_3,\Sigma _3)" /></a>
</br>
</br>
The parameter 'theta' here are
</br>
</br>
<a href="https://www.codecogs.com/eqnedit.php?latex=\theta&space;=&space;\{\pi_1,&space;\pi_2,&space;\pi_3,&space;\mu_1,\mu_2,\mu_3,\Sigma_1,\Sigma_2,\Sigma_3\}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\theta&space;=&space;\{\pi_1,&space;\pi_2,&space;\pi_3,&space;\mu_1,\mu_2,\mu_3,\Sigma_1,\Sigma_2,\Sigma_3\}" title="\theta = \{\pi_1, \pi_2, \pi_3, \mu_1,\mu_2,\mu_3,\Sigma_1,\Sigma_2,\Sigma_3\}" /></a>
</br>
</br>
Compared to one Gaussian, GMM has more flexiblity. But it has more parameters to decide.

The way to train GMM is to find the values of the parameters which maximizes the likelihood ( = density of data set, given the parameters).
</br>
<a href="https://www.codecogs.com/eqnedit.php?latex=\begin{align*}&space;\underset{\theta}{max}\;\;&space;p(X|\theta)&space;&=&space;\prod_{i=1}^{N}&space;p(x_i|\theta)&space;\\&space;&=\prod_{i=1}^{N}(\pi_1N(x_i|\mu_1,\Sigma_1)&plus;...)&space;\end{align*}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\begin{align*}&space;\underset{\theta}{max}\;\;&space;p(X|\theta)&space;&=&space;\prod_{i=1}^{N}&space;p(x_i|\theta)&space;\\&space;&=\prod_{i=1}^{N}(\pi_1N(x_i|\mu_1,\Sigma_1)&plus;...)&space;\end{align*}" title="\begin{align*} \underset{\theta}{max}\;\; p(X|\theta) &= \prod_{i=1}^{N} p(x_i|\theta) \\ &=\prod_{i=1}^{N}(\pi_1N(x_i|\mu_1,\Sigma_1)+...) \end{align*}" /></a>
</br>
which are subject to <a href="https://www.codecogs.com/eqnedit.php?latex=\pi_1&plus;&space;\pi_2&plus;\pi_3&space;=&space;1;&space;\;\;&space;\pi_k\geq&space;0;&space;\;\;\;&space;k=1,2,3...;&space;\;\;&space;\Sigma_k&space;>0" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\pi_1&plus;&space;\pi_2&plus;\pi_3&space;=&space;1;&space;\;\;&space;\pi_k\geq&space;0;&space;\;\;\;&space;k=1,2,3...;&space;\;\;&space;\Sigma_k&space;>0" title="\pi_1+ \pi_2+\pi_3 = 1; \;\; \pi_k\geq 0; \;\;\; k=1,2,3...; \;\; \Sigma_k >0" /></a>
</br>
</br>
How do we optimize this? We use 'EM algorithm', which we will talk about later. There are two reasons why we do not use SGD(Stochastic Gradient Descent) here, and use EM algorithm instead. First, it may be hard to follow the constraints, which is written above (like positive semi-definite covariance matrices). Second, EM algorithm is sometims much more faster and efficient.
</br>

As a summary, GMM is a flexible probability distribution, which can be better trained with EM algorithm than SGD.
</br>
</br>

### d. Training GMM
It is easy to find the gaussian distribution if we all know the sources of each data point. But in reality, we don't know the sources. We need gaussian parameters to estimate our sources. But also, to estimate the gaussian parameters, we need the sources!
We solve this problem with EM algorithm.
</br>

#### EM algorithm
- Step 1) Start with 2 randomly placed Gaussian parameters theta
- Step 2) Until convergence, repeat : </br>
   a) For each point, compute p(t=c | x_i, theta) ( = does x_i look like it came from cluster c? ) </br>
   b) Update Gaussian parameters theta to fit points assigned to them
</br>
The illustration below shows how the gaussian parameters are updated after several iterations.
</br>
<img src="https://i.stack.imgur.com/Z5mcu.png" width="700" /> </br>
https://i.stack.imgur.com/Z5mcu.png
