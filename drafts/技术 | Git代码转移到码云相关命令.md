# 技术 | Git代码转移到码云相关命令

## 查看当前用户（global）配置 
```
git config --global --list 
```


## 生成公钥 
```
ssh-keygen -t rsa -C "youremail@example.com" 
```


## 查看本地代码的远程仓库地址 
```
git remote -v 
```


## 校验本机是否能连接gitee 
```
ssh -T git@gitee.com 
```


## 重新设置远程仓库地址 
```
git remote set-url origin git@gitee.com:xxx/xxxx.git 

OR 

git remote set-url origin https://gitee.com/xxxx/xxxx.git 
```

```
git remote -v 
```

## 第一次pull出现问题的处理方法 
```
git pull  --allow-unrelated-histories 
```

## 代码的换行符与windows不一致的情况，处理方法： 
```
git config --global core.autocrlf input 
```