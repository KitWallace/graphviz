import module namespace gv = "http://kitwallace.co.uk/ns/qraphviz" at "../lib/graphviz.xqm";
declare namespace svg = "http://www.w3.org/2000/svg";

declare option exist:serialize "method=xhtml media-type=application/xhtml+xml";
declare function local:manager-graph ($emps) {
<graph>
  digraph {{
 { for $emp in $emps/Emp
   let $mgr := $emps/Emp[EmpNo = $emp/MgrNo]
   where exists($mgr)
   return
    <link>{$mgr/Ename} -> {$emp/Ename}; {$gv:nl}</link>
 }
 { for $emp in $emps/Emp
   let $name := $emp/Ename/string()
   return
    <node> {$name} [URL="?emp={$name}"]; {$gv:nl}</node>
 }
 
 }}
</graph>
};

declare function local:element-to-table($el) {
   <table xmlns="http://www.w3.org/1999/xhtml" >
   {for $field in $el/*
    return
     <tr><th>{name($field)}</th><td>{$field/string()}</td></tr>
   }
   </table>
};

let $login := xmldb:login("/db/","admin","perdika")
let $empfile := "/db/apps/graphviz/data/empdept.xml"
let $emps:= doc($empfile)/EmpTable
let $ename := request:get-parameter("emp",())
let $emp := $emps/Emp[Ename = $ename]
return 
<html xmlns="http://www.w3.org/1999/xhtml" >
<body>
      <h1>Empdept data <a href="../data/empdept.xml">raw data</a></h1>
      {if (empty($emp))
       then  
          let $graph := local:manager-graph($emps)
          return 
          <div>
             <h2>Click on a name for details</h2>
             {gv:dot-to-svg($graph)}
          </div>
       else 
          <div> 
              <h2><a href="?">Managers</a></h2>
              {local:element-to-table($emp)}
          </div>
      }
</body>
</html>
