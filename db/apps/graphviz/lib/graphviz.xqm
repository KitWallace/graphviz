module namespace gv = "http://kitwallace.co.uk/ns/qraphviz";
(:~
: Module for working with graphviz
:    prerequisites
:         graphviz package installed 
:    requires dba login
: @version 1.0
: @author Chris Wallace <kit.wallace@gmail.org>
: @date 2013-02-25
  
:)

import module namespace process="http://exist-db.org/xquery/process" at "java:org.exist.xquery.modules.process.ProcessModule";

declare namespace svg = "http://www.w3.org/2000/svg";
declare namespace dotml ="http://www.martin-loetzsch.de/DOTML";
declare variable $gv:base := "/db/apps/graphviz/";
declare variable $gv:directory := "";  (: directory in which graphviz wil be executed :)
declare variable $gv:dotcommand := "dot";  (: for unix - need dot.exe for windows :)
declare variable $gv:dotml2dot := doc(concat($gv:base,"xsl/dotml2dot.xsl"));

declare function gv:tidy-svg($lines) {
(: ignore lines up to <svg :)
  if (empty($lines))
  then ()
  else if (starts-with($lines[1],"<svg")
  then $lines
  else gv:tidy-svg(subsequence(lines,2)
};

declare function gv:dot-to-svg($graph) {
  let $graph := normalize-space($graph)
  return
    if ($graph ne "")
    then 
      let $options := 
      <options>
         <workingDir>{$gv:directory}</workingDir>
         <stdin><line>{$graph}</line></stdin>
      </options>
     let $result := process:execute(($gv:dotcommand,"-Tsvg"), $options)
     let $string := string-join(gv:tidy-svg($result/stdout/line),"")  
     return util:parse($string)
    else ()
};

declare function gv:dotml-to-dot($dotml) {
   transform:transform ($dotml, $gv:dotml2dot,())
};


