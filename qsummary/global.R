library(tm)
library(wordcloud)
library(memoise)
library(xml2)
library(DT)
library(shiny)
library(leaflet)
library(dplyr)
library(leaflet.extras)
library(rgeolocate)


#List of random IPs to show the map working correctly
ip = list("156.135.193.17","198.132.113.161","132.168.230.105","182.123.181.178","43.208.3.93","81.114.207.245","96.26.143.224","78.206.15.82","18.198.188.144","238.254.60.114","200.47.81.174","242.15.189.110","250.90.130.175","47.129.43.178","235.209.114.116","113.254.100.209","17.104.222.193","241.178.62.195","121.24.2.27","34.153.222.153","254.33.6.168","4.126.110.38","113.236.246.250","90.242.200.183","185.202.247.218","26.14.165.220","244.216.21.87","170.9.1.147","41.23.95.221","160.156.177.184","17.36.112.142","32.195.147.200","13.37.209.165","100.101.76.90","204.113.77.84","233.146.150.36","156.196.167.205","107.5.118.145","96.212.139.76","27.4.47.39","147.117.251.64","48.21.202.98","174.167.109.139","176.14.129.233","32.145.225.136","11.186.243.122","208.17.175.33","101.168.61.148","167.44.63.160","110.38.142.66")
scans = list("WASscan1.xml","WASscan2.xml","WASscan3.xml","WASscan4.xml")
DF <- data.frame("group"="", "qid"="", "title"="", "host"="", "port"="", "uri"="",  "authenticated"="", "form_entry_point"="", stringsAsFactors=FALSE)

for (z in 1:length(scans)){

  x = read_xml(scans[[z]])
  results = xml_children(x)[[3]]
  re= as_list(results)
  
  # list containing the vul list section of the xml. Each entry is a different vuln
  vl= re[["VULN_LIST"]]
  
  
  #Parse the XML to generate a data frame 
  
  for(i in 1:length(vl)){
    
    
    for(j in 1:length(vl[[i]]$VULN_INSTANCES)){
      
      
      DF = rbind(DF,list(vl[[i]]$GROUP, vl[[i]]$QID, vl[[i]]$TITLE, vl[[i]]$VULN_INSTANCE[[j]]$HOST, vl[[i]]$VULN_INSTANCE[[j]]$PORT, vl[[i]]$VULN_INSTANCE[[j]]$URI, vl[[i]]$VULN_INSTANCE[[j]]$AUTHENTICATED, vl[[i]]$VULN_INSTANCE[[j]]$FORM_ENTRY_POINT))
      
    }
    
  }
}

DF <- DF[-1,]

#Generate another data frame from the info of the hosts

#There's two different data frames, one for the real XML and one for random IPs
#The real date uses ip_api to get the data from a web API. If too many petitions to the server are done it doesn't works so we use ip2location with the DB ip2locations.BIN for the fake IPs


#locationsIP <- data.frame("status"="", "country"="", "countryCode"="", "region"="", "regionName"="", "city"="",  "zip"="", "lat"="", "lon"="", "timezone"="", "isp"="", "org"="", "as"="", "query"="", stringsAsFactors=FALSE)
locationsQ <- data.frame("status"="", "country"="", "countryCode"="", "region"="", "regionName"="", "city"="",  "zip"="", "lat"="", "lon"="", "timezone"="", "isp"="", "org"="", "as"="", "query"="", stringsAsFactors=FALSE)
locationsIP <- data.frame("country_code"="", "country_name"="", "lat"="", "long"="", stringsAsFactors = FALSE)
#locationsQ <- data.frame("country_code"="", "country_name"="", "lat"="", "long"="", stringsAsFactors = FALSE)

for (i in 1:length(ip)){
  
  list = ip2location(ip[[i]],"ip2location.BIN", fields = c ("country_code","country_name","lat","long"))
  locationsIP = rbind(locationsIP,list)
  
}


for (i in 1:length(DF$host)){
  
  list = ip_api(DF$host[[i]], FALSE)
  if (list[[1]][[1]] != "Error"){
    
    locationsQ = rbind(locationsQ,list[[1]])
    #print("Q Added")
  }
  else{
    print("Q Not Added")
  }
  
  
}

locationsQ = locationsQ[-1,]
locationsIP = locationsIP[-1,]


# Using "memoise" to automatically cache the results
getTermMatrix <- memoise(function(stuff) {
  
  text <- paste(DF[,3], collapse = " ")
  
  myCorpus = Corpus(VectorSource(text))
  myCorpus = tm_map(myCorpus, content_transformer(tolower))
  myCorpus = tm_map(myCorpus, removePunctuation)
  myCorpus = tm_map(myCorpus, removeNumbers)
  myCorpus = tm_map(myCorpus, removeWords,
                    c(stopwords("SMART"), "set", "and", "but"))
  
  myDTM = TermDocumentMatrix(myCorpus,
                             control = list(minWordLength = 1))
  
  m = as.matrix(myDTM)
  
  sort(rowSums(m), decreasing = TRUE)
})