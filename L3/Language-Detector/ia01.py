from sklearn import svm
from os import listdir
from os.path import isfile, join
from string import ascii_lowercase
import os
from sklearn.externals import joblib # To save the ia
def calculate(path):  # To calculate the frequence of each character in the document
    l=list(open(path,"r").readlines())
    s=[]
    i=0
    for c in ascii_lowercase:
        s[i]=l.count[c]
        i=i+1
    return s 

def fitDirectory(mypath): # So the IA can learn from a directory
    X=[]
    Y=[]
    if os.path.exists(os.getcwd()+'dec'):
        detector= joblib.load('detector.pkl')
    else:
        detector=svm.SVC()
        f=open("dec",'w+')
    onlyfiles = [f for f in listdir(mypath) if isfile(join(mypath, f))]
    for f in onlyfiles:
        Y.append(calculate(f))
        if(f.startswith("fr")):
            X.append("fr")
        if(f.startswith("en")):
            X.append("en")
        if(f.startswith("es")):
            X.append("es")
    detector.fit(X,Y)
    joblib.dump(detector, 'detector.pkl')
def guess(path):
    detector= joblib.load('detector.pkl')
    f=open(path,"r")
    s=list(f.readlines())
    return detector.predict(s)
print("\n\n")
decide=1
while decide!=0:
    decide=int(input(" What do you want ? \n1 - Fit a directory\n2 - Predict\n0 - Quit\n"))
    if decide==1:
        path=input(" Give the full-path to the directory : ")
        fitDirectory(path)
        input("Done ! \n")
    if decide==2:
        path=input(" Give the full-path to the file")
        input("The file is in : "+guess(path)+"\nPress ENTER to continue..")

