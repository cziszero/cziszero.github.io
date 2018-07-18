---
layout: post
title: Traffic Engineering Based on Stochastic Model Predictive Control for Uncertain Traffic Change 论文阅读笔记
description: 
date: 2017-09-19
categories: 
  - 论文阅读笔记
  - ML方法应用于网络
tags:
  - ML方法应用于网络
---
## 概括
在使用MPC(Model Predictive Control)做TE(Traffic Engineering)时，可能某次流量预测并不准确而按照这个准确的值进行调教反而导致了网络拥塞，因此Otoshi提出相应的改进方法，即将预测错误的概率考虑进去，用一个高斯分布来描述预测错误的概率，从而将问题转化为一个在发生拥塞的可能性小于给定阈值的约束下的减少网络变化的优化问题。同时，作者基于越远时间的预测可能越不准，而其阈值也应该更加宽松提出了Relax的操作。实验证明，论文中提出的方法对于减少由预测错误导致的网络拥塞问题有效果。

## Meta-Data
* 发表期刊：2015 IFIP/IEEE International Symposium on Integrated Network Management (IM)
* 作者：Otoshi, Tatsuya; Ohsita, Yuichi; Murata, Masayuki; Takahashi, Yousuke; Ishibashi, Keisuke; Shiomoto, Kohei; Hashimoto, Tomoaki;
* 年份：2015

## 前提
*对route的更改，一次大的更改比多次小的更改代价更大。在考虑错误信息之后，确实是改的频繁了，但大的更改少了。但从表1中，加了relax的最大值比不加relax的反而大了，但改的不那么频繁了，所以。。到底是想干什么呢？*

## I. Introduction

本篇论文的核心是TE method that is robust to prediction errors，
SMP-TE can avoid the congestion under limited resources and the existence of prediction error。
有两个目标：  
1. 减少因预测错误导致的拥塞
2. 对链路的更改尽量小


把TE问题看作一个在发生拥塞的可能性小于给定阈值的约束下的减少网络变化的优化问题。
考虑预测错误概率分布的MPC就叫做stochastic MPC(SMPC)，应用于TE，本文中称之为stochastic model predictive traffic engineering (SMP-TE)。

## II. dynamic traffic engineering  
TE的步骤：  
1. 获取traffic信息
2. 在这些信息的基础上计算路由
3. 应用这些路由结果

使用$x(t-1)$代替$x(t)$来计算分配方案，使得容易出现问题。解决方法之一是让t变小，从而一段时间之内的可以看作变化不大，但这样频繁的调整网络有代价。另一种方式是预测t时刻的流量来进行规划，但预测不一定对，所以本篇论文引入了预测错误的分布。

## III. SMP-TE: Stochastic Model Predictive Traffic Engineering  
### A. Stochastic Model Predictive Control  
#### 1) Model Predictive Control  
1. 要和目标$y(k)$尽可能的接近，所以引入代价函数$J_1=\sum_{k=t+1}^{t+h}{||y(k)-r_y(k)||^2}$
2. 还要尽可能的平缓，所以引入$J_2=\sum_{k=t+1}^{t+h}{||u(k)-u(k-1)||^2}$，*感觉这里不太对，应该是$\hat{y}(k)-\hat{y}(k-1)$吧*
3. 所以总的代价为$J=(1-w)J_1+wJ_2$

#### 2) Probability Constraints  
使用上面说的引入预测来改进使用$x(t-1)$代替$x(t)$来计算分配方案的问题时，又引入了一个新的问题，即预测错了怎么办？一种方法是按最坏的情况配置冗余，还有一种方法是讲错误的发生作为一个随机变量，为了克服这个错误需要配置的冗余也变成一个随机变量，这样就引入一个soft bound，可以给定一个阈值和容量上限，这样最大的可通行流量就可以确定出来。

### B. Applying SMPC to TE  
#### 1)	TE Model for SMPC  
1. 预测traffic rates
2. 根据预测进行规划，使$J$最小

#### 2)	Formulation of the Optimization Problem  
求解一个给定阈值$p$和链路容量$C$，使其发生拥塞的概率小于$p$的条件下，使改变幅度尽量小的方案。

#### 3) Relaxation of Future Probabilistic  
注意，代价函数是在多个调节轮次上定义的，虽然只用于调节当前的这一次。可以发现，预测显然是紧邻的下一个最靠谱也最重要，其他的预测就不那么靠谱也没有那么重要了，因为之后会有反馈修正，这样还是要求他们具有相同的拥塞的概率就不合适了，可以把这个概率$q$逐渐放宽。论文中使用了$q(k)=(1-p)exp(-\frac{k-t-1}{\tau})$来设定概率阈值，$\tau$是可以设定的决定松弛素的常数。当$q(k)>0.5$时则不再上升，置为$0.5$

## IV. Evaluation  
### A. Simulation Environment  
#### 1)	network topology  
#### 2)	traffic  
使用Netflow协议收集，100个包取样一次，5分钟汇总一次。设置的目标利用率为95%。

#### 3)	prediction error model
假设预测错误服从高斯分布。其均值为0，方差与多少步成正比$k\sigma ^2$，使用normalized mean squared error (NMSE)来计算$\sigma ^2$，$NMSE=\frac{\sigma_j^2}{V[x_j(t)]}$，这里取$NMSE=0.3$，所以令$\sigma_j^2=0.3V[x_j(t)]$，$j$是表示第几条路由。

#### 4)	Cost Function  
使用平均hop length作为代价函数，因为降低hop length可以降低传播时延（propagation delay），相对于传播时延，在排队延时（queuing delay ）可以忽略不计。
平均hop length D定义为$D=\frac{1}{F}\sum_j{\sum_{i\in \vartheta }{R_{i,j}d_i}}$，使用正则化的hop length $\frac{D}{\max{X_jd_j}}$作为代价函数*前面说了一种代价函数呀，为什么还要有一个，这两个一样么？*。$w$最后选定0.5，因为实验中更改$w$从0到1，步长为0.1结果没啥变化。*没啥变化不是说明这个方法不大靠谱么。。。。*

#### 5)	Routing Calculation  
求解上面提到个约束，先将概率不等式转换为确定性的形式，$\forall k,\forall l,\hat y_l(k)+\Phi^{-1}(1-p)\sqrt{\sum_j{A_{l,j}(k)^2k\sigma_j^2}}\leq C_l(k)$，此处$A(k)=G · R(K)$,$\Phi^{-1}$是高斯分布的分位点函数（quantile function of the Gaussian distribution），通过这个变换之后，原问题就变成一个凸优化问题，叫做second-order cone programming (SOCP)，可以使用CPLEX包来求解该问题。

#### 6)	Compared Methods
1. 和只预测一步的模型进行对比，也就是对应本模型中的$h=1,p=0.5$的情况，以证明多步预测是游泳的。
2. 和基于MPC的TE方法进行对比，其基于多步预测，但并没有把预测错的的概率考虑进去，对应本模型$p=0.5$的情况，来证明本片论文中提出的方法是有效的，可以避免预测错的的影响而不造成明显的路由变化。

### B. Effect of Stochastic Constraint
第一步是比较一下看SMP-TE能不能减少因为预测错误导致的拥塞，使用99.9% delay来表示99.9%的包的延迟时间都小于此数值，使用M/M/1模型根据流量来计算延迟，公式为$-log(1-0.999)\frac{\bar L}{C_l-y_l}$,其中${\bar L}$表示包的平均长度。实验证明SMP-TE确实可以减少由预测错误导致的拥塞。

### C. Multi-Step Prediction Effect
来验证多步预测中可以让链路变化小的特性在SMP-TE中依然保持着。但引入预测错误之后，允许的阈值较小时需要预留较大冗余，也让两次之间的变化更大。

### D. Probability Relaxation Effect
*不论是从变得多少来看，还是变得是否频繁来看，这种方法都不比其他方法好啊。。。。*

### E. Scalability
SMP-TE的时间复杂度为$O(m^2n^6)$，$m$是链路数量，$n$是节点数量。

## V. Conclusion