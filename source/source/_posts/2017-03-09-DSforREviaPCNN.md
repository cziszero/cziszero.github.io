---
layout: post
title: Distant Supervision for Relation Extraction via Piecewise CNN论文阅读笔记
description: 
date: 2017-03-09
categories: 
  - 论文阅读笔记
  - Relation Extraction
tags:
  - Relation Extraction
---

## Abstract

+ DS的问题
  - 错误标注
  - 提取出的特征中的错误进行传导
+ 新模型
  - 当作一个多例问题（multi-instance），每一个标签实例带一个置信度
  - 使用PCNN(Piecewise CNN)避免第二个问题，更改了网络结构（piecewise max pooling）而不是进行了特征工程，
