module namespace gv = "http://kitwallace.co.uk/ns/graphviz";
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
declare variable $gv:conf := doc(concat($gv:base,"conf.xml"))/conf;
declare variable $gv:dotml2dot := doc(concat($gv:base,$gv:conf/dotml2dot));

declare function gv:dot-error($lines) {
   if (contains($lines[1],"Error"))
   then concat($lines[1],$lines[2])
   else ()   
};

declare function gv:tidy-svg($lines) {
(: ignore lines up to <svg :)
  if (empty($lines))
  then ()
  else if (starts-with($lines[1],"<svg"))
  then $lines
  else gv:tidy-svg(subsequence($lines,2))
};

declare function gv:dot-to-svg($graph) {
  let $graph := normalize-space($graph)
  return
    if ($graph ne "")
    then 
      let $options := 
      <options>
         <workingDir>{$gv:conf/directory/string()}</workingDir>
         <stdin><line>{$graph}</line></stdin>
      </options>
     let $result := process:execute(($gv:conf/dot-path,"-Tsvg"), $options)
     let $lines := $result/stdout/line
     let $error := gv:dot-error($lines)
     return 
       if (empty($error))
       then
           let $string := string-join(gv:tidy-svg($lines),"")  
           return util:parse($string)
       else <error>{$error}</error>
    else ()
};

declare function gv:dotml-to-dot($dotml) {
   transform:transform ($dotml, $gv:dotml2dot,())
};


