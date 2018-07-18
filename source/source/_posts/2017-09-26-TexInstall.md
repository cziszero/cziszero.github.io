---
layout: post
title:  TexLive的安装
description: 
date: 2017-09-26
categories: 
  - [软件安装和使用]
tags:
  - Tex
  - 软件安装和使用
---

# 安装

## linux下的安装
linux下安装Texlive还是比较简单的，参照[Quick install](http://tug.org/texlive/quickinstall.html)即可，分为下面几步：
1. 清理环境
2. 下载运行[安装器](http://tug.org/texlive/)，注意此处可以选择安装模式，下载服务器（不过我实验了一下好像没有用）
3. 安装完成后记得设置环境变量
4. 运行`latex sample2e.tex`实验一下看是否成功。
更详细的可以看[中文安装文档](https://www.tug.org/texlive/doc/texlive-zh-cn/texlive-zh-cn.pdf)，还包含了各目录的说明等。

## Windows下的安装
直接去[ctex](http://www.ctex.org/CTeXDownload)下载安装即可。

# 中文支持
方案1. 使用ctex宏包，latex编译；
方案2. 使用XeLaTeX + UTF-8编码的源文件；
方案一实验了可行，但方案二好像不行。