---
layout: post
title: MultiBoosting A Technique for Combining Boosting and Wagging 阅读笔记
description: 
date: 2017-11-28
categories: 
  - 论文阅读笔记
  - ensemble
tags:
  - ML
  - ensemble
---

# Abstract
# Introduction
# AdaBoost and bagging
## bagging
在二项分布的伯努利试验中，如果试验次数$n$很大，二项分布的概率$p$很小，且乘积$λ= np$比较适中，则事件出现的次数的概率可以用泊松分布来逼近。事实上，二项分布可以看作泊松分布在离散时间上的对应物。
有放回取样，形成的概率分布是离散泊松分布
## wagging
将有放回取样改为分布不同权重，以利用所有的训练样本。权重是连续泊松分布的随机变量，然后再将权重的和标准化为n。
## Adaboost
调整权值比按比例取样更有效。

# Bias and variance
Bias和Variance分解对分类任务不很容易。
在x相同则y相同的假设下，noise为0。

# Previous bias/variance analyses of decision committee performance
Bagging可以降低varance，可以认为是因为bagging本身就是取的很多个小模型的均值。因此，不能降低Bias也就可以理解了。
*AdaBoost可以认为是一个逻辑回归的过程，只降低bias*，但实际上AdaBoost既可以降Varance，又可以降Bias，至于为什么，没有一个一致的结论。
# Alternative accounts of decision committee performance
# MultiBoosting
bagging主要降低variance，AdaBoost既降低variance也降低bias（论文），主要关注降低bias（周志华西瓜书）。bagging在降低variance方面比AdaBoost更有效。
*most of the effect of each approach is obtained by the first few committee members*

bagging无法使用所有的训练样本来训练，所以采用了wagging。
bagging可以并行，AdaBoost必须串行。

## 算法流程
**输入**：
$S$：有$m$个样本的训练集  
BaseLearn：基学习算法  
$T$：迭代次数  
$I_i$：第$i$次迭代中，bagging的基学习器的个数

**算法流程**：
```
S'=S，权重都为1
k=1
for t = 1 to T:
  if I
```
# Evaluation
Adaboost和bagging算法性能的提升在前几次迭代中就完成了，后面的迭代提升很小。
总共进行100次迭代，大致分成10段，每次boosting的基准被10，可能提前结束，也可能推迟结束。
最后将训练的着100次进行加权，整个过程是Boosting的过程，但中间有重新开始的动作，所以也是几个Adaboost组成了一个bagging。
在bagging内部，每个Adaboost的权重是相同的。
## Data sets
## Statistics employed
## Error rates
## Wagging and bagging restarts in AdaBoost
# Bias/variance analysis of performance
## Comparison of MultiBoost t = 100 against AdaBoost t = 10
## On the optimal number of sub-committees
## The application of bagging and wagging in MultiBoost
# Summary
# Appendix A: Bias and variance measures for classification learning
# Appendix B: A bias/variance estimation method
# Appendix C: Detailed results