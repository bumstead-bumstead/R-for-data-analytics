# Part 1: XPath with XML -----------------------------------------
install.packages("XML")
library("XML")

# XML/HTML parsing
obamaurl <- "http://www.obamaspeeches.com/"
obamaroot <- htmlParse(obamaurl) #html 불러옴
obamaroot

# Xpath example
xmlfile <- "xml_example.xml" #xml은 hierarcy 형태로 되어있음.
tmpxml <- xmlParse(xmlfile)
root <- xmlRoot(tmpxml) #xmlRoot : 가장 최상위 node를 찾아옴 (bookstore)
root

# Select children node
xmlChildren(root)[[1]]#root node에서 하위 node 중 첫번째를 가져온다.

xmlChildren(xmlChildren(root)[[1]])[[1]]
xmlChildren(xmlChildren(root)[[1]])[[2]]
xmlChildren(xmlChildren(root)[[1]])[[3]]
xmlChildren(xmlChildren(root)[[1]])[[4]]

# Selecting nodes
xpathSApply(root, "/bookstore/book[1]")#xpathSApply는 xml에서 정보 빼오는거?
xpathSApply(root, "/bookstore/book[last()]")
xpathSApply(root, "/bookstore/book[last()-1]")
xpathSApply(root, "/bookstore/book[position()<3]")
###강의 ppt 튜토리얼 사이트 참고하자###
# Selecting attributes
xpathSApply(root, "//@category")#슬래시 두개면 위계상관없이 해당되는 것 모두 return
xpathSApply(root, "//@lang")#@는 attribute을 의미
xpathSApply(root, "//book/title", xmlGetAttr, 'lang')

# Selecting atomic values #xml 코드에서 <>안에 있는 것은 attribute, 그 사이에 있는 것은 atomic value 라고 한다.
xpathSApply(root, "//title", xmlValue)#node에서 attribute은 없어도 되지만 atomic value는 꼭 있어야함.
xpathSApply(root, "//title[@lang='en']", xmlValue)#xmlvalue : atomic value 가져옴
xpathSApply(root, "//book[@category='web']/price", xmlValue)
xpathSApply(root, "//book[price > 35]/title", xmlValue)
xpathSApply(root, "//book[@category = 'web' and price > 40]/price", xmlValue)

# Part 2: Web Scraping (arXiv Papers) -----------------------------------------
install.packages("dplyr")
install.packages("stringr")
install.packages("httr")
install.packages("rvest")

library(dplyr)
library(stringr)
library(httr)
library(rvest)

url <- 'https://arxiv.org/search/?query=%22text+mining%22&searchtype=all&source=header&start=0'

parse_url(url) #???

start <- proc.time()#proc.time:현재 시점에 대한 time stamp 찍음
title <- NULL
author <- NULL
subject <- NULL
abstract <- NULL
meta <- NULL

pages <- seq(from = 0, to = 335, by = 50)

for( i in pages){
  
  tmp_url <- modify_url(url, query = list(start = i))
  tmp_list <- read_html(tmp_url) %>% html_nodes('p.list-title.is-inline-block') %>% # %>% : 앞의 결과물을 입력으로 받아서 뒤에 있는 것을 실행해라.
    html_nodes('a[href^="https://arxiv.org/abs"]') %>% html_attr('href') #a는 attribute의 약자. ^은 뭐임??###
  #html_nodes(): ()안의 속성을 갖는 node를 따와라
  #node를 불러올 때 띄어쓰기는 .으로 대체함. 규칙
  for(j in 1:length(tmp_list)){
    
    tmp_paragraph <- read_html(tmp_list[j])
    
    # title
    tmp_title <- tmp_paragraph %>% html_nodes('h1.title.mathjax') %>% html_text(T)#html_text가 뭐임???###
    tmp_title <-  gsub('Title:', '', tmp_title)#tmp title에 대해서 Title을 ''로 대체함 (없앰)
    title <- c(title, tmp_title)
    
    # author
    tmp_author <- tmp_paragraph %>% html_nodes('div.authors') %>% html_text #div에서 class는 authors인 것을 가져온다.
    tmp_author <- gsub('\\s+',' ',tmp_author) #모든 공백을 한칸 스페이스로 대체하겠다?
    tmp_author <- gsub('Authors:','',tmp_author) %>% str_trim #str_trim은 저자이름 양쪽에 빈칸있으면 삭제하겠다는거
    author <- c(author, tmp_author)  
    
    # subject
    tmp_subject <- tmp_paragraph %>% html_nodes('span.primary-subject') %>% html_text(T)#Information Retrieval은 왜안나옴?
    subject <- c(subject, tmp_subject)
    
    # abstract
    tmp_abstract <- tmp_paragraph %>% html_nodes('blockquote.abstract.mathjax') %>% html_text(T)
    tmp_abstract <- gsub('\\s+',' ',tmp_abstract)#줄넘김 삭제??
    tmp_abstract <- sub('Abstract:','',tmp_abstract) %>% str_trim 
    abstract <- c(abstract, tmp_abstract)
    
    # meta
    tmp_meta <- tmp_paragraph %>% html_nodes('div.submission-history') %>% html_text
  tmp_meta <- lapply(strsplit(gsub('\\s+', ' ',tmp_meta), '[v1]', fixed = T),'[',2) %>% unlist %>% str_trim #'[',2)는 리스트에서 두번 째 항목에 대해서만 해라.
    meta <- c(meta, tmp_meta)
    cat(j, "paper\n")
    
  }
  cat((i/50) + 1,'/ 7 page\n')
  Sys.sleep(3)#3초간 멈춤. 서버에 부하가 걸리면 IP를 차단해버릴 수 있어서. 사람인척
  
}
papers <- data.frame(title, author, subject, abstract, meta)
end <- proc.time()#소요시간 계산용
end - start # Total Elapsed Time

# Export the result
save(papers, file = "Arxiv_Text_Mining.RData") #RData형태로 저장?
write.csv(papers, file = "Arxiv papers on Text Mining.csv")

