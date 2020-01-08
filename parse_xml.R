library(xml2)
library(rgeolocate)

#llista de ips random per fer veure que son localitzacions reals
ip = list("156.135.193.17","198.132.113.161","132.168.230.105","182.123.181.178","43.208.3.93","81.114.207.245","96.26.143.224","78.206.15.82","18.198.188.144","238.254.60.114","200.47.81.174","242.15.189.110","250.90.130.175","47.129.43.178","235.209.114.116","113.254.100.209","17.104.222.193","241.178.62.195","121.24.2.27","34.153.222.153","254.33.6.168","4.126.110.38","113.236.246.250","90.242.200.183","185.202.247.218","26.14.165.220","244.216.21.87","170.9.1.147","41.23.95.221","160.156.177.184","17.36.112.142","32.195.147.200","13.37.209.165","100.101.76.90","204.113.77.84","233.146.150.36","156.196.167.205","107.5.118.145","96.212.139.76","27.4.47.39","147.117.251.64","48.21.202.98","174.167.109.139","176.14.129.233","32.145.225.136","11.186.243.122","208.17.175.33","101.168.61.148","167.44.63.160","110.38.142.66")

x = read_xml('WAS_Results_scan_18924898.xml')
results = xml_children(x)[[3]]
re= as_list(results)

# list containing the vul list section of the xml. Each entry is a different vuln
vl= re[["VULN_LIST"]]


#de moment abandonem params i findings que son bastantes més iteracions

#Parse the XML to generate a data frame
DF <- data.frame("group"="", "qid"="", "title"="", "host"="", "port"="", "uri"="",  "authenticated"="", "form_entry_point"="", stringsAsFactors=FALSE)#"params"="", stringsAsFactors=FALSE) #findings=rep("",N), stringsAsFactors=FALSE)


for(i in 1:length(vl)){

  
  for(j in 1:length(vl[[i]]$VULN_INSTANCES)){
    
    
    DF = rbind(DF,list(vl[[i]]$GROUP, vl[[i]]$QID, vl[[i]]$TITLE, vl[[i]]$VULN_INSTANCE[[j]]$HOST, vl[[i]]$VULN_INSTANCE[[j]]$PORT, vl[[i]]$VULN_INSTANCE[[j]]$URI, vl[[i]]$VULN_INSTANCE[[j]]$AUTHENTICATED, vl[[i]]$VULN_INSTANCE[[j]]$FORM_ENTRY_POINT))
    
  }
  
}
DF <- DF[-1,]

#Generate another data frame from the info of the hosts
locations <- data.frame("status"="", "country"="", "countryCode"="", "region"="", "regionName"="", "city"="",  "zip"="", "lat"="", "lon"="", "timezone"="", "isp"="", "org"="", "as"="", "query"="", stringsAsFactors=FALSE)


for (i in 1:length(ip)){
  
  list = ip_api(ip[[i]], FALSE)[[1]]
  if (list[[1]] != "Error"){
    locations = rbind(locations,list)
  }
  
}


# for (i in 1:length(DF$host)){
#   
#   
#   list = ip_api(DF$host[[i]], FALSE)
#   if (list[[1]] != "Error"){
#     locations = rbind(locations,list[[1]])
#   }
#   
#   
#}

locations = locations[-1,]



