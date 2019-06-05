# 2019-05-27  | Hive实现wordcount词频统计

> 2019-05-27 | 大数据学习之路07

## 新建测试文件

```
WZB-MacBook:tmp wangzhibin$ pwd
/Users/wangzhibin/00_dev_suite/50_bigdata/tmp
WZB-MacBook:tmp wangzhibin$ vi test.txt
```
增加内容：
```
hello man
what are you doing now
my running
hello
kevin
hi man
```
## 文件导入到hive

### 建表并指定文件内容分隔符
```
hive> use hive_1;
OK
Time taken: 0.024 seconds
hive> create table wc(txt String) row format delimited fields terminated by '\t';
OK
Time taken: 0.715 seconds
hive> show tables;
OK
hive_01
wc
Time taken: 0.035 seconds, Fetched: 2 row(s)
```

### 导入文件
HDFS初始无数据
```
WZB-MacBook:50_bigdata wangzhibin$ hadoop fs -ls -R /user/hive/warehouse/hive_1.db/wc
返回无数据
```
导入文件
```
hive> load data local inpath '/Users/wangzhibin/00_dev_suite/50_bigdata/tmp/test.txt' overwrite into table wc;
Loading data to table hive_1.wc
OK
Time taken: 2.235 seconds
hive> select * from wc;
OK
hello man
what are you doing now
my running
hello
kevin
hi man
Time taken: 1.602 seconds, Fetched: 6 row(s)
```
HDFS文件内容
```
WZB-MacBook:50_bigdata wangzhibin$ hadoop fs -ls -R /user/hive/warehouse/hive_1.db/wc
-rwxr-xr-x   1 wangzhibin supergroup         63 2019-05-27 21:09 /user/hive/warehouse/hive_1.db/wc/test.txt
WZB-MacBook:50_bigdata wangzhibin$ hadoop fs -cat /user/hive/warehouse/hive_1.db/wc/test.txt
hello man
what are you doing now
my running
hello
kevin
hi man
```
### 使用HQL统计单词
```
hive> select split(txt,' ') from wc;
OK
["hello","man"]
["what","are","you","doing","now"]
["my","running"]
["hello"]
["kevin"]
["hi","man"]
Time taken: 0.337 seconds, Fetched: 6 row(s)
hive> select explode(split(txt,' ')) from wc;
OK
hello
man
what
are
you
doing
now
my
running
hello
kevin
hi
man
Time taken: 0.094 seconds, Fetched: 13 row(s)
hive> select t1.word,count(t1.word) from (select explode(split(txt,' '))word from wc)t1 group by t1.word;
WARNING: Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. tez, spark) or using Hive 1.X releases.
Query ID = wangzhibin_20190527214319_1532be66-b6e5-4603-83a9-dc4c7d6ec466
Total jobs = 1
Launching Job 1 out of 1
Number of reduce tasks not specified. Defaulting to jobconf value of: 1
In order to change the average load for a reducer (in bytes):
  set hive.exec.reducers.bytes.per.reducer=<number>
In order to limit the maximum number of reducers:
  set hive.exec.reducers.max=<number>
In order to set a constant number of reducers:
  set mapreduce.job.reduces=<number>
Starting Job = job_1558964487152_0004, Tracking URL = http://WZB-MacBook.local:8088/proxy/application_1558964487152_0004/
Kill Command = /Users/wangzhibin/00_dev_suite/50_bigdata/hadoop/bin/hadoop job  -kill job_1558964487152_0004
Hadoop job information for Stage-1: number of mappers: 1; number of reducers: 1
2019-05-27 21:43:25,976 Stage-1 map = 0%,  reduce = 0%
2019-05-27 21:43:31,173 Stage-1 map = 100%,  reduce = 0%
2019-05-27 21:43:36,365 Stage-1 map = 100%,  reduce = 100%
Ended Job = job_1558964487152_0004
MapReduce Jobs Launched:
Stage-Stage-1: Map: 1  Reduce: 1   HDFS Read: 8923 HDFS Write: 294 SUCCESS
Total MapReduce CPU Time Spent: 0 msec
OK
are	1
doing	1
hello	2
hi	1
kevin	1
man	2
my	1
now	1
running	1
what	1
you	1
Time taken: 17.562 seconds, Fetched: 11 row(s)

```
小插曲：[执行结果未出来的原因是：没有启动yarn]
## 总结
```
split--------------------------列变数组
explode------------------------数组拆分成多行
group by和count----------------对行分组后求各行出现的次数
```

## 参考资料：
1. [Hive实现wordcount词频统计](https://blog.csdn.net/pengzonglu7292/article/details/79044740)
