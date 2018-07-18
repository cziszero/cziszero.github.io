---
layout: post
title: QFile 和 QTextStream 的问题
description:
date: 2016-03-12
categories: 
  - 类库
  - QT
tags:
  - QT
---

## QFile 和 QTextStream 的问题
通常我们会这样使用(本例来源于文档)：

	QFile data("output.txt");
	if (data.open(QFile::WriteOnly | QFile::Truncate)) {
		QTextStream out(&data);
		out << "Result: " << qSetFieldWidth(10) << left << 3.14 << 2.7;
		// writes "Result: 3.14      2.7       "
	}

但有次因为需要多次读相同的结构，我就把`QFile data`作为局部变量，`QTextStream out`作为成员，
这样导致的后果是前几个数据块读的很正常，但大概四五个之后就会出现内存错误。
分析发现，`QTextStream`大概相当于一个修饰者类，真正执行I/O的还是`QFile`类，因为`data`是局部变量，
所以函数退出后`data`就被销毁了，`QIODevice`没有了，所以后面再调用`out`读写的时候就会报内存错误。
而之所以前面还执行了几个正常的读函数是因为`QTextStream`有一个自己的缓冲区，这样指针还在缓冲区
内的时候就正常，超过缓冲区后就会报内存错。
表现特征上面已经说了，这个问题应该会在多个有缓冲区的类中出现。
还有就是对内存的分配和销毁要搞清楚，要不然还是容易出现这种问题。