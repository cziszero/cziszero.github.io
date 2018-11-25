---
layout: post
title: Relation Extraction Perspective from Convolutional Neural Networks 阅读笔记
description: 
date: 2017-04-17
categories: 
  - 论文阅读笔记
  - Relation Extraction
tags:
  - Relation Extraction
---

## Abstract

+ 使用多重窗口大小的卷积核multiple window sizes for filters 
+ 预先训练好的词向量作为非静态结构的初始值 pre-trained word embeddings as an initializer on a non-static architecture

## 1. Introduction

## 2. Related Work

## 3. Convolutional Neural Network for Relation Extraction

我们的CNN模型包含的主要层  
1. 把句子中包含的单词查表找词向量
2. 卷积层识别n-grams
3. pooling层决定最相关的特征
4. 一个逻辑回归层（softmax）来分类。(Collobert et al., 2011; Kim, 2014; Kalchbrenner et al., 2014)

![](/images/NRE/CNNforRE.jpg)

### Word Representation

## 符号表

| 符号 | 含义 |
| :---: | :---: |
| $n$ | relation mentions的长度 |
| $x_i$ | relation mention中的第i个词 |
| $x_{i1} x_{i2}$ | 两个实体 |
| $X_i$ | 句子中词向量表示 $X_i= [e_i,d_{i1},d_{i2}]$ |
| $X$ | 句子表示矩阵，维度$ (m_e + 2m_d) × n $ |
| $e_i$ | $x_i$的词向量，维度为$m_e$ |
| $m_e$ | 词向量的维度 |
| $W$ | 词向量字典 |
| $d_{i1} d_{i2}$| 位置向量 |
| $D$ | 位置向量字典 维度是$(2n − 1) × m_d$| 
| $w$ | 窗口大小 |
| $f$ | filter matrix 也就是卷积矩阵 $f = [f_1,f_2,...,f_w] $ ，其中 $f_i$ 是一个维度为$m_e + 2m_d$的列向量。 |
| augmented n-grams | n-grams accompanied with relative positions of its words |
| | |
