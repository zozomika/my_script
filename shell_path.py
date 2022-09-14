#!/common/appl/python/python-2.7.13-64bit/bin/python                                                                      
import sys, time, datetime
import re, os, glob, fnmatch

current_path = os.getcwd()
#test_dir = '/common/work/haulamhuynh/ECO014_CDL_GDS_compararison/fr_LMS_gds_171123_0929.txt'
#print current_path
#for i in glob.glob (test_dir+'/*.txt'):
#        print i
home_path = os.path.expanduser("~") + "/"
myscriptdir_path = home_path + "script/"
if  __name__ == "__main__":
  if os.path.isdir(myscriptdir_path):
    print myscriptdir_path
