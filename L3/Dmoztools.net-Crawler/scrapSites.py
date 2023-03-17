url='http://dmoztools.net'
from bs4 import BeautifulSoup
import urllib3
import requests
from urllib.parse import urljoin
from selenium import webdriver
from selenium.webdriver.firefox.options import Options
from bs4.element import Comment
import urllib.request
import threading
from threading import Thread
import regex as re
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities

regex = re.compile(
        r'^(?:http|ftp)s?://' # http:// or https://
        r'(?:(?:[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?\.)+(?:[A-Z]{2,6}\.?|[A-Z0-9-]{2,}\.?)|' #domain...
        r'localhost|' #localhost...
        r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' # ...or ip
        r'(?::\d+)?' # optional port
        r'(?:/?|[/?]\S+)$', re.IGNORECASE)


def getLinks(page,f,browser):
    print('page : '+str(page))
    
    browser.get(page)
    html=browser.page_source

    if True:
        soup=BeautifulSoup(html,'html.parser')
        for div in soup.find_all('section',class_='see-also'):
        	div.decompose()
        for div in soup.find_all('section',class_='alt-language'):
        	div.decompose()
        for div in soup.find_all('i',class_='fa-share'):
        	div.parent.parent.decompose()
        links=soup.find_all('div',class_='cat-item')
        links2=[]
        hrefs=[]
        for j in links:
        	x=j.find('a')
        	if x!=None:
                	links2.append(x)
        for r in links2:
        	hrefs.append(r.get('href'))
        sites=soup.find_all('div',class_='title-and-desc')
        sites2=[]
        sites3=[]
        for k in sites:
            sites2.append(k.find('a'))
        for l in sites2:
            if re.match(regex, l.get('href')) is not None:
                sites3.append(l.get('href'))
                f.write(l.get('href')+'#^$')
        for i in links2:
                try:
        	        getLinks(urljoin(url,i.get('href')),f,browser)
                except:
                        print('Error. \n')


def getContent(page):
    page=requests.get(page)
    if page.status_code==200:
    	soup=BeautifulSoup(page.content,'html.parser')
    return soup.get_text()





def tag_visible(element):
    if element.parent.name in ['style', 'script', 'head', 'title', 'meta', '[document]']:
    	return False
    if isinstance(element, Comment):
        return False
    return True


def text_from_html(body):
    global web
    web.get(str(body))
    html=web.page_source
    soup = BeautifulSoup(html, 'html.parser')
    texts = soup.findAll(text=True)
    visible_texts = filter(tag_visible, texts)  
    return u" ".join(t.strip() for t in visible_texts)



options = Options()
browsers={}
firefox_capabilities = DesiredCapabilities.FIREFOX
firefox_capabilities['marionette'] = True
options.add_argument("--headless")
web=webdriver.Firefox(firefox_options=options,capabilities=firefox_capabilities)
categories=['Kids_and_Teens','News','Science', 'Region', 'Society']
# Done : Arts , Games, Health, Business , Recreation , Sports, Computers, Home, Reference, Shopping


#browser=webdriver.Firefox(firefox_options=options,capabilities=firefox_capabilities)
for i in categories:
#    browsers[i] = webdriver.Firefox(firefox_options=options,capabilities=firefox_capabilities)
        f=open('SitesName/'+str(i),'w')
#    f2=open('DataSets/SitesContents/'+str(i)+'new','w+')
#    Thread(target = getLinks,args=(url+'/'+i,f,f2,browsers[i])).start()
        getLinks(url+'/'+i,f,web)
        f2=open('done','w+')
        f2.write(str(i)+'Sites#')
        f2.close()
