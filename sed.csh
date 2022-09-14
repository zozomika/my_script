#!/bin/csh
sed -i 's/File//g;s/MINvac\.pdb//g' test.txt
sed -i -e 's/File//g' -e 's/MINvac.pdb//g' test.txt
