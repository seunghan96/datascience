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
\begin{align*}
\underset{\theta}{max}\;\; p(X|\theta) &= \prod_{i=1}^{N} p(x_i|\theta) \\
&=\prod_{i=1}^{N}(\pi_1N(x_i|\mu_1,\Sigma_1)+...)
\end{align*}
</br>
which are subject to <a href="https://www.codecogs.com/eqnedit.php?latex=\pi_1&plus;&space;\pi_2&plus;\pi_3&space;=&space;1;&space;\;\;&space;\pi_k\geq&space;0;&space;\;\;\;&space;k=1,2,3...;&space;\;\;&space;\Sigma_k&space;>0" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\pi_1&plus;&space;\pi_2&plus;\pi_3&space;=&space;1;&space;\;\;&space;\pi_k\geq&space;0;&space;\;\;\;&space;k=1,2,3...;&space;\;\;&space;\Sigma_k&space;>0" title="\pi_1+ \pi_2+\pi_3 = 1; \;\; \pi_k\geq 0; \;\;\; k=1,2,3...; \;\; \Sigma_k >0" /></a>
</br>
</br>
How do we optimize this?
