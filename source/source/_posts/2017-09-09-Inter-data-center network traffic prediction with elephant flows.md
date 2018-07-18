---
layout: post
title: Inter-data-center network traffic prediction with elephant flows 论文阅读笔记
description: 
date: 2017-09-09
categories: 
  - 论文阅读笔记
  - ML方法应用于网络
tags:
  - ML方法应用于网络
---

## Inter-data-center network traffic prediction with elephant flows
## 阅读笔记

### 数据流
$M$个大象流，1个总体流量，总共工$M+1$，加上进出两个方向，所以对于某个时间点其原始数据维度为
$2M+2$，即$(ini,outi,eini1,eouti1,eini2,eouti2,...,einiM,eoutiM)$。
然后将$k$步时间窗口内的每一个维度作为时间序列进行小波变换成$w+1$个组分，作为ANN的输入特征，
此时共有$(w+1)(2M+2)$个维度（最终实验$w=1,M=5,k=$）。然后分别对某时间后的输入和输出流量分别进行预测。

### IV. EXPERIMENTAL RESULTS

1. 大象流5min取样一次，全部流量30s取样一次。
2. 大象流占总流量的80%，取top-5个大象流应用。
3. 一个输入层、一个隐藏层、一个输出层
4. ARIMA模型在短期预测（30s和1min）表现最好。
