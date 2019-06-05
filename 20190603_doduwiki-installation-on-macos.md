# DokuWiki安装小记

> 2019-06-03

以下为MacOS平台的DokuWiki安装，其他平台类似。

## 什么是DokuWiki

DokuWiki 是一个使用，用途多样的开源 Wiki 软件，并且不需要数据库。

比较wiki

## 安装准备工作

* 安装nginx。
* 安装php。参考[MacOS下安装PHP与nginx配置](20190603_php_installation_on_macos.md)

## 安装DokuWiki

安装过程参考：[DokuWiki with Mac OS X and Apache](https://www.dokuwiki.org/install:macosx)

* 下载DokuWiki。可以在[官网](https://download.dokuwiki.org/)直接下载，我下载的是`2019-05-31 snapshot`版本，放到目录`/usr/local/Cellar_w/raw`下。
    ```
    WZB-MacBook:raw wangzhibin$ pwd
    /usr/local/Cellar_w/raw
    WZB-MacBook:Cellar_w wangzhibin$ wget https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz
    ```
    
* 解压DokuWiki安装包，并创建软连接。
    ```
    WZB-MacBook:raw wangzhibin$ tar zxvf splitbrain-dokuwiki-upstream-0.0.20091252c-7022-g2e6e11a.tar.gz
    WZB-MacBook:raw wangzhibin$ cd ..
    WZB-MacBook:Cellar_w wangzhibin$ pwd
/usr/local/Cellar_w
    WZB-MacBook:Cellar_w wangzhibin$ ln -s raw/splitbrain-dokuwiki-2e6e11a/ dokuwiki
    ```
    
## 配置nginx代理


* 打开`nginx.conf `，在http块添加一行`include servers/*.conf;`（默认已经存在）。MacOS使用brew安装nginx的配置文件目录在`/usr/local/etc/nginx/`。
* 在`/usr/local/etc/nginx/servesr`下创建`dokuwiki.conf`。
* 增加以下内容：
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
    
* 在浏览器中打开`http://localhost:8090`，即可访问dokuWiki首页了。
    ![-w1082](http://pic.iloc.cn/2019-06-05-15595658164723.jpg)


## 使用DokuWiki

### 初始化安装与ACL启用
![-w625](http://pic.iloc.cn/2019-06-05-15595739178774.jpg)


### 中文文件名乱码问题

* 在界面中搜索“测试页面”
    ![-w1034](http://pic.iloc.cn/2019-06-05-15596115180449.jpg)

* 点击红色的“:测试页面”，即可创建中文词条“测试页面”。随便写个内容，保存。
* 在后台pages目录下该词条名称乱码。
    ![-w310](http://pic.iloc.cn/2019-06-05-15596116364061.jpg)
* 下面就开始修改源码，使得中文词条名称正常。
* 在dokuwiki/conf/local.php文件最后一行加上。（如果conf目录仅发现local.php.dist文件，这是没有install的缘故。）
  
    ```
    $conf[ 'fnencode' ] = 'utf-8'; #注意分号不能少。
    ```
    
* 再次尝试创建中文词条
    ![-w1034](http://pic.iloc.cn/2019-06-05-15596125526519.jpg)
    发现pages目录正常。
![-w303](http://pic.iloc.cn/2019-06-05-15596129447193.jpg)

## Doku主题

### 官方主题排行

[官方主题](https://www.dokuwiki.org/template?pluginsort=^c#extension__table)按照受欢迎程度排名靠前的如下：
![-w716](http://pic.iloc.cn/2019-06-05-15596146705213.jpg)

### 主题安装

以主题Breeze为例。
* 下载主题[Breeze Template](https://www.dokuwiki.org/template%3Abreeze)，解压到`lib/tpl/`目录下，命名为`breeze`。
* 在`conf/local.php`文件中增加：
    ```
    $conf['template']='breeze'; // 配置的是tpl下主题目录名。
    ```

### 推荐主题

推荐的几个主题。在官网主题区可以搜索到。
    * bootstrap3
    * vector (强烈推荐)
    * sprintdoc
    * breeze
    * white    


### 修改vector主题样式

#### 修改侧边栏的宽度

修改`lib/tpl/vector/static/3rd/vector/main-ltr.css`中的样式：

```
div#panel {
	...
	width: 13em;
	...
}
    
...
  
/* Content */
div#content {
	margin-left: 13em;
	...
}
    
...
    
/* Footer */
div#footer {
	margin-left: 13em;
	...
}
...
    
/* Navigation Containers */
#left-navigation {
	...
	left: 13em;
	...
}
```

#### 更换logo
使用Vector主题时，logo位置为：background-image:url(/lib/tpl/vector/static/3rd/dokuwiki/logo.png); 替换即可。
        
## DokuWiki插件

### 侧边栏插件indexmenu

* 安装[indexmenu](https://www.dokuwiki.org/plugin:indexmenu)插件
* 在sidebar页面增加配置，左侧会自动出现全部页面导航。

    ```
    {{indexmenu>..|js#bj-tango.png navbar}}
    ```
    

**indexmenu使用**    

* 仅显示:wiki里面的内容
  
    ```
    {{indexmenu>:wiki#1|js}}
    {{indexmenu>:wiki.|js#bj-tango.png navbar}}
    ```
* 默认展开到两层
    ```
    {{indexmenu>.#2|js#bj-tango.png navbar}}
    ```
    ![](http://pic.iloc.cn/2019-06-04-15596408772873.jpg)

* 仅展现wiki下的，并且去掉toc、右键菜单。
    ```
    {{indexmenu>:wiki#2|js#bj-tango.png notoc nomenu}}
    ```
![](http://pic.iloc.cn/2019-06-04-15596416070547.jpg)

* Vector主题下不能展示sidebar的修改方法，在lib/tpl/vector/conf/default.php中修改：
    ```
    //$conf["vector_navigation_location"]  = ":wiki:navigation"; //page/article used to store the navigation
    $conf["vector_navigation_location"]  = ":sidebar"; //page/article used to store the navigation
    ```
    
* 增加排序
    ```
    {{indexmenu>:wiki#2|js#vista.png notoc nomenu tsort}}
    ```

### 新增页面插件Add New Page

* 在扩展管理器中搜索“Add New Page”，安装此插件。
* 在sidebar页面下方增加，表示仅在wiki命名空间下增加页面。
    ```
    ------------------------
    {{NEWPAGE>wiki}}
    ```
* 有了page新增管理，那么命名空间怎么新增呢？
    直接在浏览器输入`http://localhost:8091/doku.php?id=wiki:test:新目录:新文件`，即可创建。
* 如何删除文件？
    
    *  进入编辑页面，文章内容全部删除后，保存，该文章就被删除了。与此同时，如果命名空间下没有文章，命名空间也被删除了    


### 移动插件move

* 在扩展管理器中搜索“move”，安装此[插件](https://www.dokuwiki.org/plugin:move)。
* 使用方法，在管理界面，会出现“页面移动/重命名...”的工具，可以进入管理界面。
    ![](http://pic.iloc.cn/2019-06-04-15596422024308.jpg)
    
### 贡献插件authorstats

* 安装[authorstats](https://www.dokuwiki.org/plugin:authorstats)插件。
* 在文章中增加
    ```
    <AUTHORSTATS> 
    <AUTHORSTATS 16>
    ```
    
* 保存后即可查看
    ![](http://pic.iloc.cn/2019-06-04-15596489919984.jpg)    
    
    
### 评论区插件discussion

* 插件：plugin:discussion
* 用法：`~~DISCUSSION~~`，插入该语句到 wiki 中，即可在 wiki 内容后添加评论区。
* 配置：管理->配置管理->Discussion，比较有用的配置：
    * 订阅评论区
    * 通知版主有新评论
    * 允许未注册用户评论
    * 可通过 wiki 语法评论
    
### 其他可直接安装使用的插件
* 编辑器支持markdown语法插件：plugin:markdowku
* 编辑器支持直接粘贴图片：plugin:imgpaste
* 导出Word文件plugin:OpenOffice.org    

## 附录

### local.php文件内容
```
<?php
/**
 * Dokuwiki's Main Configuration File - Local Settings
 * Auto-generated by install script
 * Date: Tue, 04 Jun 2019 01:32:48 +0000
 */
$conf['title'] = 'wenbin‘s wiki';
$conf['lang'] = 'zh';
$conf['license'] = '0';
$conf['useacl'] = 1;
$conf['superuser'] = '@admin';
$conf['disableactions'] = 'register';
$conf[ 'fnencode' ] = 'utf-8'; 
$conf['template']='vector';
```

### sidebar.txt文件内容
```
{{indexmenu>:wiki#2|js#vista.png notoc nomenu tsort}}

---------

{{NEWPAGE>wiki}}
```

### start内容底部包括贡献内容
```
<AUTHORSTATS> 

<AUTHORSTATS 16>.
```

## 参考资料
1. [dokuwiki 搭建](https://www.jianshu.com/p/8adbba074d3e)
2. [官方插件](https://www.dokuwiki.org/plugins)
3. [用 Dokuwiki 管理小团队知识](http://chenzixin.github.io/pmp/2013/03/26/dokuwiki-you-knowledge/)
4. [dokuwiki安装使用教程（支持中文、editor.md、粘贴上传图片）](https://blog.csdn.net/mergerly/article/details/79629562)
