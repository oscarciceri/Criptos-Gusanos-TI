
# ************ HCAHPS (Hospital Consumer Assessment of Healthcare Providers and Systems)  ***********

library(readxl)
library(readr)
library(tidyverse)
#Search the file
#file.choose()


# **************** ERROR WITH Excel ****************
#pwd_STATE_xlsx <- "C:\\Users\\oscar\\Documents\\Git\\Rprojects\\data_davinci\\xlsx\\STATE.xlsx"
#raw_data_STATE_xlxs  <- read_excel(pwd_STATE_xlsx)

# ****************  LOADLING THE RAW DATA # # ****************  
pwd_HSTATE <- "C:\\Users\\oscar\\Documents\\Git\\Rprojects\\data_davinci\\csv\\HHCAHPS_STATE.csv"
pwd_STATE  <- "C:\\Users\\oscar\\Documents\\Git\\Rprojects\\data_davinci\\csv\\STATE.csv"
pwd_PRVDR  <- "C:\\Users\\oscar\\Documents\\Git\\Rprojects\\data_davinci\\csv\\PRVDR.csv"
pwd_HPRVDR <- "C:\\Users\\oscar\\Documents\\Git\\Rprojects\\data_davinci\\csv\\HHCAHPS_PRVDR.csv"

raw_data_HPRVDR  <- read_csv(pwd_HPRVDR, show_col_types = FALSE)
raw_data_HSTATE  <- read_csv(pwd_HSTATE, show_col_types = FALSE)

raw_data_PRVDR  <- read_csv(pwd_PRVDR, show_col_types = FALSE)
raw_data_STATE  <- read_csv(pwd_STATE, show_col_types = FALSE)



# **************** CLEANING THE DATA ****************

# Rename the columns with dots
df_HPRVDR <- raw_data_HPRVDR %>%
  dplyr::rename_all(funs(make.names(.)))
df_HSTATE <- raw_data_HSTATE %>%
  dplyr::rename_all(funs(make.names(.)))

df_PRVDR <- raw_data_PRVDR %>%
  dplyr::rename_all(funs(make.names(.)))

df_STATE <- raw_data_STATE %>%
  dplyr::rename_all(funs(make.names(.)))


#  ************* Star Rating values *************
colnames(df_HPRVDR)


count(df_HPRVDR, HHCAHPS.Survey.Summary.Star.Rating)
#1 1                                     66
#2 2                                    633
#3 3                                   1307
#4 4                                   2191
#5 5                                   1522
#6 Not Available                       6082


#  ************* Footnote values *************
count(df_HPRVDR, Footnote.HHCAHPS.Survey.Summary.Star.Rating) 
# 1 "Fewer than 100 patients completed the survey. Use the scores shown, if any, with caution as the number of sur~  3842
# 2 "No survey results are available for this period."                                                               3903
# 3 "Survey results are based on less than 12 months of data."                                                         50
# 4 "There were problems with the data and they are being corrected."                                                  37
# 5 "Zero, or very few, patients met the survey\x92s rules for inclusion. The scores shown, if any, reflect a very~   409
# 6  NA                                                                                                              3560

#Set N/A
df_HPRVDR$HHCAHPS.Survey.Summary.Star.Rating[df_HPRVDR$Footnote.for.Star.Rating.for.gave.care.in.a.professional.way ==
                                               "No survey results are available for this period." |
                                               df_HPRVDR$Footnote.for.Star.Rating.for.gave.care.in.a.professional.way ==
                                               "There were problems with the data and they are being corrected." |
                                               df_HPRVDR$Footnote.for.Star.Rating.for.gave.care.in.a.professional.way ==
                                               "Zero, or very few, patients met the survey's rules for inclusion. The scores 
                                               shown, if any, reflect a very small number of surveys and may not accurately tell
                                               how an agency is doing."] <-  "Not Available"
count(df_HPRVDR, HHCAHPS.Survey.Summary.Star.Rating)      

#Drop N/A
df_HPRVDRx<-subset(df_HPRVDR, HHCAHPS.Survey.Summary.Star.Rating!="Not Available")
count(df_HPRVDRx, HHCAHPS.Survey.Summary.Star.Rating)                      
count(df_HPRVDRx, Footnote.for.Star.Rating.for.gave.care.in.a.professional.way)  

#Change Char to Integer
df_HPRVDRx$Percent.of.patients.who.reported.YES..they.would.definitely.recommend.the.home.health.agency.to.friends.and.family <- as.numeric(as.character(df_HPRVDRx$Percent.of.patients.who.reported.YES..they.would.definitely.recommend.the.home.health.agency.to.friends.and.family))
df_HPRVDRx$Percent.of.patients.who.gave.their.home.health.agency.a.rating.of.9.or.10.on.a.scale.from.0..lowest..to.10..highest. <- as.numeric(as.character(df_HPRVDRx$Percent.of.patients.who.gave.their.home.health.agency.a.rating.of.9.or.10.on.a.scale.from.0..lowest..to.10..highest.))

# ***** Exploratory Data Analysis EDA *****                       
# Analysis number of states

# Fig 0:  Evolution of the register medical
ggplot(data=df_HPRVDRx,
       aes(Date.Certified,
           fill = State)) +
  geom_histogram(bins = 50) +
  labs(x = 'Year',
       y = 'Number of registers', 
       subtitle = 'Evolution of medical registers',
       caption = 'Figure 1')


df_HPRVDRx %>% 
  ggplot(aes(x = Date.Certified,
             y = Percent.of.patients.who.gave.their.home.health.agency.a.rating.of.9.or.10.on.a.scale.from.0..lowest..to.10..highest.)) +
  geom_point()  + 
  geom_smooth(method = 'lm') +
  labs(x = 'Year',
       y = 'Percent of.patients that rating the agency between 9 to 10', 
       subtitle = 'Evolution of medical registers',
       caption = 'Figure 2')

df_HPRVDRx %>% 
  ggplot(aes(x = Date.Certified,
             y = Percent.of.patients.who.gave.their.home.health.agency.a.rating.of.9.or.10.on.a.scale.from.0..lowest..to.10..highest.,
             fill = factor(HHCAHPS.Survey.Summary.Star.Rating))) +
  geom_point(aes(colour=factor(HHCAHPS.Survey.Summary.Star.Rating), 
                 fill = factor(HHCAHPS.Survey.Summary.Star.Rating))) +
  geom_smooth(method = 'lm') +
  labs(x = 'Year',
       y = 'Percent of.patients that rating the agency between 9 to 10', 
       subtitle = 'Evolution of medical registers',
       caption = 'Figure 3',
       fill = "Star Rating",
       color = "Star Rating")



#Change Char to Integer
df_HPRVDRx$HHCAHPS.Survey.Summary.Star.Rating <- as.numeric(as.character(df_HPRVDRx$HHCAHPS.Survey.Summary.Star.Rating))


# Fig 1: State vs Frequency Star Ranking
ggplot(data=df_HPRVDRx,
       aes(State,
           fill = Type.of.Ownership)) +
  geom_bar() + 
  labs(x = 'States',
       y = 'Number of providers',
       subtitle = 'Number of providers',
       caption = 'Figure 4',
       fill = 'Type of Ownership')

# Fig 1a: Number of agency vs population density
pwd_density <- "C:\\Users\\oscar\\Documents\\Git\\Rprojects\\data_davinci\\csv\\csvData.csv"
data_density  <- read_csv(pwd_density, show_col_types = FALSE)

abrebiaturas <- state.abb[match(data_density$State,state.name)]
class(abrebiaturas)
len<-length(data_density$State)
for (i in rep(1:len,1)){
  data_density$State[i]<-abrebiaturas[i]
}

#Sort the data frame
indexs <- order(data_density$State, decreasing = FALSE)
indexs

data_density <- data_density[indexs, ]


state_frec <- count(df_HPRVDRx, State)

all <- merge(x = data_density, y = state_frec, by = "State", all = TRUE)

allx<-subset(all, Pop!="Not Available")
len<-length(allx$State)
for (i in rep(1:len,1)){
  allx$TotalArea[i]<-allx$n[i]/allx$Density[i]
}

ggplot(data = allx,
       mapping = aes(x = State,
                     y = TotalArea,
                     fill = Pop)) +
  geom_bar(stat='identity') +
  labs(x = 'States',
       y = 'Number of Agencies / Population Density',
       subtitle = 'Population Density vs Number of Agencies',
       caption = 'Figure 5',
       fill = "Population Size")

# Fig 2: State vs Mean Star Ranking
mean_data <- df_HPRVDRx %>% 
  group_by(State) %>% 
  summarise(mean_star = mean(HHCAHPS.Survey.Summary.Star.Rating))

ggplot(data = mean_data,
       mapping = aes(x = State,
                     y = mean_star,
                     fill = State)) +
  geom_bar(stat='identity') +
  coord_cartesian(ylim = c(2, 4.8)) +
  labs(x = 'States',
       y = 'Mean Star Value',
       subtitle = 'State vs Star Ranking',
       caption = 'Figure 6')

# Fig 3: Star Ranking vs Frequency
ggplot(data=df_HPRVDRx,
       aes(HHCAHPS.Survey.Summary.Star.Rating,
           fill = Type.of.Ownership)) +
  geom_bar() + 
  labs(x = 'Star Rating Score',
       y = 'Frecuency',
       subtitle = 'Star Rating vs Frecuency',
       caption = 'Figure 7',
       fill = "Type of Ownership")


# Fig 4: Type of Ownership vs Frequency 
ggplot(data = df_HPRVDRx,
       mapping = aes(x = Type.of.Ownership,
                     y = HHCAHPS.Survey.Summary.Star.Rating,
                     fill = Type.of.Ownership)) +
  geom_bar(stat='identity')  +
  labs(x = 'Type.of.Ownership',
       y = 'Number of Agencies',
       subtitle = 'Type of Ownership vs Number of Agencies',
       caption = 'Figure 8',
       fill = "Type of Ownership")

# Fig 5:  Type of Ownership vs Mean Star Ranking
mean_data <- df_HPRVDRx %>% 
  group_by(Type.of.Ownership) %>% 
  summarise(mean_star = mean(HHCAHPS.Survey.Summary.Star.Rating))

ggplot(data = mean_data,
       mapping = aes(x = Type.of.Ownership,
                     y = mean_star,
                     fill = Type.of.Ownership)) +
  coord_cartesian(ylim = c(3, 4.5)) +
  geom_bar(stat='identity')  +
  labs(x = 'Type.of.Ownership',
       y = 'Mean Star Value',
       subtitle = 'Type of Ownership vs Star Ranking',
       caption = 'Figure 9',
       fill = "Type of Ownership")



# Fig 7:  Type of Ownership vs Percent.of.patients.who.reported.YES..they.would.definitely.recommend.the.home.health.agency.to.friends.and.family
mean_data <- df_HPRVDRx %>% 
  group_by(Type.of.Ownership) %>% 
  summarise(mean_star = mean(Percent.of.patients.who.reported.YES..they.would.definitely.recommend.the.home.health.agency.to.friends.and.family))

ggplot(data = mean_data,
       mapping = aes(x = Type.of.Ownership,
                     y = mean_star,
                     fill = Type.of.Ownership)) +
  geom_bar(stat='identity')  +
  coord_cartesian(ylim = c(70, 85)) +
  labs(x = 'Type of Ownership',
       y = 'Percent of patients who definitely recommend the health agency',
       subtitle = 'Type of Ownership vs Star Ranking',
       caption = 'Figure 10')

# Fig 8: 

#Linear regression
lm(Percent.of.patients.who.gave.their.home.health.agency.a.rating.of.9.or.10.on.a.scale.from.0..lowest..to.10..highest. ~ Percent.of.patients.who.reported.YES..they.would.definitely.recommend.the.home.health.agency.to.friends.and.family, data = df_HPRVDRx)


ggplot(data = df_HPRVDRx,
       mapping = aes(x = Percent.of.patients.who.reported.YES..they.would.definitely.recommend.the.home.health.agency.to.friends.and.family,
                     y = Percent.of.patients.who.gave.their.home.health.agency.a.rating.of.9.or.10.on.a.scale.from.0..lowest..to.10..highest.,
                     color = Percent.of.patients.who.reported.that.their.home.health.team.gave.care.in.a.professional.way)) +
  geom_point(size = 3) + 
  geom_abline(intercept = 32.42,
              slope = 0.6568,
              col = 'orange',
              size = 2) +
  labs(x = 'Percent of patients who definitely recommend the health agency',
       y = 'Percent of.patients that rating the agency between 9 to 10',
       subtitle = 'Pacients percentage correlation',
       caption = 'Figure 11',
       color = "Percent of.patients who reporte that their \nuhealth team.gave professional way care")




# Fig 9: 
ggplot(data = df_HPRVDRx,
       mapping = aes(x = Percent.of.patients.who.reported.YES..they.would.definitely.recommend.the.home.health.agency.to.friends.and.family,
                     y = Percent.of.patients.who.gave.their.home.health.agency.a.rating.of.9.or.10.on.a.scale.from.0..lowest..to.10..highest.,
                     color = Percent.of.patients.who.reported.that.their.home.health.team.discussed.medicines..pain..and.home.safety.with.them)) +
  geom_point(size = 3) + 
  labs(x = 'Percent of patients who definitely recommend the health agency',
       y = 'Percent of.patients that rating the agency between 9 to 10',
       subtitle = 'Percent of.patients.who.reported.YES vs Percent.of.patients wich give rating.of.9.or.10.',
       caption = 'Figure 12',
       color = "Percent of patients who reported that \nhealth team discussed medicines with them")



# Fig 6: Percent.of.patients.who.reported.YES..they.would.definitely.recommend.the.home.health.agency.to.friends.and.family
ggplot(data=df_HPRVDRx,
       aes(Percent.of.patients.who.reported.YES..they.would.definitely.recommend.the.home.health.agency.to.friends.and.family,
           fill = Type.of.Ownership)) +
  geom_bar() + 
  labs(x = 'Percent of patients who definitely recommend the health agency [%]',
       y = 'Frecuency',
       subtitle = 'Percent of patients who definitely recommend the health agency',
       caption = 'Figure 13',
       fill = "Type of Ownership")

# Fig 11:  
#Filter
pp_low <- df_HPRVDRx %>% 
  filter(Percent.of.patients.who.reported.YES..they.would.definitely.recommend.the.home.health.agency.to.friends.and.family<=70)


colnames(pp_low)

snursing_Services <- count(pp_low, Offers.Nursing.Care.Services)
sphysical_Services <- count(pp_low, Offers.Physical.Therapy.Services)
soccupational_Services <- count(pp_low, Offers.Occupational.Therapy.Services)
spathology_Services <- count(pp_low, Offers.Speech.Pathology.Services)
ssocial_Services <- count(pp_low, Offers.Medical.Social.Services)
shome_Services <- count(pp_low, Offers.Home.Health.Aide.Services)

names(snursing_Services) <- c("type", "dat")
names(sphysical_Services) <- c("type", "dat")
names(soccupational_Services) <- c("type", "dat")
names(spathology_Services) <- c("type", "dat")
names(ssocial_Services) <- c("type", "dat")
names(shome_Services) <- c("type", "dat")

snursing_Services
sphysical_Services
soccupational_Services
spathology_Services
ssocial_Services
shome_Services

pp_low <- df_HPRVDRx %>% 
  filter(Percent.of.patients.who.reported.YES..they.would.definitely.recommend.the.home.health.agency.to.friends.and.family>=90)

snursing_Services <- count(pp_low, Offers.Nursing.Care.Services)
sphysical_Services <- count(pp_low, Offers.Physical.Therapy.Services)
soccupational_Services <- count(pp_low, Offers.Occupational.Therapy.Services)
spathology_Services <- count(pp_low, Offers.Speech.Pathology.Services)
ssocial_Services <- count(pp_low, Offers.Medical.Social.Services)
shome_Services <- count(pp_low, Offers.Home.Health.Aide.Services)

names(snursing_Services) <- c("type", "dat")
names(sphysical_Services) <- c("type", "dat")
names(soccupational_Services) <- c("type", "dat")
names(spathology_Services) <- c("type", "dat")
names(ssocial_Services) <- c("type", "dat")
names(shome_Services) <- c("type", "dat")

snursing_Services
sphysical_Services
soccupational_Services
spathology_Services
ssocial_Services
shome_Services

colnames(df_HPRVDRx)

df_HPRVDRx$HHCAHPS.Survey.Summary.Star.Rating <- as.character(as.numeric(df_HPRVDRx$HHCAHPS.Survey.Summary.Star.Rating))
ggplot(data = df_HPRVDRx,
       mapping = aes(x = Offers.Home.Health.Aide.Services,
                     y = Percent.of.patients.who.gave.their.home.health.agency.a.rating.of.9.or.10.on.a.scale.from.0..lowest..to.10..highest.,
                     fill = Type.of.Ownership)) +
  geom_boxplot() + 
  labs(x = 'Ofeer Health AIDE service',
       y = 'Percent of patients who definitely recommend the health agency [%]',
       subtitle = 'Boxplot ',
       caption = 'Figure 13',
       fill = "Type of Ownership")

ggplot(data = df_HPRVDRx,
       mapping = aes(x = HHCAHPS.Survey.Summary.Star.Rating,
                     y = Percent.of.patients.who.gave.their.home.health.agency.a.rating.of.9.or.10.on.a.scale.from.0..lowest..to.10..highest.,
                     fill = Offers.Occupational.Therapy.Services)) +
  geom_boxplot() + 
  labs(x = 'Star Rating',
                         y = 'Percent of.patients that rating the agency between 9 to 10',
                         subtitle = 'Percent of.patients that rating the agency between 9 to 10',
                         caption = 'Figure 14',
                         fill = "Type of Ownership")





# **********************************      PRVDR  ************************************************************
colnames(df_PRVDR)
count(df_PRVDR, Quality.of.patient.care.star.rating)
#1 1                                     66
#2 2                                    633
#3 3                                   1307
#4 4                                   2191
#5 5                                   1522
#6 Not Available                       6082


#  ************* Footnote values *************
count(df_PRVDR, Footnote.for.quality.of.patient.care.star.rating) 
#1 The number of patient episodes for this measure is too small to report.                                       2097
#2 There were problems with the data and they are being corrected.                                                  1
#3 This measure currently does not have data or provider has been certified/recertified for less than 6 months.   694
#4 NA                                                                                                              3560

#Set N/A
df_PRVDR$Quality.of.patient.care.star.rating[df_PRVDR$Footnote.for.quality.of.patient.care.star.rating ==
                                               "The number of patient episodes for this measure is too small to report." |
                                               df_PRVDR$Footnote.for.quality.of.patient.care.star.rating ==
                                               "There were problems with the data and they are being corrected." |
                                               df_PRVDR$Footnote.for.quality.of.patient.care.star.rating ==
                                               "This measure currently does not have data or provider has been certified/recertified for less than 6 months."] <-  "Not Available"
count(df_PRVDR, Quality.of.patient.care.star.rating)      

#Drop N/A
df_PRVDRx<-subset(df_PRVDR, Quality.of.patient.care.star.rating!="Not Available")
count(df_PRVDRx, Quality.of.patient.care.star.rating)                      
count(df_PRVDRx, Footnote.for.quality.of.patient.care.star.rating)                        

#Change Char to Integer
df_PRVDRx$Quality.of.patient.care.star.rating <- as.numeric(as.character(df_PRVDRx$Quality.of.patient.care.star.rating))
df_PRVDRx$How.often.the.home.health.team.checked.patients.for.depression <- as.numeric(as.character(df_PRVDRx$How.often.the.home.health.team.checked.patients.for.depression))

colnames(df_PRVDRx)

df_PRVDRx %>% 
  ggplot(aes(x = How.often.the.home.health.team.checked.patients.for.depression,
             y = How.often.patients.got.better.at.taking.their.drugs.correctly.by.mouth)) +
  geom_point() 
  

df_PRVDRx %>% 
  ggplot(aes(x = How.often.the.home.health.team.began.their.patients.U.0092..care.in.a.timely.manner,
             y = How.often.patients.got.better.at.walking.or.moving.around)) +
  geom_point() 


df_PRVDRx %>% 
  ggplot(aes(x = How.often.the.home.health.team.began.their.patients.U.0092..care.in.a.timely.manner,
             y = How.often.patients.receiving.home.health.care.needed.urgent..unplanned.care.in.the.ER.without.being.admitted)) +
  geom_point() 


#Linear regression
lm(How.often.the.home.health.team.began.their.patients.U.0092..care.in.a.timely.manner ~ How.often.patients.got.better.at.walking.or.moving.around, data = df_PRVDRx)

df_PRVDRx %>% 
  ggplot(aes(x = How.often.the.home.health.team.checked.patients.U.0092..risk.of.falling,
             y = How.often.the.home.health.team.began.their.patients.U.0092..care.in.a.timely.manner)) +
  geom_point() +  #"lm", "glm", "gam", "loess"
  geom_smooth(method = 'lm') +
  labs(x = 'How often  health team checked patients risk of falling',
       y = 'How often health team treat their.patients in a timely manner',
       subtitle = 'Percent of.patients that rating the agency between 9 to 10',
       caption = 'Figure 14',
       fill = "Type of Ownership")
  

  
lm(How.often.the.home.health.team.began.their.patients.U.0092..care.in.a.timely.manner ~ How.often.patients.receiving.home.health.care.needed.urgent..unplanned.care.in.the.ER.without.being.admitted, data = df_PRVDRx)

df_PRVDRx %>% 
  ggplot(aes(x = How.often.the.home.health.team.began.their.patients.U.0092..care.in.a.timely.manner,
             y = How.often.patients.receiving.home.health.care.needed.urgent..unplanned.care.in.the.ER.without.being.admitted)) +
  geom_point() + 
  geom_smooth(method = 'lm') +
  labs(x = 'How often health team treat their.patients in a timely manner',
       y = 'How often patients receiving health care needed urgent with unplanned.care in the ER',
       subtitle = 'Percent of.patients that rating the agency between 9 to 10',
       caption = 'Figure 15',
       fill = "Type of Ownership")

colnames(df_PRVDRx)

ggplot(data = df_PRVDRx,
       mapping = aes(x = How.often.home.health.patients..who.have.had.a.recent.hospital.stay..had.to.be.re.admitted.to.the.hospital,
                     y = How.often.the.home.health.team.began.their.patients.U.0092..care.in.a.timely.manner,
                     fill = Type.of.Ownership)) +
  geom_boxplot() +
  labs(x = 'How often health patients who have had a recent hospital stay had to be re admitted to the hospital',
       y = 'How often health team treat their.patients in a timely manner',
       subtitle = 'Percent of.patients that rating the agency between 9 to 10',
       caption = 'Figure 16',
       fill = "Type of Ownership")

ggplot(data = df_PRVDRx,
       mapping = aes(x = How.often.home.health.patients..who.have.had.a.recent.hospital.stay..had.to.be.re.admitted.to.the.hospital,
                     y = How.often.the.home.health.team.began.their.patients.U.0092..care.in.a.timely.manner,
                     fill = Type.of.Ownership)) +
  geom_boxplot() +
  geom_jitter() +
  labs(x = 'How often health patients who have had a recent hospital stay had to be re admitted to the hospital',
       y = 'How often health team treat their.patients in a timely manner',
       subtitle = 'Percent of.patients that rating the agency between 9 to 10',
       caption = 'Figure 16',
       fill = "Type of Ownership")

# *********** Decision tree classifier ******************


library(rpart)
library(rpart.plot)
library(rattle)
colnames(df_PRVDRx)
#Model
arbolx <- rpart(
  formula = Quality.of.patient.care.star.rating ~ How.often.the.home.health.team.began.their.patients.U.0092..care.in.a.timely.manner + 
    How.often.home.health.patients..who.have.had.a.recent.hospital.stay..had.to.be.re.admitted.to.the.hospital,
  data = df_PRVDRx,
  method = 'class'
)

fancyRpartPlot(arbolx)

#Prediction
pred_score <- predict(arbolx, type = 'class')
PRVDRx_pre <-  cbind(df_PRVDRx, 
                      pred_score)

#example
predict(object = arbolx,
        newdata = data.frame(Offers.Physical.Therapy.Services = "Yes"),
        type = 'class')




plot(arbol)

# ************************ df_HSTATE **************************
# Fig 1: Frequency vs Percent.of.patients.who.reported.that.their.home.health.team.gave.care.in.a.professional.way

ggplot(data=df_HSTATE,
       aes(Percent.of.patients.who.reported.that.their.home.health.team.gave.care.in.a.professional.way)) +
  geom_histogram(bins = 6) + 
  labs(x = '%',
       y = 'Frecuency',
       subtitle = 'Percent of Patients who reported that their home health team gave care in a professional way',
       caption = 'Figure 1')

# Fig 2: All Variables PDF
boxplot(df_HSTATE[,2:6], names=c("1","2","3", "4", "5"))

colnames(df_HSTATE)


library("writexl")
#file.choose()
write_xlsx(df_HPRVDRx,"C:\\Users\\oscar\\Documents\\Git\\Rprojects\\data_davinci\\HPRVDRx.xlsx")
write_xlsx(df_PRVDRx,"C:\\Users\\oscar\\Documents\\Git\\Rprojects\\data_davinci\\PRVDRx.xlsx")


#Costs,
#type of ownership
#HHCAHPS Survey Summary Star Rating

# PRVDR
# How often the home health team began theirpatients' care in a timely manner
# How often the home health team checked patients for depression
# How often patients got better at walking or moving around
# How often patients had less pain when moving around
# How often patients' wounds improved or healed after an operation
# How often home health patients, who have had a recent hospital stay, had to be re-admitted to the hospital


#
#State	
#CMS Certification Number (CCN)
#Provider Name	
#Zip	
#Type of Ownership
#HHCAHPS Survey Summary Star Rating



#fazr una contagen de clinica por stado