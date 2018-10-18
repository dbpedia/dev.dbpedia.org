---
layout: subpage
title: Infobox Provenance Tracking
permalink: Other/Infobox Properties Tracking
parent: Other
---

a tool for tracking the changes of values in infoboxes from Wikipedia

# USAGE

After compiling, the .jar can be used with the following parameters  

 -earlier, -e  
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Earliest timestamp (Date in yyyy-MM-dd) to extract  
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Default: 2001-01-02  
 -help, -h  
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Print help information and exit  
 -language, -lang  
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Dump Language  
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Default: en  
 -lastchange, -last  
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Only last change to an existing triple will be saved  
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Default false  
 -later, -l  
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Last timestamp(Date in yyyy-MM-dd) to extract  
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Default: Current date  
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;This parameter is also a possibility to trim the number of loaded revisions.
  In case it is set to 2015-01-01. The program
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;loads all revisions from 2001-01-02 until 2015-01-01 excluding. 
  The Wikipedia-Api doesn't support a trim of the lower 
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;boarder.  
 -name, -a  
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Name of the Article  
 -path  
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Path to the dump containing directory    
 -threads, -t  
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Number of threads to run  
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Default: 1  
 -threadsF, -tf  
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Number of parallel processed files   
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Default: 1  
  
  e.g.:  
  -name miele -last  
  -path /src/test/resources/inputde -lang de -earlier 2014-10-09 -later 2016-12-30
