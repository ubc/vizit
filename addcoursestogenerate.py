import csv  
import io 
import requests 

headers={}
headers["User-Agent"]= "Mozilla/5.0 (Windows NT 6.2; WOW64; rv:22.0) Gecko/20100101 Firefox/22.0"
headers["DNT"]= "1"
headers["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
headers["Accept-Encoding"] = "deflate"
headers["Accept-Language"]= "en-US,en;q=0.5"

file_id="10MIW7cEc1VFLF-TqA8CeGKa6wGlEdFWYwExZD_0wl1E"
url = "https://docs.google.com/spreadsheets/d/{0}/export?format=csv".format(file_id)
r = requests.get(url)
data = []

stream = io.StringIO( r.text, newline=None)
reader = csv.reader(stream, dialect=csv.excel)

with open("/root/vizit/courses.txt", "w") as cw:
    for row in reader:
        for col in row:
            data.append(col)
        cw.write(col + '\n')            
