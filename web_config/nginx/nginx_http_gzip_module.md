nginx gzip module 压缩模块
========================


gzip 开启或关闭 gzip
---------------------------------------
```
Syntax:  gzip on | off;
Default: gzip off;
Context: http, server, location, if in location
```
* Enables or disables gzipping of responses. 开启或关闭对响应的gzip压缩


gzip_static 静态压缩
--------------------------------------------
```
Syntax:  gzip_static on|off|always;
Default: gzip_static off;
Context: http, server, location
```
* 来自 __ngx_http_gzip_static_module__ 模块，而非 __ngx_http_gzip_module__模块。
* Allows sending precompressed files with the `.gz` filename extension instead of regular files.
* 需要使用bash脚本预先生成静态资源的gzip压缩


gzip\_comp\_level 设置压缩级别
----------------------------------------------
```
Syntax:  gzip_comp_level level;
Default: gzip_comp_level 1;
Context: http, server, location
```
* sets a gzip compression level of a response. Acceptable values are in the range from 1 to 9;


gzip\_buffers 设置 gzip使用的缓冲区
----------------------------------
```
Syntax:  gzip_buffers number size;
Default: gzip_buffers 32 4k|16 8k;
Context: http, server, location
```
* Sets the `number` and `size` of buffers used to compress a response. By default, the buffer size is equal to one memory page. 


gzip\_min\_length 设置需要压缩的response大小阈值
------------------------------------------
```
Syntax:  gzip_min_length length;
Default: gzip_min_length 20;
Context: http, server, location;
```
* Sets the minimum length of a response that will be gzipped. The length is determined only from the "Content-Length" response header field. 


gzip_types  设置需要使用gzip的MIME类型
------------------------------------------
```
Syntax:  gzip_types mime-type ...
Default: gzip_types text/html;
Context: http, server, location;
```
* Enables gzipping of responses for the specified MIME types in addition to "text/html". The special values "*" matches any MIME type.  


