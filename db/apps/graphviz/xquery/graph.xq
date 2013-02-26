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
    <link> {$emp/Ename} ->  {$mgr/Ename}; 
    </link>
 }
 { for $emp in $emps/Emp
   let $name := $emp/Ename/string()
   return
    <node> {$name} [URL="?emp={$name}"]; 
    </node>
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
let $emps:= doc("/db/apps/graphviz/data/empdept.xml")/EmpTable
let $ename := request:get-parameter("emp",())
let $emp := $emps/Emp[Ename = $ename]
return 
<html xmlns="http://www.w3.org/1999/xhtml" >
<body>
      <h1>Empdept data </h1>
      {if (empty($emp))
       then  
          let $graph := local:manager-graph($emps)
          return gv:dot-to-svg($graph)
       else 
          <div> 
              <h2><a href="?">Managers</a></h2>
              {local:element-to-table($emp)}
          </div>
      }
</body>
</html>
