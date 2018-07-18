---
layout: post
title: tensorflow变量初始化
description: 
date: 2018-06-03
categories: 
  - [tensorflow]
tags:
  - tensorflow
---

# tensorflow变量初始化的方式
使用`tf.Variable()`创建或`tf.get_variable()`创建，但初始化有所不同。
如下图所示代码：
```python
init = tf.truncated_normal([3, 1], stddev=0.1)
va = tf.Variable(init)
vb = tf.Variable(init)
###############
init = tf.random_normal_initializer(0., 0.3)
w1 = tf.get_variable('w1', [3,], initializer=init)
w2 = tf.get_variable('w2', [3,], initializer=init)
```
使用第一种方法创建出来的`va`和`vb`变量的值是相同的，使用第二种方法创建出来的变量`w1`和`w2`的值是不相同的。
具体的这两种方法及还有没有其他的方法还需要再看下。
