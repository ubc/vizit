#!/usr/bin/env python
import fileinput
with open('directory.txt') as d:
    directory = d.readlines()
with open('existingmappings.txt') as e:
    mappings = e.readlines()
with open('tonotadd.txt') as n:
    no = n.readlines()       
with open("existingmappings.txt", "ab") as em:
    for name in directory:
        if 'sandbox' not in name.lower() and name not in no:
            if name not in mappings:
                    em.write(name)
                    cfgLine = name.replace('yourinstitutionx-', 'yourinstitutionx/')                    
                    cfgLine = cfgLine.replace('-course-prod-analytics.xml.tar.gz', '')
                    cfgLine = cfgLine.replace('-course-prod-edge-analytics.xml.tar.gz', '')
                    cfgLine = cfgLine.replace('-20', '/20')
                    cfgLine = cfgLine.replace('-1T', '/1T')
                    cfgLine = cfgLine.replace('-2T', '/2T')
                    cfgLine = cfgLine.replace('-3T', '/3T')             
                    cfgLine = cfgLine.replace('\n', '') 
                    for line in fileinput.input("../yourdirectory/edx2bigquery_config.py", inplace=True):
                        if line == 'course_id_list = [\n':
                            print "%s%s" % (line, "\n    '" + cfgLine + "',"),     
                        else:
                            print "%s" % (line), 
                    print(cfgLine)     
