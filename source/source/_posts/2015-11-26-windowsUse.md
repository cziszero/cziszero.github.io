---
layout: post
title: windows下一些常用软件的配置
description: 总结一些cmd常见命令
date: 2015-11-26
categories: 
  - 软件安装和使用
tags:
  - 软件安装和使用
---
##打开服务
services.msc

##使用桌面版onenote时，绘图模式自动变为键入模式
使用桌面版onenote时，用笔绘图时，绘图模式老是自动变为键入模式，表现为
第一笔可用，然后变为选中框，然后又变为笔，苦寻多处设置无果，最后查到是
因为打开了bing词典的划译功能，取消即可。同适用于打开了有道词典划译功能
的环境。

##notepad++有红色下划线
菜单栏---插件---DSpellCheck然后将勾选的去掉即可。

##notepad++添加对makedown（md）格式的支持
[参见](http://chaopeng.me/blog/2013/01/25/markdown-npp.html)
简略：将[配置文件userDefineLang.xml](../docs/userDefineLang.xml)复制到`%APPDATA%\Notepad++`即可。

##高分屏下netbeans菜单字太小的解决办法
找到netbeans的安装目录，在etc 目录找到netbeans.conf 文件。打开文件，找到`netbeans_default_options`的配置项。
在最后加上  `--fontsize 22`,然后重新启动netbeans即可。[参考](http://jingyan.baidu.com/article/046a7b3ef9185ff9c27fa91f.html)

##VS2013中文带红色下划线
代码中中文会带红色下划线，因为在VisualAssist X设置了拼写检查，取消拼写检查即可。
打开Visual AssistX Options，找到`underline spelling errors in comments and string using`，
取消选中该项即可。

##禁止某软件运行
1、按windows+R，在运行框中输入“gpedit.msc”，打开组策略。
2、选择“用户配置”-“系统”，在右侧双击“不要运行指定的Windows应用程序”，打开属性页，点击“已启用”，点击“显示”，
输入要禁用的程序名称（主运行程序名称，不需要加路径），例如notepad.exe然后点一直点确定，完成设置。