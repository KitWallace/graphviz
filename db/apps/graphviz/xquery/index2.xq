(: view samples :)
import module namespace gv = "http://kitwallace.co.uk/ns/qraphviz" at "../lib/graphviz.xqm";
declare namespace dotml = "http://www.martin-loetzsch.de/DOTML";
declare namespace h = "http://www.w3.org/1999/xhtml";

declare variable $sampledir := concat($gv:base,"samples/");
declare variable $index := concat($sampledir,"library.xml");

declare option exist:serialize "method=xhtml media-type=application/xhtml+xml";

let $login := xmldb:login("/db","admin","perdika")
let $sample := request:get-parameter("sample",())
let $format := request:get-parameter("format","svg")
let $items := doc($index)//gv:item

return 
<html xmlns ="http://www.w3.org/1999/xhtml">
<body>
      <h1>  <a href="?">Graphviz Samples</a>  </h1>

      {if (empty($sample))
       then  
          <ul>
          {for $item in $items
           return
           <li> 
                     <a href="?sample={$item/gv:title}">{$item/gv:title/string()}</a> &#160;
                     {$item/gv:description/string()} [ {$item/gv:url/@type/string()} ]
           </li>
          }
          </ul>
       else 
          let $item := $items[gv:title=$sample]
          let $svg :=
              if ($item/gv:url/@type = "dot")
              then 
                   let $graph := util:binary-to-string(util:binary-doc(concat($sampledir,$item/gv:url)))
                   return gv:dot-to-svg($graph)                   
              else if ($item/gv:url/@type = "dotml")
              then 
                   let $dotml := doc(concat($sampledir,$item/gv:url))
                   let $graph := gv:dotml-to-dot($dotml)
                   return  
                       gv:dot-to-svg($graph) 
              else()
          return
           <div> 
             <h2> 
                 {$item/gv:title/string()}&#160;
                 {$item/gv:description/string()} [ {$item/gv:url/@type/string()} ]
              </h2>
             {$svg}  
           </div>
      }
</body>
</html>

