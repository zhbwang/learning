# Maven 使用入门

## Maven安装

```
[root@bd129137 raw]# pwd
/usr/local/raw
[root@bd129137 raw]# wget http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.tar.gz
[root@bd129137 raw]# tar zxvf apache-maven-3.6.1-bin.tar.gz
[root@bd129137 raw]# cd ..
[root@bd129137 local]# ln -s raw/apache-maven-3.6.1 maven
```

配置M2_HOME与PATH，在~/.bash_profile中增加

```
# maven
export PATH=$PATH:/usr/local/maven/bin
```

验证：

```
[root@bd129137 local]# mvn -v
Apache Maven 3.6.1 (d66c9c0b3152b2e69ee9bac180bb8fcc8e6af555; 2019-04-05T03:00:29+08:00)
Maven home: /usr/local/maven
Java version: 1.8.0_171, vendor: Oracle Corporation, runtime: /usr/local/raw/jdk1.8.0_171/jre
Default locale: zh_CN, platform encoding: UTF-8
OS name: "linux", version: "3.10.0-327.el7.x86_64", arch: "amd64", family: "unix"
```



## 参考资料
1. [Maven – Installing Apache Maven](http://maven.apache.org/install.html)

## ChangeLog

* 20190717 | 创建文档