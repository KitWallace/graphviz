##eXist db Graphviz interface ##

This project provides an interface to the graphviz suite for eXist-db version 2.0. http://exist-db.org 

collection /db/apps/graphviz

The interface is provided by the module lib/graphviz.xqm

The script xquery/index.xq provides a browser for a set of example dot and dotml files taken from 
Andy Bunce's BASEX project https://github.com/apb2006/graphxq 

The script xquery/managers.xq generates a clickable graph from a database

dotML is transformed to dot via XSL from http://martin-loetzsch.de/DOTML/ 

##Prerequites##
- graphviz has been installed - only dot is used
- exist 2.0 

##Version 1 limitations##
- Only SVG is generated
