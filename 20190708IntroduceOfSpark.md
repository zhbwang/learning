# 初步认识 Spark

## Spark 概述

官方的定义：Apache Spark™是用于大规模数据处理的统一分析引擎。
> Apache Spark™ is a unified analytics engine for large-scale data processing.

1. Spark 是基于内存的分布式计算框架，计算速度很快，但是不涉及存储，Spark 的存储是通过对接外部数据源的（如：HDFS）
2. Spark 是类似于 MapReduce 的并行计算框架，Spark 也是基于 MapReduce 算法实现的分布式计算，拥有 MapReduce 的优点，但不同的是：Spark 中 Job 中间输出和结果可以保存在内存中，不再需要读写 HDFS，因此 Spark 能更好的适用于数据挖掘和机器学习等需要迭代的MapReduce算法。
3. Spark 是 MapReduce 的替代方案，而且兼容 HDFS、Hive，可以融入Hadoop 的生态系统中，以弥补 MapReduce 的不足。

## 为什么要学习Spark

中间结果输出：基于MapReduce的计算引擎通常会将中间结果输出到磁盘上，进行存储和容错。出于任务管道承接的，考虑，当一些查询翻译到MapReduce任务时，往往会产生多个Stage，而这些串联的Stage又依赖于底层文件系统（如HDFS）来存储每一个Stage的输出结果。

Spark是MapReduce的替代方案，而且兼容HDFS、Hive，可融入Hadoop的生态系统，以弥补MapReduce的不足。

## Spark的四大特性

### 高效性
运行速度提高100倍。

Apache Spark 使用最先进的DAG调度程序，查询优化程序和物理执行引擎，实现批量和流式数据的高性能。

![](http://pic.iloc.cn/15625711820438.jpg)


### 易用性

Spark支持Java、Python和Scala的API，还支持超过80种高级算法，使用户可以快速构建不同的应用。而且Spark支持交互式的Python和Scala的shell，可以非常方便地在这些shell中使用Spark集群来验证解决问题的方法。

![](http://pic.iloc.cn/15625712258616.jpg)


### 通用性

Spark提供了统一的解决方案。

Spark可以用于批处理、交互式查询（Spark SQL）、实时流处理（Spark Streaming）、机器学习（Spark MLlib）和图计算（GraphX）。这些不同类型的处理都可以在同一个应用中无缝使用。

Spark统一的解决方案非常具有吸引力，毕竟任何公司都想用统一的平台去处理遇到的问题，减少开发和维护的人力成本和部署平台的物力成本。

![](http://pic.iloc.cn/15625712755990.jpg)


### 兼容性

Spark可以非常方便地与其他的开源产品进行融合。

比如，Spark可以使用Hadoop的YARN和Apache Mesos作为它的资源管理器和调度器，并且可以处理所有Hadoop支持的数据，包括HDFS、HBase和Cassandra等。

这对于已经部署Hadoop集群的用户特别重要，因为不需要做任何数据迁移就可以使用Spark的强大处理能力。

Spark也可以不依赖于第三方的资源管理和调度器，它实现了Standalone作为其内置的资源管理和调度框架，这样进一步降低了Spark的使用门槛，使得所有人都可以非常容易地部署和使用Spark。

此外，Spark还提供了在EC2上部署Standalone的Spark集群的工具。

![](http://pic.iloc.cn/15625712933167.jpg)



* Mesos：Spark可以运行在Mesos里面（Mesos 类似于yarn的一个资源调度框架）
* standalone：Spark自己可以给自己分配资源（master，worker）
* YARN：Spark可以运行在yarn上面
* Kubernetes：Spark接收 Kubernetes 的资源调度


## Spark的组成

Spark组成(BDAS)：全称伯克利数据分析栈，通过大规模集成算法、机器、人之间展现大数据应用的一个平台。也是处理大数据、云计算、通信的技术解决方案。

它的主要组件有：

1. SparkCore：将分布式数据抽象为弹性分布式数据集（RDD），实现了应用任务调度、RPC、序列化和压缩，并为运行在其上的上层组件提供API。

2. SparkSQL：Spark Sql 是Spark来操作结构化数据的程序包，可以让我使用SQL语句的方式来查询数据，Spark支持 多种数据源，包含Hive表，parquest以及JSON等内容。

3. SparkStreaming： 是Spark提供的实时数据进行流式计算的组件。

4. MLlib：提供常用机器学习算法的实现库。

5. GraphX：提供一个分布式图计算框架，能高效进行图计算。

6. BlinkDB：用于在海量数据上进行交互式SQL的近似查询引擎。

7. Tachyon：以内存为中心高容错的的分布式文件系统。

## 参考资料


1. [Spark简单介绍&安装步骤 - superWe的博客 - CSDN博客](https://blog.csdn.net/qq_34795664/article/details/79946527)
2. [Spark学习之路 （一）Spark初识 - 扎心了，老铁 - 博客园](https://www.cnblogs.com/qingyunzong/p/8886338.html#_label2)

## ChangeLog

* 20190708 | 创建文档