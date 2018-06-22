nginx http headers module
=========================

add_header 在response中添加请求头
--------------------------------
```
Synatx:  add_header name value [always]
Default: ---
Context: http, server, location, if in location
```
* Adds the specified field to a response header provided that the response code equals 200,201,204,206,301,302,303,304,307,308. The value can contain variables. 


