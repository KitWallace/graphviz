(: view samples :)
import module namespace gv = "http://kitwallace.co.uk/ns/qraphviz" at "../lib/graphviz.xqm";

declare variable $sampledir := concat($gv:base,"samples/");
declare variable $index := concat($sampledir,"library.xml");

declare option exist:serialize "method=xhtml media-type=application/xhtml+xml";

let $login := xmldb:login("/db","admin","password")
let $sample := request:get-parameter("sample",())
let $format := request:get-parameter("format","svg")
let $items := doc($index)//gv:item

return 
<html xmlns ="http://www.w3.org/1999/xhtml">
<body>
      <h1>  <a href="?">Graphviz Samples</a>  </h1>

      {if (empty($sample))
       then  
         <div>
          <h2>Samples from BASEX</h2>
          <ul>
          {for $item in $items
           return
           <li> 
                 <a href="?sample={$item/@id}"> {$item/gv:title/string()}</a> &#160;{$item/gv:description/string()}[ {$item/gv:url/@type/string()} ]
           </li>
          }
          </ul>
          <h2>Employee Manager Graph</h2>
          <div>         
               <a href="managers.xq">Graph</a> generated from xml database and linked to employee details
          </div>
         </div>
       else 
          if ($format="svg")
          then
            let $item := $items[@id=$sample]
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
                 {$item/gv:title/string()} &#160; {$item/gv:description/string()} [ {$item/gv:url/@type/string()} ] <a href="?sample={$sample}&amp;format=source">Source</a>
              </h2>
             {$svg}  
           </div>
         else if ($format="source")
         then 
            let $item := $items[@id=$sample]
            let $source :=
              if ($item/gv:url/@type = "dot")
              then 
                   let $graph := util:binary-to-string(util:binary-doc(concat($sampledir,$item/gv:url)))
                   return <pre>{$graph}</pre>                 
              else if ($item/gv:url/@type = "dotml")
              then 
                   let $dotml := doc(concat($sampledir,$item/gv:url))
                   return  <pre>{util:serialize($dotml,"method=xml")}</pre>
              else()
            return
           <div> 
             <h2> 
                Source  {$item/gv:description/string()} [ {$item/gv:url/@type/string()} ] <a href="?sample={$sample}&amp;format=svg">SVG</a>
              </h2>
             {$source}  
           </div>
         else ()
      }
</body>
</html>

