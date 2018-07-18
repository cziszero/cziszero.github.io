---
layout: post
title: ML课程总结
description: 
date: 2017-12-24
categories: 
  - 课程
  - 机器学习
tags:
  - 机器学习
---

# 强化学习

## bellman方程
$$V_T^\pi(x) = \sum_{a \in A} \pi(x,a) \sum_{x' \in X} (\frac{1}{T}R_{s,s'}^{a}+\frac{T-1}{T}P_{s,s'}^aV_{T-1}^\pi(x')$$
$$Q_T^\* = \sum_{x' \in X} (\frac{1}{T}R_{s,s'}^{a}+\frac{T-1}{T}P_{s,s'}^aV_{T-1}^\pi(x')$$
## bellman最优方程
$$V_T^\pi(x)(s) = 
\max_{a \in A} \sum_{x' \in X} (\frac{1}{T}R_{s,s'}^{a}+\frac{T-1}{T}P_{s,s'}^aV_{T-1}^\pi(x') \\
=\max_{a \in A}Q^\*_{T-1}(x,a)$$
$$
Q_T^\*(x,a) = \sum_{x' \in X} (\frac{1}{T}R_{s,s'}^{a}+\frac{T-1}{T}P_{s,s'}^a' \max_{a' \in A}Q^\*_{T-1}(x,a')
$$