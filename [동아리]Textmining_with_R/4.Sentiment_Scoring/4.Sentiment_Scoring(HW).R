# 1-1
# 아마존 데이터를 불러오고 티블 형태의 데이터 프레임을 만들어 주세요.
setwd('C:\\Users\\samsung\\Desktop\\Bitamin\\Textmining with R\\4.Sentiment Scoring')
amazon_raw_data <- read.csv("amazon_raw_data.csv",stringsAsFactors = FALSE)
head(amazon_raw_data)

library(dplyr)
my.df.text <- data_frame(paper.id=1:1000,doc=amazon_raw_data$sentences)
head(my.df.text)

# 1-2
#데이터의 단어만 추출해주세요. 힌트(tidytext 패키지의 unnest_tokens를 이용하세요.)
library(tidytext)
my.df.text.word <- my.df.text %>% unnest_tokens(word,doc)
my.df.text.word

# 1-3.1
# 위의 단어들을 bing사전과 join 시켜주세요. (tidyr 패키지)
library(tidyr)
result_bing <- my.df.text.word %>% inner_join(get_sentiments("bing"))
result_bing

# 1-3.2
# join시킨 데이터의 단어를 count 해주세요.
result_bing <- result_bing %>% count(word,paper.id,sentiment)
result_bing

# 1-3.3
## count된 단어들을 spread 시켜 열로 만들어 주세요.
result_bing <- result_bing %>% spread(sentiment,n,fill=0)
result_bing 

# 1-3.4
# spread 된 데이터를 summarise 함수를 통해 긍정과 부정으로 나누고 이 둘을 합한 열을 만들어 주세요.
result_bing <- summarise(group_by(result_bing, paper.id),
                         pos.sum = sum(positive),
                         neg.sum = sum(negative),
                         score = pos.sum-neg.sum)

# 1-4
# 위의 데이터에서 인덱스와 점수 두 개의 열만 뽑아주세요.
result_bing = result_bing[c(1,4)]
result_bing

# 1-5
# 위의 데이터의 인덱스를 뽑아 실제 데이터의 인덱스를 맞춰주세요.
idx = result_bing$paper.id
amazon_raw_data_bing = amazon_raw_data[idx,]

# 1-6
# 예상한 데이터의 예측률을 파악해주세요.
pred_pos_idx_bing = result_bing$score >= 0 ##예상 긍정인것
raw_pos_idx_bing = amazon_raw_data_bing$sentiment == 1 ##실제 긍정인것
sum(pred_pos_idx_bing==raw_pos_idx_bing)/length(raw_pos_idx_bing) ## 감정사전의 예측 성공 비율

# 1-7
# CrossTable로 시각화하여 주세요.
pred_pos_idx_bing1 <- ifelse(result_bing$score >= 0, 1,0) ## 0이상이면 긍정, 아니면 부정으로 이분화
library(gmodels)
CrossTable(pred_pos_idx_bing1, amazon_raw_data_bing$sentiment,
           dnn = c('predicted','actual')) 

####################################################################

# 2-1
# polarity 함수를 이용하여 amazon 데이터의 각각의 텍스트에 polarity 점수를 매겨주세요.
# (힌트 : 새로운 오브젝트에 for 구문을 이용하여 점수를 넣어 주시고,
# polarity 점수만을 따오는 인덱스는 polarity()[[2]][4] 입니다. 마지막으로는 unlist까지 해주세요.)
amazon_pol <- NULL
library(qdap)
for (i in 1:nrow(amazon_raw_data)) {
  amazon_pol[i] <- polarity(amazon_raw_data[i,"sentences"])[[2]][4]
}
# 2번째 줄, 4행에 ave.polarity있응니까
head(amazon_pol)

amazon_pol <- unlist(amazon_pol)
head(amazon_pol)

# 2-2
# 점수를 매긴 오브젝트를 텍스트 인덱스와 점수 두 열이 있는 데이터 프레임 형태로 만들어 주세요. (힌트 : data.frame(doc = , score = ))
amazon_pol <- data.frame(doc = 1:nrow(amazon_raw_data), score = amazon_pol)
head(amazon_pol)

# 2-3
# 위의 데이터에서 0점인 텍스트를 찾고, 점수를 매긴 데이터 프레임에 해당 텍스트를 제거해 주세요.
zero <- which(amazon_pol$score == 0)
amazon_pol <- amazon_pol[-zero,]
head(amazon_pol)

# 2-4
# 0점이 제거된 데이터의 인덱스를 실제 데이터에도 적용해주세요.
idx2 <- amazon_pol$doc
amazon_raw_data_pol <- amazon_raw_data[idx2,]

# 2-5
# polarity 점수가 양수인 텍스트에 1, 음수인 텍스트에 0을 부여하는 새로운 열을 만들어 주세요.
amazon_pol$score1 <- ifelse(amazon_pol$score >= 0, 1, 0)


# 2-6
# 실제 데이터와 비교하여 예측률을 파악해 주세요. 
sum(amazon_pol$score1 == amazon_raw_data_pol$sentiment)/nrow(amazon_raw_data_pol)

# 2-7
# CrossTable을 통해 시각화하여 주세요.
CrossTable(amazon_pol$score1, amazon_raw_data_pol$sentiment,
           dnn = c("predicted","actual"))

write.csv(amazon_raw_data, "amazon_raw_data.csv")
