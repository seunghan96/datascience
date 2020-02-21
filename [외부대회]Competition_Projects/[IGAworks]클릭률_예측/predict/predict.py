#!/usr/bin/env python
# coding: utf-8

# ## Import packages

# In[134]:


import pandas as pd
import numpy as np
import os
from tensorflow.keras.models import load_model

pd.set_option('display.max_columns', 500)

## Models
from deepctr.models import *
from deepctr.inputs import SparseFeat, DenseFeat, get_feature_names


# ## Set directory

# In[135]:


dir = input()
os.chdir(dir)

## My directory = C:\\Users\\asus\\Desktop\\CTR Prediction competition\\IGAworks


# ## Read data

# ### Test

# In[136]:


test_merged = pd.read_csv("raw_data/test.csv")


# ### Audience

# In[59]:


audience = pd.read_csv("raw_data/audience_profile.csv")


# ## Merge data

# In[60]:


test_merged = pd.merge(test, audience, on="device_ifa", how="left")


# ## Preprocessing

# ### Split time to hour minute, weekday

# In[137]:


test_merged['event_datetime'] = pd.to_datetime(test_merged['event_datetime'])
test_merged['hour'] = test_merged['event_datetime'].apply(lambda x: x.hour)
test_merged['min'] = test_merged['event_datetime'].apply(lambda x: x.minute)
test_merged['weekday'] = test_merged['event_datetime'].dt.dayofweek


# ### Drop unnecessary columns

# In[138]:


drop_list = ['event_datetime','device_ifa','device_country','asset_index']
test_merged.drop(columns=drop_list, inplace=True)


# ### Split merged data by existence of audience profile

# In[140]:


audience_info = ['marry','install_pack','gender','cate_code','age','predicted_house_price']


# In[141]:


aud_test_merged = test_merged.dropna(subset=['age','gender','marry','install_pack','cate_code'])
no_aud_test_merged = test_merged.loc[~test_merged.bid_id.isin(aud_test_merged.bid_id)].drop(columns=audience_info)


# ### How many install packages

# In[143]:


aud_test_merged['ins_pack_len'] = aud_test_merged.loc[:,'install_pack'].apply(lambda x: len(x.split(',')) +1) 
aud_test_merged['cate_code_len'] = aud_test_merged.loc[:,'cate_code'].apply(lambda x: len(x.split(',')) +1)


# In[144]:


## 처리 완료된 변수 제거

aud_drop_list = ['cate_code','install_pack']
aud_test_merged.drop(columns=aud_drop_list, inplace=True)


# ### LabelEncoding

# #### For audience

# In[145]:


not_cat_list = ['cate_code_len','ins_pack_len','weekday','min','hour','predicted_house_price','age','bid_id','click']
aud_sparse_features = [x for x in aud_test_merged.columns if x not in not_cat_list]
no_aud_sparse_features = [x for x in no_aud_test_merged.columns if x not in not_cat_list]
target=['click']


# In[146]:


aud_dense_features = ['ins_pack_len','cate_code_len','predicted_house_price']
aud_test_merged.loc[:, aud_dense_features] = aud_test_merged.loc[:, aud_dense_features].fillna(0,)


# In[147]:


aud_test_merged2 = aud_test_merged.copy()
no_aud_test_merged2 = no_aud_test_merged.copy()


# In[149]:


from sklearn.preprocessing import LabelEncoder
import pickle


for feat in aud_sparse_features:
    lbe=LabelEncoder()
    pkl_file = open('label_classes/aud_classes2/aud_'+feat+'_encoder.pkl','rb')
    lbe = pickle.load(pkl_file)
    pkl_file.close()
    
    for label in np.unique(aud_test_merged2[feat]):
        if label not in lbe.classes_:
            lbe.classes_ = np.append(lbe.classes_, label)
    aud_test_merged2[feat] = lbe.transform(aud_test_merged2[feat])


# #### For no_audience

# In[150]:


from sklearn.preprocessing import LabelEncoder
import pickle


for feat in no_aud_sparse_features:
    lbe2=LabelEncoder()
    pkl_file = open('label_classes/no_aud_classes2/no_aud_'+feat+'_encoder.pkl','rb')
    lbe2 = pickle.load(pkl_file)
    pkl_file.close()
    
    for label in np.unique(no_aud_test_merged2[feat]):
        if label not in lbe2.classes_:
            lbe2.classes_ = np.append(lbe2.classes_, label)
    no_aud_test_merged2[feat] = lbe2.transform(no_aud_test_merged2[feat])


# ### MinMaxScaling

# In[191]:


from sklearn.preprocessing import MinMaxScaler
from sklearn.externals import joblib

scaler_filename = 'scaler/mms.save'
mms = joblib.load(scaler_filename)
aud_test_merged2[aud_dense_features] = mms.transform(aud_test_merged2.loc[:,aud_dense_features])


# ## Modeling

# ### Predict for audience data

# In[ ]:


# Length of each feature
aud_sparse = [17,187,892,4,4206,4698,4041,137,2912,1013,
1,56,792,355,185,8,23,131,1001,29,13,2,2,24,60,7]


# In[153]:


from deepctr.layers import custom_objects
aud_model = load_model("saved_model/aud_model.h5", custom_objects)


# In[199]:


not_cat_list = ['cate_code_len','ins_pack_len','predicted_house_price','bid_id','click']
aud_sparse_features = [x for x in aud_test_merged2.columns if x not in not_cat_list]
no_aud_sparse_features = [x for x in no_aud_test_merged2.columns if x not in not_cat_list]
aud_dense_features = ['predicted_house_price', 'ins_pack_len', 'cate_code_len']

target=['click']


# In[200]:


aud_fixlen_feature_columns = [SparseFeat(feat, vocabulary_size=aud_sparse[i],embedding_dim=4)
                              for i,feat in enumerate(aud_sparse_features)] +[DenseFeat(feat, 1,)
 for feat in aud_dense_features]


# In[201]:


aud_dnn_feature_columns = aud_fixlen_feature_columns
aud_linear_feature_columns = aud_fixlen_feature_columns

aud_feature_names = get_feature_names(aud_linear_feature_columns + aud_dnn_feature_columns)


# In[202]:


aud_test_model_input = {name:aud_test_merged2[name] for name in aud_feature_names}


# In[203]:


aud_pred_ans = aud_model.predict(aud_test_model_input, batch_size = 256)
aud_test_merged2['CTR'] = aud_pred_ans


# ### Predict for no audience data

# In[ ]:


#Length of no_aud_train feature 

no_aud_sparse = [17,196,924,4,5929,6932,6409,162,4012,
                1237,2,125,1697,540,306,8,34,149,1340,
                31,24,60,7]


# In[209]:


no_aud_model = load_model("saved_model/no_aud_model.h5",custom_objects)


# In[210]:


no_aud_fixlen_feature_columns = [SparseFeat(feat, vocabulary_size=no_aud_sparse[i],embedding_dim=4)
                              for i,feat in enumerate(no_aud_sparse_features)] 


# In[211]:


no_aud_dnn_feature_columns = no_aud_fixlen_feature_columns
no_aud_linear_feature_columns = no_aud_fixlen_feature_columns

no_aud_feature_names = get_feature_names(no_aud_linear_feature_columns + no_aud_dnn_feature_columns)


# In[212]:


no_aud_test_model_input = {name:no_aud_test_merged2[name] for name in no_aud_feature_names}


# In[213]:


no_aud_pred_ans = no_aud_model.predict(no_aud_test_model_input, batch_size = 256)
no_aud_test_merged2['CTR'] = no_aud_pred_ans


# In[215]:


ans_df = pd.concat([aud_test_merged2, no_aud_test_merged2])
ans = ans_df[['bid_id','CTR']]
ans.to_csv("prediction_result/final_result.csv", index=False, header=False)

