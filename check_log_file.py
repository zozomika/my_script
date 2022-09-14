#!/usr/bin/python
# Script Name           : check_log_file.py
# Author                : HauHuynh
# Created               :
# Last Modified         : 
# Version               : 1.0

# Modifications         : 
# Description           : This will list all the files in the given directory, it will also go through all the subdirectories as well

import os, fnmatch                                                  # Load the library module                                                       

logdir  = os.getenv("logs")                                          # Set the variable logdir by getting the value from the OS environment variable logs
#logfile = 'script_list.log'                                          # Set the variable logfile
path    = os.getcwd()                                                # Set the varable path by getting the value from the OS environment variable scripts - 1.2
logfilename = []
#path = (raw_input("Enter dir: "))                                   # Ask the user for the directory to scan
#logfilename = os.path.join(logdir, logfile)                          # Set the variable logfilename by joining logdir and logfile together
#log = open(logfilename, 'w')                                         # Set the variable log and open the logfile for writing

for dirpath, dirname, filenames in os.walk(path):                    # Go through the directories and the subdirectories
  for filename in filenames:
    if fnmatch.fnmatch(filename, '*.rep'):                           # Get all the filenames
      logfilename.append(os.path.join(dirpath, filename)) 
      #log.write(os.path.join(dirpath, filename)+'\n')                  # Write the full path out to the logfile
      for file in logfilename:
        print "Your logfile %s has been created" % file              # Small message informing the user the file has been created
      logfilename = []
