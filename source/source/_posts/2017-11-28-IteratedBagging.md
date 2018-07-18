---
layout: post
title: Using Iterated Bagging to Debias Regressions 阅读笔记
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

bagging 可以显著的降低variance，但无法降低bias。
第一步bagging，然后进行boosting。
实验使用了tree和nearest neighbor regression来测试。

# Introduction

回归问题的泛化误差=随机噪声+预测bias+预测variance
通常决策树越小，bias越大。

# The basic idea
# Iterated bagging-more details

令$y=f(x)+\epsilon$，其中$\epsilon$表示固有的均值为0的噪声，则
$$y_n'=\epsilon+f(x_n)-f_R(x_n,T)$$
即表示预测的偏差bias，但是在$f_R(x_n,T)$有较大方差的时候，就会对结果造成干扰，就无法表示预测的bias了。所以应该找一个**低方差的回归算法**。
但还有一个问题，应该使用一个残差的无偏估计，这里作者认为留一验证所得的残差是无偏的，而使用bagging中的袋外样本进行的对残差的估计恰好是无偏的。
所以算法框架为：
1. 在每个阶段首先执行bagging，即重复训练$K$个predictor，在该阶段使用的$y$记作$y^i$,可以发现$y^1$即为最开始的y值。记第$k$个predictor的输出为$\hat{y}_{n,k}$为第$k$个predictor对第$n$个样本点的输出。记作$f_R^i(x,T)$
2. 生成下一阶段的新训练集$T_{(i)}$，$x$不变，$y$使用$y^{i+1}=y^{i}-avg_k\{\hat{y}_k\}$计算得到，$avg_k$的含义是不适用该样本点作为训练集的predictor预测的结果的平均。
当某个阶段的MSE大于以前所有阶段MSE的1.1倍时，则停止，

# Bias-variance results on synthetic data
## Recalling the bias-variance decomposition 偏差方差分解

偏差方差分解：
predictor的误差可以表示为：
$$PE^* = E(\epsilon^2)+E(f(x)-\overline{f}(x))^2+E(f_R(x)-\overline{f}(x))^2$$
其中，$f(x)$是真实值，
$\overline{f}(x)$ 是预测值的均值，
$f_R(x)$是预测值。
第一项表示噪声，第二项表示bias，第三项表示variance。

Breiman证明了如果在独立的训练集上做无限次取样，则最终的方差为0，但偏差不变。

## Bias and variance for synthetic data
# Empirical results
## Comparison to SVRMs
# Some heuristic theory 一些启发式理论
# Nearest neighbor bagging and debiasing
# Using small trees as predictors
# Debiasing applied to classification
# Connection with Friedman’s work
# Discussion