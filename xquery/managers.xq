import module namespace gv = "http://kitwallace.co.uk/ns/graphviz" at "../lib/graphviz.xqm";
declare namespace svg = "http://www.w3.org/2000/svg";
declare namespace dotml ="http://www.martin-loetzsch.de/DOTML";

declare function local:manager-graph ($emps) {
let $dept-colours := 
  <colours>
     <colour dept="10" name="red"/>
     <colour dept="20" name="green"/>
     <colour dept="30" name="blue"/>
     <colour dept="40" name="yellow"/>
  </colours>
return
<dotml:graph>
 { for $emp in $emps/Emp
   let $colour := $dept-colours/colour[@dept=$emp/DeptNo]/@name/string()
   return
    <dotml:node id="{$emp/Ename}" URL="?emp={$emp/EmpNo}" style="filled" fillcolor="{$colour}"/>
 }
 { for $emp in $emps/Emp
   let $mgr := $emps/Emp[EmpNo = $emp/MgrNo]
   where exists($mgr)
   return
     <dotml:edge from="{$mgr/Ename}" to="{$emp/Ename}"/>
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
let $graph := local:manager-graph($emps)
let $dot := gv:dotml-to-dot($graph)
let $empNo := request:get-parameter("emp",())
let $emp := $emps/Emp[EmpNo = $empNo]

return 
<html xmlns="http://www.w3.org/1999/xhtml" >
<body>
      <center><h2>Empdept data <a href="../data/empdept.xml">raw data</a> (Click on a name for details)</h2></center>
      <hr/>
      <table>
      <tr>
         <td>
          {gv:dot-to-svg($dot)}
         </td>
         <td>     
          {local:element-to-table($emp)}
         </td>
      </tr>
      </table>
</body>
</html>
