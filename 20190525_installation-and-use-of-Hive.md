# 2019-05-25 | Hive安装与使用

> 2019-05-25 | 大数据学习之路06


## Hive简介

这里先简单介绍，明确Hive的目标是什么。后续会详细介绍Hive架构与原理。

Hive是基于Hadoop的数据仓库工具，可以对存储在HDFS中的文件的数据进行数据整理、查询、分析。
Hive提供了类似与SQL的查询语言——HiveQL，可以通过HQL实现简单的MR统计，Hive将HQL语句转换成MR任务进行执行。

## Hive下载
### Hive与Hadoop对应关系

截止当前（2019-05-25），Hive最新版本有三种：hive-1.2.2、hive-2.3.5、hive-3.1.1。
![-w613](http://pic.iloc.cn/2019-06-08-15587721398169.jpg)

[Hive官网下载页面](http://hive.apache.org/downloads.html)说明，hive-2.3.5对应Hadoop版本是2.x.y，hive-3.1.1对应Hadoop版本是3.x.y。
![-w769](http://pic.iloc.cn/2019-06-08-15587722056656.jpg)

本人安装Hadoop版本是2.8.4，故下载hive-2.3.5。

### Hive下载地址
下载地址：http://mirror.bit.edu.cn/apache/hive/hive-2.3.5/apache-hive-2.3.5-bin.tar.gz

```
WZB-MacBook:50_bigdata wangzhibin$ pwd
/Users/wangzhibin/00_dev_suite/50_bigdata
WZB-MacBook:50_bigdata wangzhibin$ wget http://mirror.bit.edu.cn/apache/hive/hive-2.3.5/apache-hive-2.3.5-bin.tar.gz
```

## Hive安装配置
### Hive安装
* 解压

```
WZB-MacBook:50_bigdata wangzhibin$ tar zxvf apache-hive-2.3.5-bin.tar.gz
```
* 配置.bash_profile

```
WZB-MacBook:50_bigdata wangzhibin$ vi ~/.bash_profile
WZB-MacBook:50_bigdata wangzhibin$ source ~/.bash_profile
```
增加如下配置：
```
# hive
export HIVE_HOME=/Users/wangzhibin/00_dev_suite/50_bigdata/apache-hive-2.3.5-bin
export PATH=$PATH:$HIVE_HOME/bin
```

* 验证是否安装成功

```
WZB-MacBook:50_bigdata wangzhibin$ hive --version
Hive 2.3.5
Git git://HW13934/Users/gates/git/hive -r 76595628ae13b95162e77bba365fe4d2c60b3f29
Compiled by gates on Tue May 7 15:45:09 PDT 2019
From source with checksum c7864fc25abcb9cf7a36953ac6be4665
``` 

### Hive配置
由于hive是默认将元数据保存在本地内嵌的 Derby 数据库中，但是这种做法缺点也很明显，Derby不支持多会话连接，因此本文将选择mysql作为元数据存储。

1. 需要先安装Mysql，本文不做过多介绍，可以自行百度。
2. 需要下载mysql的jdbc<mysql-connector-java-5.1.47>，然后将下载后的jdbc放到hive安装包的lib目录下。

    ```
    WZB-MacBook:50_bigdata wangzhibin$ wget https://cdn.mysql.com//Downloads/Connector-J/mysql-connector-java-5.1.47.tar.gz
    WZB-MacBook:50_bigdata wangzhibin$ tar zxvf mysql-connector-java-5.1.47.tar.gz
    WZB-MacBook:50_bigdata wangzhibin$ cd mysql-connector-java-5.1.47
    WZB-MacBook:mysql-connector-java-5.1.47 wangzhibin$ cp mysql-connector-java-5.1.47-bin.jar $HIVE_HOME/lib/
    ```
3. 修改配置hive-site.xml
    ```
    WZB-MacBook:~ wangzhibin$ cd $HIVE_HOME/conf
    WZB-MacBook:conf wangzhibin$ pwd
    /Users/wangzhibin/00_dev_suite/50_bigdata/apache-hive-2.3.5-bin/conf
    WZB-MacBook:conf wangzhibin$ cp hive-default.xml.template hive-site.xml
    WZB-MacBook:conf wangzhibin$ vim hive-site.xml
    ```
    配置文件如下：
    ```xml
    <?xml version="1.0" encoding="UTF-8" standalone="no"?>
    <?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
    <configuration>
    <!-- WARNING!!! This file is auto generated for documentation purposes ONLY! -->
    <!-- WARNING!!! Any changes you make to this file will be ignored by Hive.   -->
    <!-- WARNING!!! You must make your changes in hive-site.xml instead.         -->
    <!-- Hive Execution Parameters -->
    <!-- 插入一下代码 -->
    <property>
        <name>javax.jdo.option.ConnectionUserName</name>
        <value>root</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionPassword</name>
        <value>mysql</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionURL</name>
        <value>jdbc:mysql://localhost:3306/hive</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionDriverName</name>
        <value>com.mysql.jdbc.Driver</value>
    </property>
    <!-- 到此结束代码 -->
    </configuration>
    ```

    ![-w643](http://pic.iloc.cn/2019-06-08-15587762766288.jpg)
4. 在mysql中初始化hive的schema（在此之前需要创建mysql下的hive数据库）
    ```
    WZB-MacBook:conf wangzhibin$ cd $HIVE_HOME/bin
    WZB-MacBook:bin wangzhibin$ schematool -dbType mysql -initSchema
    ```
    hive库中会初始化一些模型表：
    ![-w1236](http://pic.iloc.cn/2019-06-08-15587789088399.jpg)

1. 到此配置完毕。HDFS中并未初始化数据仓库位置。

## Hive使用

### 创建一个hive测试库
```
WZB-MacBook:bin wangzhibin$ hive
SLF4J: Class path contains multiple SLF4J bindings.
SLF4J: Found binding in [jar:file:/Users/wangzhibin/00_dev_suite/50_bigdata/apache-hive-2.3.5-bin/lib/log4j-slf4j-impl-2.6.2.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: Found binding in [jar:file:/Users/wangzhibin/00_dev_suite/50_bigdata/hadoop-2.8.4/share/hadoop/common/lib/slf4j-log4j12-1.7.10.jar!/org/slf4j/impl/StaticLoggerBinder.class]
SLF4J: See http://www.slf4j.org/codes.html#multiple_bindings for an explanation.
SLF4J: Actual binding is of type [org.apache.logging.slf4j.Log4jLoggerFactory]

Logging initialized using configuration in jar:file:/Users/wangzhibin/00_dev_suite/50_bigdata/apache-hive-2.3.5-bin/lib/hive-common-2.3.5.jar!/hive-log4j2.properties Async: true
Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. tez, spark) or using Hive 1.X releases.
hive>
hive> create database hive_1;
OK
Time taken: 4.089 seconds
hive> show databases;
OK
default
hive_1
Time taken: 0.123 seconds, Fetched: 2 row(s)
hive>
```

* **看看HDFS目录发生了什么变化**
    ```
    WZB-MacBook:conf wangzhibin$ hadoop fs -ls -R /user
    drwxr-xr-x   - wangzhibin supergroup          0 2019-05-25 18:22 /user/hive
    drwxr-xr-x   - wangzhibin supergroup          0 2019-05-25 18:22 /user/hive/warehouse
    drwxr-xr-x   - wangzhibin supergroup          0 2019-05-25 18:22 /user/hive/warehouse/hive_1.db
    drwxr-xr-x   - wangzhibin supergroup          0 2019-05-17 15:53 /user/wangzhibin
    ```
    
* **看看mysql下的hive库有什么变化**
    ```
    mysql> use hive;
    mysql> select * from DBS;
    +-------+-----------------------+-----------------------------------------------------+---------+------------+------------+
    | DB_ID | DESC                  | DB_LOCATION_URI                                     | NAME    | OWNER_NAME | OWNER_TYPE |
    +-------+-----------------------+-----------------------------------------------------+---------+------------+------------+
    |     1 | Default Hive database | hdfs://localhost:9000/user/hive/warehouse           | default | public     | ROLE       |
    |     2 | NULL                  | hdfs://localhost:9000/user/hive/warehouse/hive_1.db | hive_1  | wangzhibin | USER       |
    +-------+-----------------------+-----------------------------------------------------+---------+------------+------------+
    2 rows in set (0.00 sec)
    ```

### 创建一个hive测试表

```
hive> use hive_1;
OK
Time taken: 3.772 seconds
hive> create table hive_01 (id int,name string);
OK
Time taken: 0.582 seconds
hive> show tables;
OK
hive_01 
Time taken: 0.087 seconds, Fetched: 1 row(s)
hive>
```

* **看看HDFS目录发生了什么变化**
    ```
    WZB-MacBook:~ wangzhibin$ hadoop fs -ls -R /user
    drwxr-xr-x   - wangzhibin supergroup          0 2019-05-25 18:22 /user/hive
    drwxr-xr-x   - wangzhibin supergroup          0 2019-05-25 18:22 /user/hive/warehouse
    drwxr-xr-x   - wangzhibin supergroup          0 2019-05-25 18:28 /user/hive/warehouse/hive_1.db
    drwxr-xr-x   - wangzhibin supergroup          0 2019-05-25 18:28 /user/hive/warehouse/hive_1.db/hive_01
    drwxr-xr-x   - wangzhibin supergroup          0 2019-05-17 15:53 /user/wangzhibin
    ```
    
* **看看mysql下的hive库有什么变化**
    ```
    mysql> select * from TBLS;
    +--------+-------------+-------+------------------+------------+-----------+-------+----------+---------------+--------------------+--------------------+--------------------+
    | TBL_ID | CREATE_TIME | DB_ID | LAST_ACCESS_TIME | OWNER      | RETENTION | SD_ID | TBL_NAME | TBL_TYPE      | VIEW_EXPANDED_TEXT | VIEW_ORIGINAL_TEXT | IS_REWRITE_ENABLED |
    +--------+-------------+-------+------------------+------------+-----------+-------+----------+---------------+--------------------+--------------------+--------------------+
    |      1 |  1558780134 |     2 |                0 | wangzhibin |         0 |     1 | hive_01  | MANAGED_TABLE | NULL               | NULL               |                    |
    +--------+-------------+-------+------------------+------------+-----------+-------+----------+---------------+--------------------+--------------------+--------------------+
    1 row in set (0.00 sec)
    ```
    
* 看一下web上有什么变化。
    ![-w1216](http://pic.iloc.cn/2019-06-08-15587806689416.jpg)


以上就是hive的简单使用，说白了，hive与mysql的使用差不多；对应于hdfs，hive_1库是hdfs中的一个目录，hive_01表也是一个目录。

## 参考资料
1. [Hive基础知识介绍](https://blog.csdn.net/zhongqi2513/article/details/69388239)
2. [Hive详细介绍及简单应用](https://blog.csdn.net/l1212xiao/article/details/80432759)
3. [hive简介](https://www.cnblogs.com/ggzhangxiaochao/p/9363029.html)
4. [Hive安装与配置详解](https://www.cnblogs.com/dxxblog/p/8193967.html)

## ChangeLog

* 20190525 | 创建文档
