#!/bin/csh -f

ls -lrt | tail -1 | awk '{print $NF} ' | xargs vi
