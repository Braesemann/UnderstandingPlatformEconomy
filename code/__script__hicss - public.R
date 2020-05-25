library("dplyr")
library("ggplot2")
library("tidyr")
library("viridis")

platforms = read.csv("data_platforms.csv", stringsAsFactors = FALSE, header=T)
survey = read.csv("data_survey.csv", stringsAsFactors = FALSE, header=T)
colors = read.csv("socialness.csv", stringsAsFactors = FALSE, header=T)

colors = colors %>% mutate(socialness = factor(socialness, levels = c("high", "moderate", "low")))



agg_p = platforms %>% group_by(platform) %>%
  summarize(n=n(),img_m=mean(has_image),fac_m=mean(face_visible),sdes_m=mean(has_selfdes),img_se=sd(has_image)/sqrt(n),fac_se=sd(face_visible)/sqrt(n),sdes_se=sd(has_selfdes)/sqrt(n)) %>%
  filter(platform != "gumtree") %>%
  select(platform, img_m, fac_m, sdes_m, img_se, fac_se, sdes_se)

temp = agg_p %>%
  gather("key", "value", 2:7)%>%
  separate("key", c("feature", "stats"), "_") %>%
  spread(key = "stats", value = "value")

gumtree = data.frame(platform = c("gumtree","gumtree", "gumtree"),
                     feature = c("fac", "img", "sdes"),
                     m = c(0, 0, 0),
                     se = c(0, 0, 0)) 

temp = rbind(temp, gumtree)
temp_frequ = temp

temp_frequ = merge(temp_frequ, colors)
temp_frequ = temp_frequ %>% 
  mutate(feature = ifelse(feature=="fac", "FV", ifelse(feature=="sdes", "SD", "IMG"))) %>%
  mutate(type = ifelse(type=="m", "mobility", ifelse(type=="e", "e-commerce", ifelse(type=="a","accommodation",ifelse(type=="c","carsharing","crowdwork")) ))) %>%
  mutate(txt = as.factor(paste(feature, platform) ))

temp_frequ$txt = reorder(temp_frequ$txt, temp_frequ$m)





agg_s = survey %>% group_by(type) %>%
  summarize(n=n(),img_m=mean(importance_image),fac_m=mean(importance_face),sdes_m=mean(importance_selfdes),img_se=sd(importance_image)/sqrt(n),fac_se=sd(importance_face)/sqrt(n),sdes_se=sd(importance_selfdes)/sqrt(n)) %>%
  select(type, img_m, fac_m, sdes_m, img_se, fac_se, sdes_se)

temp = agg_s %>%
  gather("key", "value", 2:7)%>%
  separate("key", c("feature", "stats"), "_") %>%
  spread(key = "stats", value = "value")

temp_importance = temp

temp_importance = merge(temp_importance, colors %>% group_by(type) %>% summarize(socialness=first(socialness))) %>%
  mutate(feature = ifelse(feature=="fac", "FV", ifelse(feature=="sdes", "SD", "IMG"))) %>%
  mutate(type = ifelse(type=="m", "mobility", ifelse(type=="e", "e-commerce", ifelse(type=="a","accommodation",ifelse(type=="c","carsharing","crowdwork")) ))) %>%
  mutate(txt = as.factor(paste(type, feature) ))

temp_importance$txt = reorder(temp_importance$txt, temp_importance$m)





### combination

temp_frequ$platform=NULL
temp_frequ$rank = NULL
temp_frequ$txt = NULL
temp_frequ$socialness2 = NULL
temp_importance$txt = NULL

temp_combined = merge(temp_frequ, temp_importance, by=c("type", "feature", "socialness") )

temp_combined$se.x=NULL
temp_combined$se.y=NULL

temp_combined = temp_combined %>% rename(x=m.x, y=m.y)

ggplot(data=temp_combined, aes(x=y, y=x, color=socialness ))+
  geom_smooth(mapping=aes(x=y, y=x, color=NULL), method=lm, color="grey", alpha=.10, size=0.66)+
  geom_point(size=4)+
  theme_bw()+
  xlim(1.5,6.5)+
  ylim(0,1)+
  labs(x="Importance (Likert Scale)",y="Frequency",title=NULL,color="Degree of \nSocial Interaction")+
  theme(axis.title = element_text(face="bold"), legend.title = element_text(face="bold"))+
  scale_color_manual(values=c("#92D14F", "grey", "#ED7D31"))






cor.test(temp_combined$x, temp_combined$y)

temp_combined = temp_combined %>% mutate(numsoc = ifelse(socialness=="high", 3, ifelse(socialness=="moderate",2,1)))
reg=lm(data=temp_combined, x ~ numsoc)
summary(reg)

temp_importance = temp_importance %>% mutate(numsoc = ifelse(socialness=="high", 3, ifelse(socialness=="moderate",2,1)))
reg=lm(data=temp_importance, m ~ numsoc)
summary(reg)






#### Distribution Plots --> this is not what is actually used in the paper

platforms_ratings_plot = platforms %>% 
  filter(!is.na(score)) %>% 
  mutate(score=ifelse(platform=="airbnb",score/20, score) ) %>%
  mutate(score=ifelse(platform=="wimdu",(score-1)*4/9+1, score) ) %>%
  mutate(score=ifelse(platform=="ebay",score/25+1, score) ) %>%
  mutate(score=ifelse(platform=="taskrabbit",score/25+1, score)) %>%
  select(platform, type, reviews, score)

platforms_activity_plot = platforms %>% 
  select(platform, type, reviews)

ggplot(data=platforms_ratings_plot,aes(x=score,color=platform)) + 
  geom_step(aes(y=..y..),stat="ecdf", size=.8) +
  scale_color_viridis(discrete = T, option="plasma")+
  scale_y_continuous(trans='log10') +
  theme_bw()







##### boxplot...

boxplotdata = platforms %>%
  select(score, platform) %>%
  filter(!is.na(score)) %>% 
  mutate(score=ifelse(platform=="airbnb",score/20, score) ) %>%
  mutate(score=ifelse(platform=="wimdu",(score-1)*4/9+1, score) ) %>%
  mutate(score=ifelse(platform=="ebay",score/25+1, score) ) %>%
  mutate(score=ifelse(platform=="taskrabbit",score/25+1, score))


summary3 = boxplotdata %>%
  group_by(platform) %>%
  summarize(meanscore = mean(score),
            n=n(),
            q10=quantile(score, .10),
            q25=quantile(score, .25),
            q50=quantile(score, .50),
            q75=quantile(score, .75),
            q90=quantile(score, .90))


## BOXPLOTS
ggplot(data=boxplotdata, aes(y=score, x=platform)) +
  geom_boxplot(aes(group = platform), outlier.alpha = 0.1)+
  theme_bw()+
  scale_y_continuous(breaks = seq(1,5,.1))+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

