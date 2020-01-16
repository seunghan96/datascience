################################
#### 1-a. Forward & Back Prop ##
################################

# weights & bias
w1 = 0.15
w2 = 0.20
w3 = 0.25
w4 = 0.30
w5 = 0.40
w6 = 0.45
w7 = 0.50
w8 = 0.55
w = c(w1,w2,w3,w4,w5,w6,w7,w8)

b1 = 0.35
b2 = 0.60
b = c(b1,b2)

# input & target
input1 = 0.05
input2 = 0.10
input = c(input1,input2)

out1 = 0.01
out2 = 0.99
out = c(out1,out2)

# learning rate
lr = 0.5


# functions
sigmoid = function(z) {
  return ( 1/(1+exp(-z)))
}

# (1) Forward Propogation
forward = function(input,w,b){
  # input -> hidden
  neth1 = w[1]*input[1] + w[2]*input[2] + b[1]
  neth2 = w[3]*input[1] + w[4]*input[2] + b[1]
  outh1 = sigmoid(neth1)
  outh2 = sigmoid(neth2)
  
  # hidden -> output
  neto1 = w[5]*outh1 + w[6]*outh2 + b[2]
  neto2 = w[7]*outh1 + w[8]*outh2 + b[2]
  outo1 = sigmoid(neto1)
  outo2 = sigmoid(neto2)
  
  result = c(outh1,outh2,outo1,outo2)
  return(result)
}

# (3) error 
error = function(result,out) {
  err = 0.5*(out[1]-result[3])^2 + 0.5*(out[2]-result[4])^2
  return(err)
}

# Calculate
neth1 = w[1]*input[1] + w[2]*input[2] + b[1]
neth2 = w[3]*input[1] + w[4]*input[2] + b[1]
outh1 = sigmoid(neth1)
outh2 = sigmoid(neth2)

neto1 = w[5]*outh1 + w[6]*outh2 + b[2]
neto2 = w[7]*outh1 + w[8]*outh2 + b[2]
outo1 = sigmoid(neto1)
outo2 = sigmoid(neto2)

res = forward(input,w,b)
err = error(res,out)
err 

# save calculation ( for back prop )
i = 1
outh1 = res[1]
outh2 = res[2]
outo1 = res[3]
outo2 = res[4]
err[i] = error(res,out)

#########################################################

# (2) Back Propagation

# dE_dw5 ( will write as d_E.w5 )
d_E.outo1 = -(out[1]-outo1)
d_outo1.neto1 = outo1*(1-outo1)
d_neto1.w5 = outh1
d_E.w5 = d_E.outo1 * d_outo1.neto1 * d_neto1.w5

# dE_dw6
d_neto1.w6 = outh2
d_E.w6 = d_E.outo1 * d_outo1.neto1 * d_neto1.w6

# dE_dw7
d_E.outo2 = -(out[2]- outo2)
d_outo2.neto2 = outo2*(1-outo2)
d_neto2.w7 = outh2
d_E.w7 = d_E.outo2 * d_outo2.neto2 * d_neto2.w7

# dE_dw8
d_neto2.w8 = outh2
d_E.w8 = d_E.outo2 * d_outo2.neto2 * d_neto2.w8

# dE_dwb2
d_E.b2 = (d_E.outo1 * d_outo1.neto1 * 1) + (d_E.outo2 * d_outo2.neto2 * 1)

# dE_douth1
d_neto1.outh1 = w5
d_neto2.outh1 = w7
d_E.outh1 = (d_E.outo1 * d_outo1.neto1 * d_neto1.outh1) + (d_E.outo2 * d_outo2.neto2 * d_neto2.outh1)

# dE_douth2
d_neto1.outh2 = w6
d_neto2.outh2 = w8
d_E.outh2 = (d_E.outo1 * d_outo1.neto1 * d_neto1.outh2) + (d_E.outo2 * d_outo2.neto2 * d_neto2.outh2)

# dE_dw1
d_outh1.neth1 = outh1 * (1-outh1)
d_neth1.w1 = input[1]
d_E.w1 = d_E.outh1 * d_outh1.neth1 * d_neth1.w1

# dE_dw2
d_neth1.w2 = input[2]
d_E.w2 = d_E.outh1 * d_outh1.neth1 * d_neth1.w2


# dE_dw3
d_outh2.neth2 = outh2 * (1-outh2)
d_neth2.w3 = input[1]
d_E.w3 = d_E.outh2 * d_outh2.neth2 * d_neth2.w3

# dE_dw4
d_neth2.w4 = input[2]
d_E.w4 = d_E.outh2 * d_outh2.neth2 * d_neth2.w4

# dE_db1
d_E.b1 = (d_E.outo1 * d_outo1.neto1 * d_neto1.outh1 * d_outh1.neth1 * 1) + (d_E.outo2 * d_outo2.neto2 * d_neto2.outh2 * d_outh2.neth2 *1)


##########################
#### 1-b. UPDATE params ##
##########################

w1 = w1-lr*d_E.w1
w2 = w2-lr*d_E.w2
w3 = w3-lr*d_E.w3
w4 = w4-lr*d_E.w4
w5 = w5-lr*d_E.w5
w6 = w6-lr*d_E.w6
w7 = w7-lr*d_E.w7
w8 = w8-lr*d_E.w8
b1 = b1-lr*d_E.b1
b2 = b2-lr*d_E.b2

w = c(w1,w2,w3,w4,w5,w6,w7,w8)
b = c(b1,b2)

res = forward(input,w,b)
outh1 = res[1]
outh2 = res[1]
outo1 = res[3]
outo2 = res[4]
err = error(res,out)
err

# updated parameters 
w

###############################
#### 1-c. with different lr ###
###############################

# (1) Make a function with arguement < 'n' iteration & 'lr' learning rate >

iteration = function(n,lr){
  for (i in seq(n)){
    # FORWARD
    outh1 = res[1]
    outh2 = res[2]
    outo1 = res[3]
    outo2 = res[4]
    err[i] = error(res,out)
    
    # BACKWARD
    d_E.outo1 = -(out[1]-outo1)
    d_outo1.neto1 = outo1*(1-outo1)
    d_neto1.w5 = outh1
    d_E.w5 = d_E.outo1 * d_outo1.neto1 * d_neto1.w5
    
    d_neto1.w6 = outh2
    d_E.w6 = d_E.outo1 * d_outo1.neto1 * d_neto1.w6
    
    d_E.outo2 = -(out[2]- outo2)
    d_outo2.neto2 = outo2*(1-outo2)
    d_neto2.w7 = outh2
    d_E.w7 = d_E.outo2 * d_outo2.neto2 * d_neto2.w7
    
    d_neto2.w8 = outh2
    d_E.w8 = d_E.outo2 * d_outo2.neto2 * d_neto2.w8
    
    d_E.b2 = (d_E.outo1 * d_outo1.neto1 * 1) + (d_E.outo2 * d_outo2.neto2 * 1)
    
    d_neto1.outh1 = w5
    d_neto2.outh1 = w7
    d_E.outh1 = (d_E.outo1 * d_outo1.neto1 * d_neto1.outh1) + (d_E.outo2 * d_outo2.neto2 * d_neto2.outh1)
    
    d_neto1.outh2 = w6
    d_neto2.outh2 = w8
    d_E.outh2 = (d_E.outo1 * d_outo1.neto1 * d_neto1.outh2) + (d_E.outo2 * d_outo2.neto2 * d_neto2.outh2)
    
    d_outh1.neth1 = outh1 * (1-outh1)
    d_neth1.w1 = input[1]
    d_E.w1 = d_E.outh1 * d_outh1.neth1 * d_neth1.w1
    
    d_neth1.w2 = input[2]
    d_E.w2 = d_E.outh1 * d_outh1.neth1 * d_neth1.w2
    
    d_outh2.neth2 = outh2 * (1-outh2)
    d_neth2.w3 = input[1]
    d_E.w3 = d_E.outh2 * d_outh2.neth2 * d_neth2.w3
    
    d_neth2.w4 = input[2]
    d_E.w4 = d_E.outh2 * d_outh2.neth2 * d_neth2.w4
    
    d_E.b1 = (d_E.outo1 * d_outo1.neto1 * d_neto1.outh1 * d_outh1.neth1 * 1) + (d_E.outo2 * d_outo2.neto2 * d_neto2.outh2 * d_outh2.neth2 *1)
    
    w1 = w1-lr*d_E.w1
    w2 = w2-lr*d_E.w2
    w3 = w3-lr*d_E.w3
    w4 = w4-lr*d_E.w4
    w5 = w5-lr*d_E.w5
    w6 = w6-lr*d_E.w6
    w7 = w7-lr*d_E.w7
    w8 = w8-lr*d_E.w8
    b1 = b1-lr*d_E.b1
    b2 = b2-lr*d_E.b2
    
    w = c(w1,w2,w3,w4,w5,w6,w7,w8)
    b = c(b1,b2)
    
    res = forward(input,w,b)
    outh1 = res[1]
    outh2 = res[1]
    outo1 = res[3]
    outo2 = res[4]
    err[i] = error(res,out)
  }
  return(list(err,outo1,outo2))
}

# (2) 10000 iteration with different lr
result_0.1 = iteration(10000,0.1)
result_0.6 = iteration(10000,0.6)
result_1.2 = iteration(10000,1.2)

# (3) PLOT of error 
plot(result_0.1[[1]],xlab='# of iteration', ylab='error', main ='Learning rate with 0.1')
plot(result_0.6[[1]],xlab='# of iteration', ylab='error', main ='Learning rate with 0.6')
plot(result_1.2[[1]],xlab='# of iteration', ylab='error', main ='Learning rate with 1.2')

# (4) Prediction Results
c(result_0.1[2], result_0.1[3])
c(result_0.6[2], result_0.6[3])
c(result_1.2[2], result_1.2[3])


## Difference of Learning Rate
## we need to select the appropriate learning rate, which is not too big or not too small.
## If the learning rate is too small, the time it takes to get to the optimal solution will be very slow. On the other hand, if the learning rate is too large, it wouldn't converge to the optimal solution and will diverge! That's why we have to choose the appropriate learning rate.