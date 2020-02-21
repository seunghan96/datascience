#!/usr/bin/env python
# coding: utf-8

# # Import packages

# In[1]:


import pandas as pd
import numpy as np
import os
import zipfile

pd.set_option('display.max_columns', 500)


# # Set directory

# In[2]:


dir = input()
os.chdir(dir)


# # Read data

# ## Train

# In[ ]:


train_chunks = pd.read_csv("raw_data/train.csv", index_col=0, chunksize=4e+7)
train = pd.concat(train_chunks)


# ## Audience

# In[ ]:


# If use zip file
# zf = zipfile.ZipFile(path)
# audience = pd.read_csv(zf.open("audience_profile.csv"))


# In[ ]:


# if use unzip file
audience = pd.read_csv("raw_data/audience_profile.csv")


# ## Merge train and audience

# In[ ]:


# train과 audience의 공통 변수 device_ifa를 기준으로 결합
train_merged = pd.merge(train, audience, on="device_ifa", how="left")


# # Preprocessing

# ## Split time to hour, minute, weekday

# In[ ]:


train_merged['event_datetime'] = pd.to_datetime(train_merged['event_datetime'])
train_merged['hour'] = train_merged['event_datetime'].apply(lambda x: x.hour)
train_merged['min'] = train_merged['event_datetime'].apply(lambda x: x.minute)
train_merged['weekday'] = train_merged['event_datetime'].dt.dayofweek


# In[ ]:


drop_list = ['event_datetime','device_ifa','device_country']
train_merged.drop(columns=drop_list, inplace=True)


# ## Split merged data by existence of audience profile

# In[ ]:


audience_info = ['marry','install_pack','gender','cate_code','age','asset_index','predicted_house_price']


# In[ ]:


aud_train_merged = train_merged.dropna(subset=['age','gender','marry','install_pack','cate_code'])
no_aud_train_merged = train_merged.drop(columns=audience_info)


# In[ ]:


aud_train_merged['ins_pack_length'] = aud_train_merged.loc[:,'install_pack'].apply(lambda x: len(x.split(',')) +1) 


# In[ ]:


aud_drop_list = ['asset_index','cate_code','install_pack']
aud_train_merged.drop(columns=aud_drop_list, inplace=True)


# ## LabelEncoding

# In[ ]:


not_cat_list = ['bid_id','click','ins_pack_len','cate_code','predicted_house_price']
aud_sparse_features = [x for x in aud_train_merged.columns if x not in not_cat_list]
no_aud_sparse_features = [x for x in no_aud_train_merged.columns if x not in not_cat_list]
aud_dense_features = ['ins_pack_len','cate_code_len','predicted_house_price']
aud_train_merged[aud_dense_features] = aud_train_merged[aud_dense_features].fillna(0, )

target=['click']


# In[ ]:


aud_train_merged2 = aud_train_merged.copy()
no_aud_train_merged2 = no_aud_train_merged.copy()


# In[ ]:


from sklearn.preprocessing import LabelEncoder
import pickle

for feat in aud_sparse_features:
    lbe = LabelEncoder()
    output = open('label_classes/aud_classes/aud_'+feat+'_encoder.pkl', 'wb')
    lbe.fit(aud_train_merged[feat])
    pickle.dump(lbe, output)
    output.close()
    aud_train_merged2[feat] = lbe.transform(aud_train_merged[feat])


# In[ ]:


for feat in no_aud_sparse_features:
    lbe2 = LabelEncoder()
    output = open('label_classes/no_aud_classes/no_aud_'+feat+'_encoder.pkl', 'wb')
    lbe2.fit(no_aud_train_merged[feat])
    pickle.dump(lbe2, output)
    output.close()
    no_aud_train_merged2[feat] = lbe2.transform(no_aud_train_merged[feat])


# ## MinMaxScaler

# In[ ]:


from sklearn.preprocessing import MinMaxScaler
from sklearn.externals import joblib

mms = MinMaxScaler(feature_range=(0,1))
mms.fit(aud_train_merged2.loc[:,aud_dense_features])
scaler_filename = 'scaler/mms.save'
joblib.dump(mms, scaler_filename)
aud_train_merged2.loc[:,aud_dense_features] = mms.transform(aud_train_merged2.loc[:,aud_dense_features])


# # Export to csv

# In[ ]:


aud_train_merged2.to_csv("preprocessed_data/aud_train_merged.csv", index=False)
no_aud_train_merged2.to_csv("preprocessed_data/no_aud_train_merged.csv", index=False)

