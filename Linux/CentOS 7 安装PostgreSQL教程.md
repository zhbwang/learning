# Linux CentOS 7 安装PostgreSQL教程


## 查看是否有postgres包： 
```
yum list postgres*
```
## 安装： 
```
yum install postgresql postgresql-devel postgresql-server postgresql-libs postgresql-contrib  
```
```
service postgresql initdb
service postgresql start
chkconfig postgresql on
```
## 连接数据库
* 命令行连接
```
su - postgres
psql
postgres=# \l
```
* 修改密码
```
postgres=# alter user postgres with password '123';
```
* 退出连接
```
postgres=# \q
```

## 迁移数据库目录

```
sudo mkdir /mnt/postgresql/data
sudo chown -R postgres:postgres /mnt/postgresql/data
sudo chmod 700 /mnt/postgresql/data

vi /etc/profile或者vi /var/lib/pgsql/.bash_profile

export PGDATA=/mnt/postgresql/data
source /etc/profile
```

* 停止postgresql：
```
sudo systemctl stop postgresql
```
* 修改/usr/lib/systemd/system/postgresql.service：
```
Environment=PGDATA=/mnt/postgresql/data
```
* 使用postgres用户拷贝数据文件。
```
sudo su - postgres
cp -rf /var/lib/pgsql/data/* /mnt/postgresql/data
```
* 【不知道是否必须】
```
vi /mnt/postgresql/data/postmaster.opts
/usr/bin/postgres "-D" "/mnt/postgresql/data" "-p" "5432"
```
* 启动数据库：
```
sudo systemctl restart posrgresql
```

## 修改客户端访问权限

```
vi /mnt/postgresql/data/postgresql.conf
```
将listen_addresses前的#去掉，并将listen_addresses = 'localhost'改成listen_addresses = '*'

```
vi /mnt/postgresql/data/pg_hba.conf
host    all             all             172.16.222.1/24         md5
host    all             all             0.0.0.1/0               md5
```
重启：
```
sudo systemctl restart postgresql
```
