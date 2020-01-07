library(xml2)
x = read_xml('WAS_Results_scan_18633864.xml')
results = xml_children(x)[[3]]
re= as_list(results)

# list containing the vul list section of the xml. Each entry is a different vuln
vl= re[["VULN_LIST"]]


# list of ports
for(i in vl){print(i[[4]][[1]][[2]])}

for(i in 1:length(vl)){
  port[i]<-strtoi(x = i[[4]][[1]][[2]], base = 0L)
}

# title concat for wardcloud generation
