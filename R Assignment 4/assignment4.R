library(dplyr)
library(stringr)
library(httr)
library(rvest)
library(RSelenium)
install.packages('RSelenium')

url <- 'https://stackoverflow.com/search?q=block+chain'

cnt <- 1
#반복문이 돌 때마다 데이터프레임에 값을 넣어주기 위한 index 용도로 쓴다.

start <- proc.time() #데이터를 모두 가져오는 데 걸리는 시간을 확인하기 위한 용도.
Stackoverflow_QA <- data.frame()



#댓글을 따오는 부분에서 링크에 숨겨져있는 부분이 있어 동적 크롤링이 필요할 것이라고 생각했고, selenium 패키지를 이용했다.
remDr=remoteDriver(remoteServerAddr = "localhost", port=4445L, browserName='chrome') #remote설정
remDr$open() #chrome 열기
#selenium을 이용해 chrome에서 동적 크롤링을 하기 위해선 크롬 드라이버의 버전이 크롬 버전과 같아야하고 java가 설치되어있어야한다.

#cmd에  geckodriver, selenium, chromedriver가 저장된 폴더로 이동 후 java -Dwebdriver.gecko.driver="geckodriver.exe" -jar selenium-server-standalone-3.141.59.jar -port 4445



for (i in 1:10) { #10개의 페이지를 각각 검사한다.
  
  
  
  tmp_url <- paste0('https://stackoverflow.com/search?page=', i, '&tab=Relevance&q=block%20chain')
  #stackoverflow 검색 페이지의 url을 확인했을 때, serch?page= 뒤에 현재 페이지를 확인할 수 있다는 사실을 알 수 있었다.
  #따라서 past0 함수를 이용해 공백없이 페이지별 url을 만들었고, 
  #모든 페이지를 검사할 수 있도록 1부터 10까지의 반복문을 이용해 tmp_url 변수에 매번 지정될 수 있게 했다.
  
  tmp_page <- read_html(tmp_url)
  
  for (j in 1:15) { # 한 페이지 당 15개의 게시글이 있으므로 1~ 15까지, i 페이지의 j번째 질문을 검사한다.
    
    cat("Scraping the", j, "-th Question of the", i, "-th page. \n")
    #현재 scraping 진행 상태를 확인하기 위한 코드이다.
    
    a <- tmp_page %>% html_nodes('div.result-link')
    tmp_list <- tmp_page %>% html_nodes('div.result-link') %>% html_nodes('a[href^="/questions"]') %>% html_attr('href')
    tmp_link <- paste0('https://stackoverflow.com', tmp_list[j])
    tmp_question <- read_html(tmp_link)
    #div.result-link 클래스 안에 각 게시글의 url이 포함되어 있다는 것을 알았다.
    #a변수에 이를 저장하고, a 중에 url은 모두 /questions를 포함하고 있기 때문에, 이 부분을 따오고,
    #url이 href 클래스 안에 있기 때문에 html_attr(href) 함수로 15개의 url들을 벡터 형태로 저장할 수 있었다. 
    #그리고 각각의 질문 게시글의 url 모두 확인할 수 있도록 paste0() 함수를 이용해 tmp_list의 j번째 원소를 tmp_question 변수에 저장했다.
    
    
    ########동적 크롤링을 위한 설정. 
    
    remDr$navigate(tmp_link) #질문 페이지로 이동
    
    com_code <- tmp_question %>% html_nodes('div[id^="comments-link-"]') %>% html_attr('id') %>% substr(., 15, nchar(.)) %>% as.numeric()
    #link로 숨겨진 부분이 div 노드의 id에 고유의 코드를 갖고 있다는 사실을 알았고, 이 부분에서 각 link에 대한 코드만을 따왔다.
    for (u in c(1:length(com_code))) { #for문을 이용해 모든 버튼을 각각 누른다.
      Sys.sleep(0.3)
      webElem <- remDr$findElement(using = 'xpath', value = paste0('//*[@id=\'comments-link-', com_code[u], '\'' , "]/a[2]")) #button elements 찾기.
      try(remDr$findElement(using = 'css selector', value = '#js-gdpr-consent-banner > div > a > svg > path')$clickElement()) #페이지에 들어갔을 때 아래쪽에 배너가 생성되서 이것을 삭제해야한다.
      
      Sys.sleep(0.3) #배너를 삭제한 후 바로 다른 버튼을 클릭하면 인식이 잘 안되는 경우가 있어 0.3초 텀을 뒀다.
      webElem$clickElement() #6개 이상의 댓글을 보기 위해 버튼 클릭
      
    }
    #버튼의 xpath링크를 가져와 webElem 변수에  버튼 elements를 저장했다. remDr$clickElement()함수를 이용해 해당 버튼을 클릭했다.
    
    #위 과정을 통해서 5개까지만 보이는 본문, 답변에 대한 댓글을 모두 보이게 할 수 있다. 
    
    frontPage <- remDr$getPageSource()
    #위 과정을 거친 페이지의 전체 소스를 가져온다.
    
    #extract title
    tmp_title <- tmp_question %>% html_nodes('h1') %>% html_nodes('a') %>% html_text
    #h1과 a node를 순서대로 상위 node로 갖는 것은 질문의 제목 밖에 없으므로, 위와 같은 방법으로 제목이 포함된 node를 따왔고
    #html_text 함수로 제목의 문자열만을 가져와 tmp_title 변수에 저장했다.
    
    
    #extract date
    tmp_date <- tmp_question %>% html_nodes('div.grid--cell.ws-nowrap.mr16.mb8') %>% html_nodes('time') %>% html_attr('datetime')
    #'div.grid--cell.ws-nowrap.mr16.mb8'를 갖는 node는 두 가지 이지만, 이중에서  time이라는 node가 작성 날짜의 상위 node였고, 그 중 datetime에 작성 날짜와 시간이 저장되어 있어 이 부분을 가져왔다. 
    
    #extract view
    tmp_view <- tmp_question %>% html_nodes('div.grid--cell.ws-nowrap.mb8') %>% html_attr('title')
    tmp_view2 <- gsub('Viewed ', '', tmp_view[length(tmp_view)]) %>%  gsub(' times', '', .) %>% gsub(',', '', .) %>% as.numeric()
    #date를 포함해 'div.grid--cell.ws-nowrap.mb8' node는 여러 개의 하위 node를 갖는데 여러 페이지를 비교해 본 결과 이 중에서 마지막 원소가 조회수를 포함하고 있다는 사실을 알았다.
    #따라서 tmp_view에 저장된 벡터의 마지막 원소에 대해서 문자열 슬라이싱을 통해 숫자 부분만 남긴 후 숫자열로 바꿨다.
    
    
    #extract main body
    tmp_body <- tmp_question %>% html_nodes('div.postcell.post-layout--right') %>% html_nodes('div.post-text') %>% html_text
    #div.post-text를 바로 가져오면, 질문에 대한 답변의 본문도 모두 포함하므로 질문의 본문만이 상위 노드로 갖는 'div.postcell.post-layout--right'에서부터 불러와 그 text를 가져옴으로써 본문의 내용만을 가져올 수 있었다.
    
    tmp_body <- gsub('\r\n', ' ', tmp_body) %>% str_trim
    #본문에서 불필요한 부분을 gsub, str_trim 함수로 삭제했다.
    
    #closed 된 글의 경우 이와 관련된 안내문이 본문에 포함되는데, 본문으로 포함시켜야 할 지 모르겠어서 삭제하지 않았습니다.
    
    #extract tags
    tmp_tag <- tmp_question %>% html_nodes('div.grid.ps-relative.d-block') %>% html_nodes('a[href^="/questions"]') %>% html_attr('title')
    #'div.grid.ps-relative.d-block' 노드에서 href="/questions"를 포함하는 노드가 tag의 내용을 갖고 있었고, 그중에서 title이라는 부분이 tag의 내용이 저장되어 있었다.
    
    tmp_tag <- substr(tmp_tag, 24, nchar(tmp_tag)-1)
    #substr을 이용해 불필요한 부분을 모두 삭제해 tag의 이름만을 벡터의 형태로 저장되게 했다.
    
    tmp_tag2 <- tmp_tag[1]
    if (length(tmp_tag) > 1) {
      for (m in c(2:length(tmp_tag)-1)) {
        tmp_tag2 <- paste(tmp_tag2, tmp_tag[m+1])
      }
    }  
    #tag가 여러 개 있을 때 한 개의 문자열로 합치기 위해 tmp_tag2 변수를 지정해 for문을 이용해 paste함수로 tmp_tag 변수의 모든 원소를 연결시켰다.
    
    #extract comments
    tmp_comments <- read_html(frontPage[[1]]) %>% html_nodes("div.question") %>% html_nodes("span.comment-copy") %>% html_text 
    #span의 comment-copy class에는 본문의 댓글 뿐 아니라 답변에 댓글도 포함되어 이를 제외하기 위해서 본문 댓글의 상위노드인 div.question에서부터 불러왔다.
    #6번째 댓글부터는 링크에 숨겨져있기 때문에 동적크롤링 과정을 거친 frontPage에서 자료를 가져와 모든 댓글을 확인할 수 있도록 했다.
    
    
    tmp_comments2 <- tmp_comments[1]
    if (length(tmp_comments) > 2 ) {
      for (m in c(2:length(tmp_comments)-1)) {
        tmp_comments2 <- paste(tmp_comments2, tmp_comments[m+1], sep = 'OOO')
      }
    }
    #tag와 같은 방식으로, for문과 paste함수를 이용하되 sep = 'OOO'로 지정해 comments 사이를 구분하도록 했다.
    
    #extract answers
    tmp_answer <- tmp_question %>% html_nodes('div.answer') %>% html_nodes('div.post-text') %>% html_text
    #질문의 본문을 가져올 때와 마찬가지로 답변의 본문만을 가져오기 위해 div node에서 class에 answer이 들어간 nodes를 먼저 가져온 후 html_text함수로 text만을 가져왔다.
    
    
    if (length(tmp_answer) != 0) { # 답변이 하나도 없을 경우에 for문에서 오류가 생기기 때문에 if문으로 answer이 있는 경우와 없는 경우를 나눠 없는 경우에는 하나의 행이 만들어 지도록 따로 설정했다.
      for (k in c(1:length(tmp_answer))) { #각각의 답변 별로 comments를 저장하기 위해 답변의 개수만큼 반복하도록 for문을 사용했다.
        #extract comments of the answer.
        answer_num <- read_html(frontPage[[1]]) %>%  html_nodes('div.answer') %>% html_attr('id') %>% substr(.,8, nchar(.))
        tmp_comments_a <- read_html(frontPage[[1]]) %>% html_nodes('div.post-layout--right') %>% html_nodes(paste0("div[id^=\'comments-", answer_num[k], "\']")) %>% html_nodes('span.comment-copy') %>% html_text
        #답변 별로 그 comments를 따오기 위한 방법으로, 답변 별로 특정한 코드를 갖고 있다는 사실을 알게 되었고, 이는 div.answer 노드에 id 부분에 저장되어 있었다.
        # 이부분을 substr로 숫자 부분만 따와 answer_num 변수에 지정해 벡터형태로 저장되도록 했고, comments들의 상위노드 'div.post-layout--right' 아래의 {div.id='comments-'답변의 번호'} 형태로 상위노드를 각각 가진다는 알았다.
        #그래서 answer_num에 k번째 원소를 가져와 paste0 함수로 노드의 이름을 만들어 답변 각각에 대한 comments들을 가져올 수 있었다.
        #본문의 댓글과 마찬가지로 frontPage로부터 가져왔다.
        
        tmp_comments_a2 <- tmp_comments_a[1]
        if (length(tmp_comments_a) > 2) {
          for (m in c(2:length(tmp_comments_a)-1)) {
            tmp_comments_a2 <- paste(tmp_comments_a2, tmp_comments_a[m+1], sep = 'OOO')
          }
        }
        #본문의 댓글을 연결시키는 것과 같은 방법으로 답변의 댓글을 연결시켰다.
        
        
        #store the result to the dataframe
        Stackoverflow_QA[cnt,1] <- tmp_title
        Stackoverflow_QA[cnt,2] <- tmp_date
        Stackoverflow_QA[cnt,3] <- tmp_view2
        Stackoverflow_QA[cnt,4] <- tmp_body
        Stackoverflow_QA[cnt,5] <- tmp_tag2
        Stackoverflow_QA[cnt,6] <- tmp_comments2
        Stackoverflow_QA[cnt,7] <- tmp_answer[k]
        Stackoverflow_QA[cnt,8] <- tmp_comments_a2
        
        cnt <- cnt + 1
      }
    }
    else {
      Stackoverflow_QA[cnt,1] <- tmp_title
      Stackoverflow_QA[cnt,2] <- tmp_date
      Stackoverflow_QA[cnt,3] <- tmp_view2
      Stackoverflow_QA[cnt,4] <- tmp_body
      Stackoverflow_QA[cnt,5] <- tmp_tag2
      Stackoverflow_QA[cnt,6] <- tmp_comments2
      Stackoverflow_QA[cnt,7] <- NA
      Stackoverflow_QA[cnt,8] <- NA
      #답변이 하나도 없는 경우
      cnt <- cnt + 1
    } 
        
  }
  Sys.sleep(1)
}

end <- proc.time()
end - start

names(Stackoverflow_QA) <- c('Title', 'Date', 'Views', 'Question', 'Tags', 'Q_comments', 'Answer', 'A_Comments')

save(Stackoverflow_QA, file = "Stackoverflow_QA.RData")
write.csv(Stackoverflow_QA , file = "Stackoverflow_QA.csv")

Stackoverflow_QA <- read.csv('Stackoverflow_QA.csv')


