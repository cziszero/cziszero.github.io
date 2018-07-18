---
layout: post
title: 假设检验
description: 趁着给女票解决一个问题的时候复习一下假设检验。
date: 2017-03-09
categories: 
  - 课程
  - 概率论
tags:
  - 概率论
---

基本任务是，在总体的分布函数完全未知或者只知形式不知参数的情况下，为了推断总体的某些性质，
首先提出某些关于总体的假设，然后根据样本提供的信息对所提出的假设做出“是”或“否”的结论性论断。

# 假设检验的基本思想、概念与方法

## 基本思想
实际推断原理，即小概率时间在一次试验中不会发生。

## 概念
+ **原假设$H_0$，备选假设$H_1$**。
 - **奈曼-皮尔逊范式(Neyman-Pearson)**:在控制第一类错误概率$\alpha$的前提下，尽量犯使第二类错误的概率$\beta$尽量小。 因此，原假设$H_0$使被保护的，只有条件足够强时才拒绝$H_0$,因此原假设的提出必须经过慎重考虑，一般情况下不可轻易拒绝。
 - **显著性水平$\alpha$**:在某个样本上做估计，犯第一类错误的概率$\alpha$称为该检验法$W$的显著性水平。
 - **检验水平**：显著性水平的上确界$sup\{\alpha\}$称为检验水平。
 - **简单假设和复合假设**：当$\Theta_0$或者$\Theta_1$为单点集即$H_0$或者$H_1$是一个分布而不是一族分布，则称为简单假设，
 否则称为复合假设。
 - **参数假设检验和非参数假设检验**：参数假设检验即对未知参数提出假设，再根据样本进行检验。非参数假设检验例如对未知分布的假设，检验两个分布是否相同（女票的问题即是这类问题，检验元话语在两个语料库中的分布是否相同以得到是否有使用差异的结论），是否独立等。
+ **拒绝域（检验法）$W$**。 即拒绝$H_0$的条件。一个拒绝域决定一个检验法，反之亦然。
+ **检验统计量$T$**。用于进行检验的统计量。选择统计检验量首先要知道其分布。
+ **第一类错误和第二类错误**。第一类错误即弃真，第二类错误即取伪。

## 方法
### 临界值法
**步骤：**
1. 根据问题的实际情况，合理建立原建设$H_0$及备选假设$H_1$
2. 选定检验统计量$T$并分析拒绝域的形式
3. 给定显著性水平$\alpha$，在$H_0$下求出临界值，确定出拒绝域$W$
4. 取样，根据样本观察值是否落入$W$中做出是否拒绝$H_0$的判断

### p值法
**步骤**
1. 1~2步于临界值法相同。
2. 计算满足$H_0$时,对于样本$T$的观察值
  $t_0$，
3. 计算出$p={\sup \limits_{\theta\in{\Theta}_0} P_{\theta}(T>t_0)}$
4. 对于给定的显著性水平$\alpha$，如果出现$p<\alpha$，则拒绝$H_0$，否则接受。

**直观含义**
$p$描述了原假设成立时，出现比观测到的情况更极端的概率。

# 检验方法
## 对数似然比检验
这个就是女票的问题。重新表述下问题：现有两个语料库A和B，现想要探究某个词w在语料库A和B中的分布是否相同。
对数似然比的方法由Ted Dunning在[Accurate Methods for the Statistics of Surprise and Coincidence](../docs/HypothesisTesting/Accurate_Methods_for_the_Statistics_of_Surprise_and_Coincidence.pdf)中提出。下面重新回顾一下。Comparing Corpora using Frequency Profiling
### 对数似然比检验的概念
对于两个假设可信程度的指标，一个比较自然的度量是两个假设的似然比。
由此引出似然比检验的方法。
对于在假设$H_0$和
$H_1$上的似然比：

$L_{\Theta_0}(x)=\sup_{\theta\in\Theta_0}f(x,\theta)$

$L_{\Theta_1}(x)=\sup_{\theta\in\Theta_1}f(x,\theta)$

考虑其比值

${\lambda}=\frac{L_{\Theta_0}(x)}{L_{\Theta_1}(x)}$

如此比值较大，则说明真参数在$\Theta_0$
内的可能性更大，我们倾向于则接受$H_0$，反之亦然。
在实际中，常使用$L_{\Theta}(x)$代替分母
${L_{\Theta_1}(x)$来方便计算。

此即为次然比检验的直观理解，详细定义参见[附件](../docs/HypothesisTesting/HypothesisTesting_zhangweiping.pdf)

### Accurate Methods for the Statistics of Surprise and Coincidence笔记
1. 
> 以前使用asymptotic normality assumptions（渐进正态分布假设），但该假设在rare events（罕见事件）中能力不足，


然而真实文本中有很多rare events（例如只出现了几次的词语）。相似比检验在相对较小的样本上有更好的结果。
感觉应该是${\chi}^2$检验在rare events时出现问题，因为${\chi}^2$检验要求频数要>5，总量要大于10(一说40)，
下面列举了${\chi}^2$检验的前提：[来源](https://cos.name/cn/topic/408990/)
  + Quantitative data.
  + One or more categories.
  + Independent observations.
  + Adequate sample size (at least 10).
  + Simple random sample.
  + Data in frequency form.
  + All observations must be used.

同时，根据${\chi}^2$检验的原理，即残差平方和，直观上来看${\chi}^2$检验也是可以应用与多种多样的分布，
并不是只可以应用于正态分布。另外，为何残差平方和符合${\chi}^2$分布是没有解决的问题。

2. 现假设整个语料库中单词w出现的次数为二项分布，每个词是否出现该单词w为伯努利分布。
本假设成立基于另两个事实，即一、每个单词的出现显然不是独立的，但这种相互影响会随着距离的增加儿急剧减小。
二、假设中某个单词的概率是不变的，这在一定程度上是不对的，因为单词的概率显然是领域相关的。
但对于某个领域的语料库，我们是可以这样认为的。

3. 二项分布在n->oo时与正态分布类似。文中认为$np(1-p)>5$时，二项分布与正态分布已经相同。

4. 二项分布的对数似然比$\lambda$具有一个重要的特性，即$-2\log{\lambda}$符合自由度为$\Theta$和
$\Theta_0$的维度差的${\chi}^2$分布。这就是本文主要利用的思想。

### 总结 
本文描述了关于假设检验的一些概念和方法，主要介绍了对数似然比检验及其在检验某个单词在两个语料库中分布是否相同的应用，
对假设检验的理解更加深刻了一下，假设检验产生的目的是为了验证观察是否具备某个性质以及在多大程度上具备，
其方法是将这个问题转化为假设统计量的分布问题，预先知道假设统计量的分布特性，通过求解其观察值来得到其可信度，像${\chi}^2$检验是残差平方和除以np符合${\chi}^2$分布，本文提到的二项分布的对数似然比$\lambda$的函数$-2\log\lambda$
也是符合${\chi}^2$分布。

# 参考

1. [Accurate Methods for the Statistics of Surprise and Coincidence](../docs/HypothesisTesting/Accurate_Methods_for_the_Statistics_of_Surprise_and_Coincidence.pdf)
2. [Comparing Corpora using Frequency Profiling](../docs/HypothesisTesting/Comparing_Corpora_using_Frequency_Profiling.pdf)
3. [张伟平老师的课件Lec18](../docs/HypothesisTesting/Hypothesis_test_zhangweiping_Lec18_slides.pdf)
4. [张伟平老师的课件Lec11](../docs/HypothesisTesting/HypothesisTesting_zhangweiping.pdf)
5. [人大假设检验课件](../docs/HypothesisTesting/Hypothesis_test_人大课件.ppt)
6. [复旦大学卡方检验](../docs/HypothesisTesting/卡方检验复旦.ppt)
6. [卡方检验 百度百科](http://baike.baidu.com/item/%E5%8D%A1%E6%96%B9%E6%A3%80%E9%AA%8C)
6. [二项分布、泊松分布、正态分布的关系](http://hongyitong.github.io/2016/11/13/%E4%BA%8C%E9%A1%B9%E5%88%86%E5%B8%83%E3%80%81%E6%B3%8A%E6%9D%BE%E5%88%86%E5%B8%83%E3%80%81%E6%AD%A3%E6%80%81%E5%88%86%E5%B8%83/)