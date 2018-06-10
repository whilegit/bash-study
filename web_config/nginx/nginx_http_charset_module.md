nginx 编码转换模块
========================================
注意：编码只能在单字符集之间 或者 单字符集和UTF-8之间转换。并不支持 GBK.

charset 设置编码
--------------------------------------------
```
Syntax:   charset charset | off;
Default:  charset off;
Context:  http, server, location, if in location
```
* Adds the specified charset to the `Content-Type` response header field. If this charset is different from the charset specified in the `source _charset` directive, a conversion is performed. 设置 `Content-Type`头的内容为该编码格式, 如果和源文件的编码格式不同，则将启动编码转换; 
* `charset off` 指令将不添加字符集至 `Content-Type`响应头中。  

source_charset 设置原始响应的编码
------------------------------------------------
```
Syntax:  source_charset charset;
Default:  ---
Context:  http, server, location, if in location
```
* Defines the source charset of a response. 



