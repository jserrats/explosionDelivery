library(xml2)
x = read_xml('WAS_Results_scan_18633864.xml')
results = xml_children(x)[[3]]
re= as_list(results)

# list containing the vul list section of the xml. Each entry is a different vuln
vl= re[["VULN_LIST"]]

N <- length(vl)

DF <- data.frame(group=rep(NA, N), qid=rep("", N), title=rep("",N), host=rep("",N), port=rep("",N), uri=rep("",N),  authenticated=rep("",N), form_entry_point=rep("",N), params=rep("",N), findings=rep("",N), stringsAsFactors=FALSE)
View(DF)

j=0;
for(i in 1:length(vl)){
  DF[i,] <- list(vl[[i]]$GROUP, vl[[i]]$QID, vl[[i]]$TITLE, vl[[i]][[1]]$VULN_INSTANCE$HOST, vl[[i]]$VULN_INSTANCE$VULN_INSTANCE$PORT, vl[[i]]$VULN_INSTANCE$VULN_INSTANCE$URI, vl[[i]]$VULN_INSTANCE$VULN_INSTANCE$AUTHENTICATED, vl[[i]]$VULN_INSTANCE$VULN_INSTANCE$FORM_ENTRY_POINT, vl[[i]]$VULN_INSTANCE$VULN_INSTANCE$PARAMS, vl[[i]]$VULN_INSTANCE$VULN_INSTANCE$FINDINGS )
}