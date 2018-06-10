nginx ����ת��ģ��
========================================
ע�⣺����ֻ���ڵ��ַ���֮�� ���� ���ַ�����UTF-8֮��ת��������֧�� GBK.

charset ���ñ���
--------------------------------------------
```
Syntax:   charset charset | off;
Default:  charset off;
Context:  http, server, location, if in location
```
* Adds the specified charset to the `Content-Type` response header field. If this charset is different from the charset specified in the `source _charset` directive, a conversion is performed. ���� `Content-Type`ͷ������Ϊ�ñ����ʽ, �����Դ�ļ��ı����ʽ��ͬ������������ת��; 
* `charset off` ָ�������ַ����� `Content-Type`��Ӧͷ�С�  

source_charset ����ԭʼ��Ӧ�ı���
------------------------------------------------
```
Syntax:  source_charset charset;
Default:  ---
Context:  http, server, location, if in location
```
* Defines the source charset of a response. 



