xquery version "3.0";

import module namespace login="http://exist-db.org/xquery/login" at "resource:org/exist/xquery/modules/persistentlogin/login.xql";

declare variable $exist:root external;
declare variable $exist:prefix external;
declare variable $exist:controller external;
declare variable $exist:path external;
declare variable $exist:resource external;

(: get/update the login status from the dashboard's session :)
let $login := login:set-user("org.exist.login", (), false())
return
    if ($exist:path eq '') then
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
            <redirect url="{concat(request:get-uri(), '/')}"/>
        </dispatch>
        
    else if ($exist:path eq "/") then
        (: forward root path to index.xq :)
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
            <redirect url="./xquery/index.xq"/>
        </dispatch>
        
    else
        (: everything else is passed through :)
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
            <cache-control cache="yes"/>
        </dispatch>