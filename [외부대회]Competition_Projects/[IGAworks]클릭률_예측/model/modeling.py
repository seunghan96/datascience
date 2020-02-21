#!/usr/bin/env python
# coding: utf-8

# ## Import packages

# In[1]:


import pandas as pd
import numpy as np
import os
from tqdm import tqdm_notebook

pd.set_option('display.max_columns', 500)

## Models
from deepctr.models import *
from deepctr.inputs import SparseFeat, DenseFeat, get_feature_names


# ## Set directory

# In[2]:


dir = input()
os.chdir(dir)


# ## Read data

# In[3]:


aud_train = pd.read_csv("preprocessed_data/aud_train_merged.csv")
no_aud_train = pd.read_csv("preprocessed_data/no_aud_train_merged.csv")


# ## Modeling

# ### DeepFM for audience data

# In[4]:


not_cat_list = ['cate_code_len','ins_pack_len','predicted_house_price','bid_id','click']
aud_sparse_features = [x for x in aud_train.columns if x not in not_cat_list]
no_aud_sparse_features = [x for x in no_aud_train.columns if x not in not_cat_list]
aud_dense_features = ['predicted_house_price', 'ins_pack_len', 'cate_code_len']

target=['click']


# #### Generate feature columns

# In[12]:


# Length of each feature
aud_sparse = [17,187,892,4,4206,4698,4041,137,2912,1013,
1,56,792,355,185,8,23,131,1001,29,13,2,2,24,60,7]


# In[14]:


aud_fixlen_feature_columns = [SparseFeat(feat, vocabulary_size=aud_sparse[i],embedding_dim=4)
                              for i,feat in enumerate(aud_sparse_features)] +[DenseFeat(feat, 1,)
 for feat in aud_dense_features]


# In[15]:


aud_dnn_feature_columns = aud_fixlen_feature_columns
aud_linear_feature_columns = aud_fixlen_feature_columns

aud_feature_names = get_feature_names(aud_linear_feature_columns + aud_dnn_feature_columns)


# #### Input train data

# In[16]:


aud_train_model_input = {name:aud_train[name] for name in aud_feature_names}


# #### Generate and train the model

# In[17]:


aud_model = DeepFM(aud_linear_feature_columns, aud_dnn_feature_columns, task='binary')
aud_model.compile("adam", "binary_crossentropy",metrics=['binary_crossentropy'],)


# In[18]:


aud_history = aud_model.fit(aud_train_model_input, aud_train[target].values,
                    batch_size=256, epochs=10, verbose=1)


# #### 모델 저장하기

# In[19]:


from keras.models import save_model

save_model(aud_model, 'saved_model/aud_model.h5')


# ### DeepFM for no audience data

# In[26]:


#Length of no_aud_train feature 

no_aud_sparse = [17,196,924,4,5929,6932,6409,162,4012,
                1237,2,125,1697,540,306,8,34,149,1340,
                31,24,60,7]


# In[28]:


no_aud_fixlen_feature_columns = [SparseFeat(feat, vocabulary_size=no_aud_sparse[i],embedding_dim=4)
                              for i,feat in enumerate(no_aud_sparse_features)] 


# In[30]:


no_aud_dnn_feature_columns = no_aud_fixlen_feature_columns
no_aud_linear_feature_columns = no_aud_fixlen_feature_columns

no_aud_feature_names = get_feature_names(no_aud_linear_feature_columns + no_aud_dnn_feature_columns)


# In[31]:


no_aud_train_model_input = {name:no_aud_train[name] for name in no_aud_feature_names}


# In[32]:


no_aud_model = DeepFM(no_aud_linear_feature_columns, no_aud_dnn_feature_columns, task='binary')
no_aud_model.compile("adam", "binary_crossentropy",metrics=['binary_crossentropy'])


# In[33]:


no_aud_history = no_aud_model.fit(no_aud_train_model_input, no_aud_train[target].values,
                    batch_size=256, epochs=3, verbose=1)


# #### 모델 저장하기

# In[ ]:


save_model(no_aud_model, "saved_model/no_aud_model.h5")

