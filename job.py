#!/usr/bin/python
# coding:utf-8

import hashlib
import os, sys
import zipfile

print("\n ======== Start hash resource ======== \n")
if (os.path.exists("./build/static-meeting-manager")):
    os.remove("./build/static-meeting-manager")

if (os.path.exists("./build/static-meeting-manager.zip")):
    os.remove("./build/static-meeting-manager.zip")   



#计算md5值
def CalcMD5(filepath):
    with open(filepath,'rb') as f:
        md5obj = hashlib.md5()
        md5obj.update(f.read())
        hash = md5obj.hexdigest()
        return hash

#给文件名加hash值
def createHashName(oldFileName):
    hash = CalcMD5(oldFileName)
    if (oldFileName.endswith('dart.js')):
            return oldFileName.replace('dart.js',hash+'.dart.js')
    if (oldFileName.endswith('part.js')):
            return oldFileName.replace('part.js',hash+'.part.js')


# 查看当前工作目录
currentPath = os.getcwd()

# 修改当前工作目录
path = "./build/web"
os.chdir( path )
webPath = os.getcwd()

print("找到.js结尾的文件并拼接hash")
jsFileList = []
jsFileHashMap = {}
pathList = os.listdir(webPath)
for path in pathList:
    if (path.endswith("dart.js") | path.endswith("part.js")):
        jsFileList.append(path)
        jsFileHashMap[path] = createHashName(path)

print(jsFileHashMap)

#检查文件，替换文件中的一些文件引用
def checkFile(file):
    with open(file, "r") as f1,open("%s.bak" % file, "w") as f2:
        for line in f1:
            for old_str in jsFileList:
                if old_str in line:
                    if old_str == 'main.dart.js':
                        if 'part.js' in line:
                            continue
                    new_str = jsFileHashMap[old_str]
                    line = line.replace(old_str, new_str)
                    lastLine = line
            f2.write(line)
        os.remove(file)
        os.rename("%s.bak" % file, file)

print("整理main.dart.js")
mainDartJs = 'main.dart.js'
checkFile(mainDartJs)

print("整理flutter_service_worker.js")
flutterServiceWorkerJs = 'flutter_service_worker.js'
checkFile(flutterServiceWorkerJs)

print("整理index.html")
indexHtml = 'index.html'
checkFile(indexHtml)

print("将part.js的引用手动添加到index.html中")
partJsFile = []
for jsFile in jsFileList:
    if (jsFile.endswith('part.js')):
        partJsFile.append(jsFileHashMap[jsFile])

with open(indexHtml, "r") as f1,open("%s.bak" % indexHtml, "w") as f2:
        for line in f1:
            if "js/plugin.js" in line :
                f2.write(line)
                for partFile in partJsFile:
                    f2.write("<script src=\"%s\" type=\"text/javascript\"></script>\n" % partFile)
                continue
            f2.write(line)
        os.remove(indexHtml)
        os.rename("%s.bak" % indexHtml, indexHtml)

print("更改文件名")
for jsFile in jsFileList :
    newFile = jsFileHashMap[jsFile]
    os.rename(jsFile,newFile)

print("返回上层文件夹，更改web文件为static-meeting-manager并压缩")
managerFile = "static-meeting-manager"
os.chdir('..')
os.rename('web',managerFile)

zipFile = "static-meeting-manager.zip"
if (os.path.exists(zipFile)):
    os.remove(zipFile)

zip = zipfile.ZipFile(zipFile,"w")
for path,dirnames,filenames in os.walk(managerFile):
    zip.write(path)
    for filename in filenames:
        zip.write(os.path.join(path,filename))
zip.close()

print("\n========= 操作完成 ===========\n")


