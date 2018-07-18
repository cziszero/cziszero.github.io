---
layout: post
title: C语言中的一些问题
description: 记录在C语言中遇到的一些问题
date: 2015-09-14
categories: 
  - 语言
  - C/C++
tags:
  - 语言
---

##	C语言中的变量声明与定义
	int a = 10;
	int a;
	int a;
	int  main(){
		int b = 11;
		int b;
		printf("%d",a);
	}
编译过程中全局变量a并不会报错，但局部变量b会报error：redeclaration of 'b' with no linkage.

##	奇怪的函数定义
	freename(s)
	char    *s;
	{
	  if( Namep > Names )
		*--Namep = s;
	  else
		fprintf (stderr, "%d: (Internal error) Name stack underflow\n", 10 );
	}

##	命令行参数
`int main( int argc, char **argv )`中argc为命令行参数的个数，至少为1，`**argv`代表的命令行输入的参数，
第一个为程序本身。

##64位编译时，每个指针为8bytes
	const char * stra = "helloworld";
	const char strb[] = "helloworld";
结果为：
	sizeof(str) = 8//字符指针长度
	sizeof(*str)= 1//char类型长度
	sizeof(strb) = 11//字符数组长度
	
##C语言中类型的解释的问题
问题起源是写了一个将IEEE 754标准表示的16进制串转化为float输出的小程序（只是想偷懒不手算。。），
代码如下，但没想到的是这个小程序带来了挺多的麻烦。
	unsigned int e = 0xBFC00000;
	printf("p\n",e);
	printf("e = %f\n",e);
程序输出
	`BFC00000
	e = 0.000000`
这个输出看看就行，因为我发现上下文环境不同这个输出竟然也是不同的！！！
联想到之前看到的一篇文章，感觉应该是`printf`的问题。
之后搜索发现了这个[网页](http://www.ruanyifeng.com/blog/2010/06/ieee_floating-point_representation.html)
找到了正确的方法，即如下的代码：
	unsigned int e = 0xBFC00000;
	float * b = &e;
	printf("%p\n",e);
	printf("e = %f\n",e);
	printf("*b = %f \n",*b);
	*b = 1.75;
	printf("%p\n",e);
	printf("e = %f\n");
	printf("*b = %f \n",*b);
输出的是：
	`BFC00000
	e = 0.000000
	*b = -1.500000
	3FE00000
	e = -1.500000
	*b = 1.750000`
这下正常了，IEEE 754标准的二进制串可以转换成浮点数输出，浮点数也可以转换成IEEE 754标准的二进制串输出。
并且还有意外收获，观察第5行输出，发现其输出竟然与第三行输出一样，回想到上面说的`printf`上下文相关，
竟然就是这么相关，进一步验证得到如下代码：
	printf("e = %f\n",10.0);
	printf("e = %f\n");
	printf("a = %d %d\n",11,12);
	printf("a = %d %d \n");
输出的是：
	`e = 10.000000
	e = 10.000000
	a = 11 12
	a = 11 12`
我勒个去，`printf`格式化出错的话竟然会直接把上次输出队列中的重新输出一下，这是我之前没想到的。
通过这次实验就学到两个知识，一是C中对地址的解释是按照指针的定义进行的，声明成什么样的指针就会
按照什么类型进行解释。二是上面说的关于`printf`的问题。
