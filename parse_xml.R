library(xml2)
x = read_xml('WAS_Results_scan_18633864.xml')
results = xml_children(x)[[3]]
re= as_list(results)
vl= re[["VULN_LIST"]]