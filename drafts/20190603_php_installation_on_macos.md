# 2019-06-03 | MacOS下安装PHP与nginx配置

MacOS系统自带PHP的，不过还是建议自己安装。

## 使用brew安装PHP
```
# brew update
# brew install php@7.2
...
...
To have launchd start php@7.2 now and restart at login:
  brew services start php@7.2
Or, if you don't want/need a background service you can just run:
  php-fpm
```
注：如何`brew update`很慢的话，可以参考[MacOS的brew update很慢问题解决方案](./20190603_MacOS_brew_update_too_slow.md)进行设置。

## 修改配置文件

* 执行命令：
    ```
    sudo cp /private/etc/php-fpm.conf.default /private/etc/php-fpm.conf
    sudo cp /private/etc/php-fpm.d/www.conf.default /private/etc/php-fpm.d/www.conf
    ```

* 找到`/private/etc/`目录下的 php-fpm 文件
    ```
    /private/etc/php-fpm.conf
    ```

* 找到24行的 error_log ，改为（整行替换，注意 ‘;’ 和空格，就是要把‘;’也删除掉）
    ```
    error_log = /usr/local/var/log/php-fpm.log
    ```
    否则 php-fpm 时会报错：
    ```
    ERROR: failed to open error_log (/usr/var/log/php-fpm.log): No such file or directory
    ```

## 启动PHP

* 如果希望后台自动启动，执行以下命令：
    ```
    brew services start php@7.2
    ```
* 如果只是本次执行，直接运行：
    ```
    php-fpm
    ```

## 配置Nginx运行php

* 打开nginx.conf ，在http块添加一行`include servers/*.conf;`。MacOS使用brew安装nginx的配置文件目录在`/usr/local/etc/nginx/`。
* 在`/usr/local/etc/nginx/servesr`下创建`xxx.conf`。我这里创建的是`dokuwiki.conf`
* 增加以下内容，尤其注意`location ~ .+\.php($|/) `部分。
    ```
    server {
      listen 8090;
      root /usr/local/Cellar_w/dokuwiki;
      server_name localhost;
      index index.php index.html doku.php;
      location ~ ^/(data|conf|bin|inc) {
              return 404;
      }
      location ~ ^/lib.*\.(gif|png|ico|jpg)$ {
              expires 31d;
      }
      #location / {
      #        try_files $uri $uri/ @dokuwiki;
      #}
      location @dokuwiki {
              rewrite ^/_media/(.*) /lib/exe/fetch.php?media=$1 last;
              rewrite ^/_detail/(.*) /lib/exe/detail.php?media=$1 last;
              rewrite ^/_export/([^/]+)/(.*) /doku.php?do=export_$1&id=$2 last;
              rewrite ^/tag/(.*) /doku.php?id=tag:$1&do=showtag&tag=tag:$1 last;
              rewrite ^/(.*) /doku.php?id=$1&$args last;
      }
      location ~ .+\.php($|/) {
            include        fastcgi_params;
            set $real_script_name $uri;
            set $path_info "/";
            if ($fastcgi_script_name ~ "^(.+\.php)(/.+)$") {
                set $real_script_name $1;
                set $path_info $2;
            }
            fastcgi_param SCRIPT_FILENAME $document_root$real_script_name;
            fastcgi_param SCRIPT_NAME $real_script_name;
            fastcgi_param PATH_INFO $path_info;
            fastcgi_pass   127.0.0.1:9000;#监听9000端口
            fastcgi_index  index.php;
        }
   }
    ```
* 重新启动nginx，下面两种命令都可以。
    ```
    sudo brew services restart nginx
    /usr/local/bin/nginx -s reload
    ```
    
## 遇到的坑
### 问题一：Nginx代理PHP，报错Connection reset by peer
* nginx.log中错误信息如下：
    ```
    [error] 85581#0: *4 kevent() reported about an closed connection (54: Connection reset by peer) while reading response header from upstream, client: 127.0.0.1, server: localhost, request: "GET / HTTP/1.1", upstream: "fastcgi://127.0.0.1:9000", host: "localhost:8088"
    ```
* 出错的原因是php-fpm未启动。
* 解决：`sudo php-fpm`

### 问题二、使用sudo php-fpm会报路径出错问题
可能是你配置路径那里没有修改，具体可以看上面的 `修改配置文件`章节。

### 问题二：No pool defined
```
[root@localhost etc]# service php-fpm start
Starting php-fpm [28-Nov-2016 17:13:23] WARNING: Nothing matches the include pattern ‘/usr/local/php/etc/php-fpm.d/*.conf’ from /usr/local/php/etc/php-fpm.conf at line 125.
[28-Nov-2016 17:13:23] ERROR: No pool defined. at least one pool section must be specified in config file
[28-Nov-2016 17:13:23] ERROR: failed to post process the configuration
[28-Nov-2016 17:13:23] ERROR: FPM initialization failed
```

解决方法:
1. 进入PHP安装目录/etc/php-fpm.d
2. `cp www.conf.default www.conf`

## 参考资料
1. [MACOS下安装PHP运行环境](https://www.jianshu.com/p/17f917ffc474)
2. [Mac Nginx+php环境配置，看我就够了](https://www.jianshu.com/p/5c57ea8efae3)
3. [在 macOS High Sierra 10.13 搭建 PHP 开发环境](https://learnku.com/articles/6243/building-php-development-environment-in-macos-high-sierra-1013)
4. [php-fpm:No pool defined解决方法](https://blog.csdn.net/gb4215287/article/details/75247335)





