library(rvest)
library(magrittr)

resource <- "www.tripadvisor.com"
html.page <- html_session("http://www.tripadvisor.com/Restaurants-g188590-Amsterdam_North_Holland_Province.html")

Name <- NULL
Link <- NULL
for (i in 1:100) {
  Name <- c(Name, html.page %>%
    html_nodes(xpath="//div[@class='shortSellDetails']//h3//a[@target='_blank']") %>% 
    html_text()
  )
  
  Link <- c(Link, html.page %>%
    html_nodes(xpath="//div[@class='shortSellDetails']//h3//a[@target='_blank']") %>% 
    html_attr("href") 
  )
  
  next.link <- html.page %>% html_nodes(xpath="//link[@rel='next']") %>% html_attr("href")
  if(length(next.link) == 0) break 
  html.page <- html(paste0("http://", resource, next.link))
}
Name <- gsub("[\n]", "", Name)
Link <- paste0("http://www.tripadvisor.com", Link) 
data <- data.frame(Name, Link)
write.csv(data, file = "TripAdvisor.csv")
#--------------------------------#
#   upload data 
#--------------------------------#
library(RMySQL)
mydb = dbConnect(MySQL(), user='bang_net_wordpre', password='Zhangyunhe1', dbname='bangbangmang_net_wordpre', host='https://mysql.transip.eu/')
