---
layout: post
title: 各种常用软件的安装和配置
description: 
date: 2015-09-19
categories: 
  - 软件安装和使用
tags:
  - 软件安装和使用
---

## VS2013	GLUT配置

### 下载
[下载链接](https://www.opengl.org/resources/libraries/glut/glutdlls37beta.zip)
### 配置
glut.dll glut32.dll ==> C:\Windows\SysWOW64<br/>
glut.h ==>C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\include\gl<br/>
glut32.lib glut.lib ==> C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\lib<br/>
### 测试
	#include <gl\glut.h>

	void myDisplay(void) {
		glClear(GL_COLOR_BUFFER_BIT);
		glRectf(-0.5f , -0.5f , 0.5f , 0.5f);
		glFlush();
	}

	int main(int argc , char *argv[]) {
		glutInit(&argc , argv);
		glutInitDisplayMode(GLUT_RGB | GLUT_SINGLE);
		glutInitWindowPosition(100 , 100);
		glutInitWindowSize(400 , 400);
		glutCreateWindow("第一个OpenGL程序");
		glutDisplayFunc(&myDisplay);
		glutMainLoop();
		return 0;
	}
	
另外，[Windows下为mingw安装OpenGL环境（GLUT)](http://www.bubuko.com/infodetail-652188.html)