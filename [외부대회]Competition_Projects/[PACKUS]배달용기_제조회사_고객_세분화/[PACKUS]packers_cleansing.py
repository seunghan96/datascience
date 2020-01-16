#!/usr/bin/env python
# coding: utf-8

# In[1]:


from packers_helper import *
from IPython.core.display import display, HTML
get_ipython().run_line_magic('load_ext', 'autoreload')
get_ipython().run_line_magic('autoreload', '2')
display(HTML("<style>.container { width:100% !important; }</style>"))


# In[2]:


# ## 최종 형태

# In[3]:


load_markdown("../패커스 데이터 전처리.md")


# ## 외부 데이터
#
# 지역별 경기 동행 지수 반영(상승세/ 하강세)
#
# 평균 경기

# ## 회원관리

# In[4]:


df_member = read_excel_by("회원관리")


# In[5]:


show_columns_md(df_member)


# ### 중복 제거

# 중복된 아이디 제거(휴면 계정 활성화 row 때문에)

# In[6]:


df_member.아이디.value_counts().unique()


# In[7]:


# 중복된 id들
df_member.아이디.value_counts().where(lambda x: x == 2).dropna().index


# In[8]:


df_member[df_member.아이디 == "kimese7"]


# 같은 아이디에 대해 가입 정보 row와 휴면 계정 활성화 row가 따로 있음. 2개의 row를 합쳐야 함
#
# 1. 둘다 NaN이거나 둘다 값이 있으면 그대로 둠
# 2. 한 쪽만 값이 있으면 그 값을 나머지에 복사하고 한 row를 제거

# In[9]:


# 고유한 아이디의 개수
len(df_member.아이디.unique())


# In[10]:


len(df_member.아이디)


# 4000개 정도의 중복된 row가 있음

# In[11]:


df_member_processed = remove_duplicated_member(df_member)


# In[12]:


# 13360 -> 8431, 중복 제거
df_member_processed.shape


# In[13]:


df_member = df_member_processed


# ### 컬럼 이름 공백 제거

# In[14]:


df_member.columns


# In[15]:


df_member.columns = df_member.columns.str.strip()


# ### 적립금 관련 컬럼 제거

# In[16]:


df_member.filter(like="적립").columns


# In[17]:


df_member = df_member.drop(columns=df_member_processed.columns.to_series().filter(like="적립"),
                           errors="ignore")


# In[18]:


df_member.columns


# ### 회원구분 레이블 통일

# In[19]:


df_member.회원구분.unique()


# In[20]:


df_member.회원구분.replace(
    to_replace={"personal": "개인", "business": "사업자"}, inplace=True)


# In[21]:


df_member.회원구분.unique()


# ### 컬럼 제거(WIP)

# In[22]:


df_member.columns


# In[23]:


df_member[df_member.회원구분 == "사업자"].shape


# In[24]:


df_member.주문건수


# In[25]:


df_member[(df_member.회원구분 == "사업자") & (df_member.주문건수 > 1)]


# In[26]:


df_member.상호.isnull().sum()


# In[27]:


columns_to_remove = ['가입경로', '가입시간',
                     "나이",  # 대부분이 120살로 되어 있음, 무의미
                     '등록일', '마일리지',
                     ]


# In[28]:


df_member_processed['총 실주문건수'] = pd.to_numeric(
    df_member_processed['총 실주문건수'], errors='coerce')


# In[29]:


df_member_processed['총 실주문건수'].value_counts()


# ## 통합 주문

# In[30]:


df_total_order = read_excel_by("통합 리스트")


# In[31]:


show_columns_md(df_total_order)


# In[32]:


df_total_order.shape


# In[33]:


df_total_order["총 주문금액"].unique()


# In[34]:


df_total_order.배송구분.unique()


# ### 환불된 거래 제거

# In[35]:


df_total_order[df_total_order.환불금액 == 0].shape


# In[36]:


df_total_order[df_total_order.환불금액 > 0].shape


# In[37]:


df_total_order[df_total_order.환불번호.isnull()].shape


# In[38]:


df_total_order[df_total_order.환불번호.isnull()].index


# In[39]:


df_total_order[~df_total_order.환불번호.isnull()].shape


# In[40]:


# 환불번호가 nan인데 환불금액이 0보다 큰 경우 --> 환불 절차가 진행중임 (제거 가능)
tmp = pd.merge(df_total_order[df_total_order.환불금액 > 0],
               df_total_order[df_total_order.환불번호.isnull()], how='inner')


# In[41]:


df_total_order[~df_total_order.환불번호.isnull()].filter(like="환불").환불접수일.unique()


# In[42]:


tmp.filter(like="환불").head()


# `환불금액`이 0인 것을 찾으면 됨

# In[43]:


df_total_order = df_total_order[df_total_order.환불금액 == 0]


# 환불 관련 컬럼 제거

# In[44]:


df_total_order = df_total_order.drop(columns=df_total_order.columns.to_series().filter(like="환불"),
                                     errors="ignore")


# ### 배송 관련 컬럼 제거

# In[45]:


df_total_order.배송구분.unique()


# 모든 상품은 이미 배송 완료됨

# In[46]:


df_total_order = df_total_order.drop(columns=df_total_order.columns.to_series().filter(like="배송"),
                                     errors="ignore")


# ### 회원 등급 관련 컬럼 제거

# In[47]:


df_total_order.filter(like="등급").columns


# In[48]:


df_total_order = df_total_order.drop(columns=df_total_order.columns.to_series().filter(like="등급"),
                                     errors="ignore")


# In[49]:


df_total_order.columns.sort_values()


# ### 취소되거나 부분취소된 거래 제거

# In[50]:


df_total_order.취소구분.value_counts()


# In[51]:


df_total_order = df_total_order[df_total_order.취소구분 == "취소안함"]


# 취소 관련 컬럼 제거

# In[52]:


df_total_order.filter(like="취소").columns


# In[53]:


df_total_order = df_total_order.drop(columns=df_total_order.columns.to_series().filter(like="취소"),
                                     errors="ignore")


# ### 교환 관련 처리

# 전부 교환 안함/ 교환 관련 컬럼 제거

# In[54]:


df_total_order.교환구분.unique()


# In[55]:


df_total_order.filter(like="교환").columns


# In[56]:


df_total_order = df_total_order.drop(columns=df_total_order.columns.to_series().filter(like="교환"),
                                     errors="ignore")


# ### 가격 관련 컬럼 제거

# In[57]:


df_total_order.filter(regex=".*(가|금액|가격|량)$").columns


# 판매가와 수량 제외한 나머지 할인/ 적립 관련된 컬럼은 제거

# In[58]:


df_total_order.drop(
    columns=df_total_order.filter(
        regex=".*(가|금액|가격|량)$").columns.drop(["수량", "판매가"]),
    errors="ignore", inplace=True)


# In[59]:


df_total_order.columns


# ### 할인 관련 컬럼 제거

# In[60]:


df_total_order.filter(like="할인").columns


# In[61]:


df_total_order = df_total_order.drop(columns=df_total_order.columns.to_series().filter(like="할인"),
                                     errors="ignore")


# ### 기타 컬럼 제거

# In[62]:


df_total_order.columns


# In[63]:


df_total_order.iloc[1, :]


# In[64]:


columns_to_remove = [
    "회원추가항목_가입경로", "카드사", "카드 승인번호", "즉시할인 유형", "주문자 가입일", "주문상태정보", "네이버 포인트",
    '입금 계좌번호', '입금은행', '주문 상태', '세금구분', '예치금', '옵션형태', '운송장번호', '유입경로'
]
df_total_order.drop(columns=columns_to_remove, inplace=True, errors="ignore")


# ### 상품번호 null 처리

# In[65]:


df_total_order.상품번호.isnull().sum()


# In[66]:


df_total_order = df_total_order[~df_total_order.상품번호.isnull()]


# In[67]:


df_total_order.shape


# ### 반품/반송 컬럼 관련 처리

# In[68]:


df_total_order.columns


# 반송한 거래가 없음

# In[69]:


df_total_order["반송완료일"].unique()


# In[70]:


df_total_order.filter(like="반품").columns


# In[71]:


df_total_order["반품접수거부 사유"].unique()


# In[72]:


df_total_order["반품접수거부 처리일"].unique()


# 반품 철회일: 반품을 신청했다가 철회한 경우는 있는 듯

# In[73]:


df_total_order["반품철회일"].unique()


# In[74]:


df_total_order[~df_total_order["반품철회일"].isnull()].shape


# In[75]:


df_total_order["반품접수거부 사유"].unique()


# In[76]:


df_total_order["반품철회 구분"].unique()


# 컬럼 제거 가능

# In[77]:


df_total_order.drop(
    columns=df_total_order.filter(like="반품").columns,
    inplace=True,
    errors="ignore"
)


# ### 기타 컬럼 제거 2

# In[78]:


df_total_order.columns


# In[79]:


df_total_order.iloc[1, :]


# In[80]:


columns_to_remove = [
    '결제번호', '결제수단', '결제일시(입금확인일)', '매출경로', '반송완료일', '사용한 쿠폰명',
    '상품명(패커스(PACKUS))', '상품소재(패커스(PACKUS))', '상품옵션', '상품옵션(기본)',
    '주문경로 주문번호(마켓/네이버페이 등)', '주문경로(PC/모바일)', '주문상품명(기본)', '주문상품명(세트상품 포함)',
    '주문상품명(옵션포함)', '출시일자', '특별관리회원', '품목번호', '품목별 주문번호', '회원추가항목_업종', '추가입력옵션',
    '상품자체코드', "발주일", "주문경로"
]
df_total_order.drop(columns=columns_to_remove, inplace=True, errors="ignore")


# In[81]:


df_total_order.columns


# In[82]:


df_total_order.head()


# ### Windowing

# In[83]:


df_total_order.columns


# In[84]:


df_total_order.shape


# In[85]:


df_total_order[df_total_order.주문번호 ==
               "20180905-0000773"].filter(like="주문").head()


# In[86]:


len(df_total_order.주문번호.unique())


# In[87]:


df_total_order.sort_values(by=["주문자ID", "주문일시"])


# In[88]:


df_total_order["주문일시_date"] = df_total_order.주문일시.apply(lambda d: d.date())
df_total_order["주문액"] = df_total_order.수량*df_total_order.판매가


# #### 주문 종류 상관 없이 날짜 하나를 하나의 거래로

# In[89]:


df_total_order_test = df_total_order.copy()


# In[90]:


df_total_order_test.shape


# In[91]:


df_total_order_test["주문일시_date"] = df_total_order_test.주문일시.apply(
    lambda d: d.date())
df_total_order_test["주문액"] = df_total_order_test.수량*df_total_order_test.판매가


# In[92]:


df_total_order_test_grouped = df_total_order_test.groupby(
    ["주문자ID", "주문일시_date"])


# In[93]:


df_total_order_test2 = df_total_order_test_grouped.first()
df_total_order_test2["주문액"] = df_total_order_test_grouped.주문액.sum()
df_total_order_test2.reset_index(inplace=True)
df_total_order_test2.drop(columns=["수량", "판매가"], errors="ignore", inplace=True)


# In[94]:


df_total_order_test2.shape


# In[95]:


df_total_order_test2.head()


# In[96]:


df_total_order_test = df_total_order_test2


# 2회 이상 거래자만 필터링

# In[97]:


ids_more_2_orders = df_total_order_test.주문자ID.value_counts(
)[df_total_order_test.주문자ID.value_counts() > 1].index


# In[98]:


df_total_order_test = df_total_order_test[df_total_order_test.주문자ID.isin(
    ids_more_2_orders)]


# In[99]:


df_total_order_test.sort_values(by=["주문자ID", "주문일시_date"], inplace=True)


# In[100]:


df_total_order_test["next_order_date"] = df_total_order_test.shift(
    -1).주문일시_date


# In[101]:


df_total_order_test = df_total_order_test[df_total_order_test.shift(
    -1).주문자ID == df_total_order_test.주문자ID]


# In[102]:


df_total_order_test["주문일시_interval_day"] = (
    df_total_order_test["next_order_date"] - df_total_order_test["주문일시_date"]).apply(lambda s: s.days)


# In[103]:


df_total_order_test.shape


# In[104]:


df_total_order_test[~df_total_order_test.주문자ID.isin(df_member.아이디)]


# In[149]:


items_more_1000 = df_total_order.상품번호.value_counts(
)[df_total_order.상품번호.value_counts() > 1000].unique()


# In[155]:


df_total_order.columns


# In[171]:


df_total_order.groupby("상품번호").수량.sum().sort_values(ascending=False)


# In[152]:


df_item[df_item.상품코드.isin(items_more_1000)].head(10)


# In[145]:


df_total_order.상품번호.value_counts(
)[df_total_order.상품번호.value_counts() > 200].shape


# ## 상품 리스트

# In[147]:


df_item = read_excel_by("상품")


# In[106]:


show_columns_md(df_item)


# ### 불필요한 컬럼 제거

# In[107]:


df_item.columns.to_series().filter(like="여부")


# In[108]:


df_item.drop(columns=df_item.columns.to_series().filter(like="여부"),
             inplace=True, errors="ignore")


# In[109]:


df_item.columns.to_series().filter(like="노출")


# In[110]:


df_item.drop(columns=df_item.columns.to_series().filter(like="노출"),
             inplace=True, errors="ignore")


# In[111]:


df_item.columns.to_series().filter(like="상태")


# In[112]:


df_item.drop(columns=df_item.columns.to_series().filter(like="상태"),
             inplace=True, errors="ignore")


# In[113]:


df_item.columns.to_series().filter(like="검색")


# In[114]:


df_item.drop(columns=df_item.columns.to_series().filter(like="검색"),
             inplace=True, errors="ignore")


# In[115]:


df_item.columns.to_series().filter(like="구매")


# In[116]:


df_item.drop(columns=df_item.columns.to_series().filter(like="구매"),
             inplace=True, errors="ignore")


# In[117]:


df_item.columns


# In[118]:


columns_to_remove = ['#', '공급사', '주요 사용 성별', "후기", "묶음주문단위", "상품대표색상", "네이버 카테고리 ID",
                     '가격비교 페이지 ID', '결제 수단 설정', '공급사', '과세/면세', '관련상품 수량', '관심', "담기", "등록일",
                     "마일리지 지급", "매입가", "매입처 상품명", "묶음주문기준", "재입고알림", "접근권한", "제조사", "수수료율"]
df_item.drop(columns=columns_to_remove, inplace=True, errors="ignore")


# In[119]:


df_item.columns


# ### 카테고리 정리

# 코드 : 레이블\n코드 : 레이블 ... 이런식으로 되어 있다
#
# 가장 상위 카테고리 코드는 3자리로 되어있으므로 3자리 카테고리가 어떤 것이 있는지 확인한다.

# In[120]:


df_item["카테고리(카테고리 코드:카테고리명)"].iloc[0]


# In[121]:


df_item["category_list"] = df_item["카테고리(카테고리 코드:카테고리명)"].apply(
    lambda s: s.split("\n"))


# In[122]:


def filter_category_code_by_digit(s: str, digit: int):
    result = []
    for category_str in s.split("\n"):
        if len(category_str.split()[0]) == digit:
            result.append(category_str)
    return result


df_item["category_3digit"] = df_item["카테고리(카테고리 코드:카테고리명)"].apply(
    filter_category_code_by_digit, digit=3)
df_item["category_6digit"] = df_item["카테고리(카테고리 코드:카테고리명)"].apply(
    filter_category_code_by_digit, digit=6)
df_item["category_9digit"] = df_item["카테고리(카테고리 코드:카테고리명)"].apply(
    filter_category_code_by_digit, digit=9)


# In[123]:


df_item["category_3digit"]


# In[124]:


sorted(pd.Series(df_item["category_3digit"].sum()).unique())


# In[125]:


sorted(pd.Series(df_item["category_6digit"].sum()).unique())


# In[126]:


sorted(pd.Series(df_item["category_9digit"].sum()).unique())


# 제외할 카테고리
# * NEW 카테고리 쓸모 없음(신상품)
#
# 포함할 카테고리
#
# * 용기(한식, 일식, 상관 없음)
# * 주방용품/소모품
# * 식자재(종류 상관 없이)
# * 실링제품
#
# 애매한 카테고리
# * 스티커

# In[127]:


def combine_category(s):
    for category in s:
        code = int(category.split()[0])
        if 38 <= code <= 44:
            return "용기"
        elif code == 46:
            return '주방용품/소모품'
        elif code == 50:
            return "식자재"
        elif code == 51:
            return "스티커"
    return "기타"


# In[128]:


df_item["combined_category"] = df_item["category_3digit"].apply(
    combine_category)


# ### 카테고리에서 업종 구분하기

# In[129]:


def extract_business(s):
    mapper = extract_business.mapper
    for category in s:
        code = int(category.split()[0])
        if code in mapper.keys():
            return mapper[code]
    return "UNKNOWN"


extract_business.mapper = {
    38: "한식",
    39: "중식",
    40: "일식",
    41: "양식",
    42: "베이커리/카페",
    50001: "한식",
    50002: "중식",
    50003: "일식",
    50004: "양식",
    50005: "베이커리/카페",
}


# In[130]:


df_item["업종"] = df_item.category_list.apply(extract_business)


# In[131]:


df_item["업종"].value_counts()


# In[132]:


df_item.drop(
    columns=list(df_item.filter(regex="^category.*").columns) +
    ["속성 정보", "자체상품코드", "카테고리(카테고리 코드:카테고리명)", "정가"],
    inplace=True
)


# ## 상품코드 종류

# In[133]:


df_item.상품코드.nunique()


# ## 상품리스트 + 통합주문

# In[133]:


df_total_order.head()


# In[134]:


df_item.head()


# ### 합치기

# In[135]:


df_merged = pd.merge(df_total_order, df_item,
                     left_on="상품번호", right_on="상품코드", how="left")


# In[136]:


df_merged.head()


# ### 카테고리별로

# In[137]:


df_merged_test = df_merged.copy()


# In[138]:


df_merged_test.shape


# In[139]:


df_merged_test_grouped = df_merged_test.groupby(
    ["주문자ID", "주문일시_date", "combined_category"])


# In[140]:


df_merged_test2 = df_merged_test_grouped.first()
df_merged_test2["주문액"] = df_merged_test_grouped.주문액.sum()
df_merged_test2.reset_index(inplace=True)
df_merged_test2.drop(columns=["수량", "판매가"], errors="ignore", inplace=True)


# In[141]:


df_merged_test2.shape


# In[142]:


df_merged_test2.head()


# In[143]:


df_merged_test = df_merged_test2


# 2회 이상 거래자만 필터링

# In[144]:


ids_more_2_orders = df_merged_test.주문자ID.value_counts(
)[df_merged_test.주문자ID.value_counts() > 1].index


# In[145]:


df_merged_test = df_merged_test[df_merged_test.주문자ID.isin(ids_more_2_orders)]


# In[146]:


df_merged_test.sort_values(
    by=["주문자ID", "combined_category", "주문일시_date"], inplace=True)


# In[147]:


df_merged_test["next_order_date"] = df_merged_test.shift(-1).주문일시_date


# In[148]:


df_merged_test = df_merged_test[
    (df_merged_test.shift(-1).주문자ID == df_merged_test.주문자ID)
    & (df_merged_test.shift(-1).combined_category == df_merged_test.combined_category)]


# In[149]:


df_merged_test["주문일시_interval_day"] = (
    df_merged_test["next_order_date"] - df_merged_test["주문일시_date"]).apply(lambda s: s.days)


# In[150]:


df_merged_test.head()


# In[152]:


df_member[df_merged_test.주문자ID.unique()]


# ## 테스트

# ### 통합주문.주문상품명 == 상품리스트.상품명(기본)

# In[ ]:


tmp = pd.merge(df_item, df_total_order, left_on="상품명(기본)", right_on="주문상품명")


# In[ ]:


tmp.filter(like="상품명").head()


# In[ ]:


tmp[tmp["상품명(기본)"] != tmp["주문상품명"]]


# ### 통합주문.발주일 != 상품리스트.주문일시

# In[ ]:


df_total_order.shape


# In[ ]:


df_total_order.발주일


# In[ ]:


(df_total_order.발주일.apply(lambda d: d.date()) - df_total_order.주문일시.apply(lambda d: d.date())
 ).apply(lambda d: d.days).value_counts().sort_index()


# 주문 날짜와 발주 날짜가 거의 대부분 2주 이내의  차이가 나며 고객이 제품이 필요한 경우에 주문을 넣기 떄문에 주문 날짜로 해도 무방함
