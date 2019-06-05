# MySQL创建用户与分配权限

## 创建用户

### 用户管理
```
mysql>use mysql;
```
### 查看用户
```
mysql> select host,user,password from user ;
```
### 创建用户
```
mysql> create user ddk IDENTIFIED by 'tydic123';
//identified by 会将纯文本密码加密作为散列值存储
```
### 查看用户权限
```
mysql> show grants for ddk;
```

## 创建数据库

```
create database aop_portal_ah;
create database aop_ah;
create database dim_ah;
create database ddf_ah;
create database mlp_ah;
create database etl_ah;
create database rcr_ah;
```

## 赋权

```
grant all privileges on aop_portal_ah.* to 'ddk'@'%' identified by '123';
grant all privileges on aop_ah.* to 'ddk'@'%' identified by '123';
grant all privileges on ddf_ah.* to 'ddk'@'%' identified by '123';
grant all privileges on dim_ah.* to 'ddk'@'%' identified by '123';
grant all privileges on etl_ah.* to 'ddk'@'%' identified by '123';
grant all privileges on mlp_ah.* to 'ddk'@'%' identified by '123';
grant all privileges on rcr_ah.* to 'ddk'@'%' identified by '123';
FLUSH PRIVILEGES;
```

## 其他备用命令

### 回收权限
```
// 部分权限，如果权限不存在会报错
mysql> revoke  select on dmc_db.*  from  ddk;  
// 所有权限
mysql> REVOKE USAGE ON *.* FROM 'aop_pdesigner'@'%';
mysql> FLUSH PRIVILEGES;
```

### 修改用户
```
mysql>rename   user  feng  to   newuser; //mysql 5之后可以使用，之前需要使用update 更新user表
```

### 删除用户
```
mysql>drop user newuser;   //mysql5之前删除用户时必须先使用revoke 删除用户权限，然后删除用户，mysql5之后drop 命令可以删除用户的同时删除用户的相关权限
```

### 更改密码
```
mysql> set password for zx_root =password('xxxxxx');
mysql> update  mysql.user  set  password=password('xxxx')  where user='otheruser'
```