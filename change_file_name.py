#! /usr/bin/env python

#    Change name of pictures (*.JPG, *.jpg)

from PIL import Image
import datetime
import glob
import os

files = glob.glob('*')

for filename in files:
    if "2017" in filename:
        continue
    name, ext = os.path.splitext(filename) # return 'name' & 'ext' ('name' + 'ext'= filename)
    if ext == ".JPG" or ext == ".jpg":
        print(filename)
        img = Image.open(filename)
        if img._getexif():
            t = 0
            option = ""
            for key, value in img._getexif().items():
                if key == 36868:
                    t = datetime.datetime.strptime(value, '%Y:%m:%d %H:%M:%S')
                if key == 271:
                    option = value.split()[0]
            if t == 0:
                print("cannot get time")
                continue
            newname = ("%04d%02d%02d_%02d%02d%02d_%s%s"
                       % (t.year, t.month, t.day, t.hour, t.minute, t.second,
                          option, ext))
            print(newname)
            if os.path.exists(newname):
                print("### cannot rename to %s" % newname)
            else:
                os.rename(filename, newname)
        else:
            print("### skip rename for %s" % filename)
