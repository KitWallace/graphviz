import module namespace gv = "http://kitwallace.co.uk/ns/graphviz" at "../lib/graphviz.xqm";
declare namespace svg = "http://www.w3.org/2000/svg";
declare namespace dotml ="http://www.martin-loetzsch.de/DOTML";

declare function local:manager-graph ($emps) {
<dotml:graph>
 { for $emp in $emps/Emp
   let $name := $emp/Ename/string()
   let $mgr := $emps/Emp[EmpNo = $emp/MgrNo]
   where exists($mgr)
   return
    (<dotml:node id="{$name}" URL="?emp={$name}"/>,
     <dotml:edge from="{$mgr/Ename}" to="{$emp/Ename}"/>
    )
 }
</dotml:graph>
};

declare function local:element-to-table($el) {
   <table xmlns="http://www.w3.org/1999/xhtml" >
   {for $field in $el/*
    return
     <tr><th>{name($field)}</th><td>{$field/string()}</td></tr>
   }
   </table>
};

declare option exist:serialize "method=xhtml media-type=application/xhtml+xml";

let $isDba := xmldb:is-admin-user(xmldb:get-current-user())
return
    if (not($isDba)) then
        <div class="warn">
            <p>You have to be a member of the dba group. Please log in using the dashboard and retry.</p>
        </div>
else 

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
          let $dot := gv:dotml-to-dot($graph)
          return 
          <div>
             <h2>Click on a name for details</h2>
             {gv:dot-to-svg($dot)}
          </div>
       else 
          <div> 
              <h2><a href="?">Managers</a></h2>
              {local:element-to-table($emp)}
          </div>
      }
</body>
</html>
