from newspaper import Article
import atexit
from urllib.parse import urljoin
from selenium import webdriver
from selenium.webdriver.firefox.options import Options
from bs4.element import Comment
import urllib.request
from bs4 import BeautifulSoup
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
from threading import Thread





def scrappy(body,web):
    web.get(str(body))
    html=web.page_source
    soup = BeautifulSoup(html, 'html.parser')
    texts = soup.findAll(text=True)
    visible_texts = filter(tag_visible, texts)  
    return u" ".join(t.strip() for t in visible_texts)


def tag_visible(element):
    if element.parent.name in ['style', 'script', 'head', 'title', 'meta', '[document]']:
    	return False
    if isinstance(element, Comment):
        return False
    return True


options = Options()
browsers={}
firefox_capabilities = DesiredCapabilities.FIREFOX
firefox_capabilities['marionette'] = True
options.add_argument("--headless")




def scrap(link):
	article=Article(link)
	article.download()
	article.parse()
	return article.text

categories = ['Society','Health','Business','Recreation','Sports','Computers','Home','Reference','Shopping','Kids_and_Teens','News','Science','Games','Arts','Regional']
for m in categories:
	browsers[str(m)]=webdriver.Firefox(firefox_options=options,capabilities=firefox_capabilities)
max=0
total=0
files={}
lis={}
problems={}
for i in categories:
	f=open('SitesName/'+str(i),'r')
	tex=f.read()
	lis[str(i)]=tex.split('#^$')
	total=total+len(lis[str(i)])
	if len(lis[str(i)])>max:
		max=len(lis)
	f.close()
	files[str(i)]=open('SitesContents/'+str(i),'w')
	problems[str(i)]=open('SitesNotScrapped/'+str(i),'w')
	print('Category : '+str(i)+ ' Number of samples : '+str(len(lis[str(i)])))

i=0
succ=0
prob=0
def exploit(x):
	global succ,prob,i
	for d in range(0,len(lis[str(x)])):
		i=i+1
		try:
			files[str(x)].write(str(scrap(str(lis[str(x)][d])))+'#^$')
			print('Category :'+str(x)+'\tSuccess : '+str(i))
			succ=succ+1
		except:
			problems[str(x)].write(str(lis[str(x)][d])+'#^$')
			print('Category :'+str(x)+'\tProblem : '+str(i))
			prob=prob+1
		print('Remaining : '+str(total-i))
	print('\n\nCategory : '+str(x)+' FINISHED\n\n')

for r in categories:
	Thread(target=exploit, args=(str(r),)).start()

def exit_handler():
	global files, problems, succ, prob, total
	files[str(r)].close()
	problems[str(r)].close()
	print('Total : '+str(total))
	print('Not used : '+str(total-(prob+succ)))
	print(' Success : '+str(succ))
	print(' Failed : '+str(prob))
	print(' Percentage : '+str((succ/(prob+succ))*100)+'%')

atexit.register(exit_handler)
