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
declare namespace dotml = "http://www.martin-loetzsch.de/DOTML";

declare variable $gv:base := "/db/apps/graphviz/";
declare variable $gv:dotml2dot := doc(concat($gv:base,"xsl/dotml2dot.xsl"));  
declare function gv:dot-to-svg($graph) {
   let $options := 
      <options>
         <stdin><line>{string($graph)}</line></stdin>
      </options>
   let $result := process:execute(("dot","-Tsvg"), $options)
   let $string := string-join($result/stdout/line[position() > 8],"")  (: lose the fetch of the dtd :)
   return util:parse($string)
};

declare function gv:dotml-to-dot($dotml) {
   transform:transform ($dotml, $gv:dotml2dot,())
};


