---
layout: post
title: python环境配置
description: 记录常用的python环境配置
date: 2016-02-22
categories: 
  - [语言 , Python]
tags:
  - python 
  - 环境配置
---

##	将wing的自动补全改为回车(Enter)键入

依次点选Edit\Perference\Editor\Auto-completion，找到Completion Keys，选中Enter即可

##	安装pip

从[pip](https://pip.pypa.io/en/stable/installing/)官网下载`get-pip.py`，然后`python get-pip.py`即可自动安装pip，一般会安装pip到
`C:\Python34\Scripts`，将其添加到path中，之后即可使用pip进行python库的安装。

##	安装requests

[requests](http://docs.python-requests.org/zh_CN/latest/user/quickstart.html]): `pip install requests`

##	安装BeautifulSoup

[BeautifulSoup](http://www.crummy.com/software/BeautifulSoup/bs4/doc/index.zh.html) : 	`pip install beautifulsoup4`