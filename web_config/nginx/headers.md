头信息
=======================

Access-Control-Allow-Origin
---------------------------
```
// 允许任何的域下发起跨域请求，现在大部分浏览器都支持了CORS头协议
Access-Control-Allow-Origin *;

// 仅允许指定的域发起跨域请求
Access-Control-Allow-Origin http://lanehub.cn;

```
* 允许跨域请求
* 本质上是告诉浏览器不要拦截访问本服务器的跨域ajax请求


Access-Control-Allow-Method
---------------------------
```
// 设置跨域访问允许的请求类型
Access-Control-Allow-Method 'GET,POST,HEAD,PUT,DELETE,OPTIONS';
```

Access-Control-Allow-Credentials
--------------------------------
```
// 跨域访问时，可以带上cookie凭证
Access-Control-Allow-Credentials 'true';
```

