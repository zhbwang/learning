# 2019-06-03 | MacOS的brew update很慢问题解决方案

## 替换为中科大源

### 替换brew.git

```
cd "$(brew --repo)"
git remote set-url origin https://mirrors.ustc.edu.cn/brew.git
```

### 替换homebrew-core.git
```
cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git
```

### 替换Homebrew Bottles源

就是在~/.bashrc或者~/.bash_profile文件末尾加
```
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
```
这两个文件可以自己创建，~/.bashrc和~/.bash_profile都可以

## 切换回官方源：

### 重置brew.git
```
cd "$(brew --repo)"
git remote set-url origin https://github.com/Homebrew/brew.git
```

### 重置homebrew-core
```
cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
git remote set-url origin https://github.com/Homebrew/homebrew-core.git
```
### 替换为清华源

[brew清华源](https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/)

## 参考资料

1. [Homebrew国内源设置与常用命令](https://segmentfault.com/a/1190000008274997)