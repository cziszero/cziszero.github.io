---
layout: post
title: QPixmap类文档的部分翻译
description: 
date: 2016-02-28
categories: 
  - 类库
  - QT
tags:
  - QT
---
##翻译

##详细介绍
`QPixmap`是一个可以用来当作绘图设备的屏幕无关的图像表现类。

QT提供了`QImage`，`QPixmap`，`QBitmap` 和 `QPicture`四种处理图像数据的类。
`QImage`用来处理I/O并且可以直接操作每个像素。
`QPixmap`用来在屏幕上显示图像。
`QBitmap`只是继承自`QPixmap`确保深度为1的方便使用的类。
如果`isQBitmap()`返回true，则一个`QPixmap`对象确实是一个bitmap对象，否则返回false。
`QPicture`类是用来记录和表现`QPainter`操作的绘画设备。

`QPixmap`可以使用`QLabel`或者`QAbstractButton`的一个子类方便的显示在屏幕上。
`QLabel`有一个pixmap的属性，`QAbstractButton`有一个icon的属性。

`QPixmap`进行的是值传递，因为`QPixmap`使用隐式数据共享。
可以通过隐式数据共享的文档来了解更多信息。
`QPixmap`也可以流化。

注意，`QPixmap`的像素数据外部无法访问，有低层窗口系统直接操作。
因为`QPixmap`是`QPaintDevice`的子类，因此`QPainter`能够直接在`QPixmap`上画。
只能通过`QPainter`的函数或者转化为`QImage`来访问`QPixmap`的像素数据。
但可以使用`fill()`函数来把整个`QPixmap`初始化为一种颜色。

可以使用函数在`QImage`和`QPixmap`之间互相转换。
经常是使用`QImage`来载入图像文件并操作图像，
然后转化为`QPixmap`来在屏幕上显示。
但如果不需要操作图像，那么也可以直接使用`QPixmap`来读取图像文件。

`QPixmap`提供了一系列函数来获取图像的多种信息。
还有一些函数提供了图像变换的功能。

###读写图像文件

`QPixmap`提供了好几种方式来读取图像文件。
即可以在构造的时候载入，也可以使用`load()`或者`loadFromData()`载入，
当载入一个图像的时候，即可使用真实的文件名，也可以资源文件中文件别名。
可以看QT的资源系统(Qt Resource System)来获取更多信息。

可以使用`save()`函数保存图像文件。

支持文件格式的完整列表可以使用`QImageReader::supportedImageFormats()`和`QImageWriter::supportedImageFormats()`来获取。
新的文件格式可以以插件的形式加载。默认情况下，QT支持下列文件格式。

###获取Pixmap的信息

###图像变换

###与其他类转化

##原文
##Detailed Description

The `QPixmap` class is an off-screen image representation that can be used as a paint device.

Qt provides four classes for handling image data: `QImage`, `QPixmap`, `QBitmap` and `QPicture`. 
`QImage` is designed and optimized for I/O, and for direct pixel access and manipulation, 
while `QPixmap` is designed and optimized for showing images on screen. 
`QBitmap` is only a convenience class that inherits `QPixmap`, ensuring a depth of 1. 
The is`QBitmap`() function returns true if a `QPixmap` object is really a bitmap, otherwise returns false. 
Finally, the `QPicture` class is a paint device that records and replays `QPainter` commands.

A `QPixmap` can easily be displayed on the screen using `QLabel` or one of `QAbstractButton`'s subclasses (such as QPushButton and QToolButton). 
`QLabel` has a pixmap property, whereas `QAbstractButton` has an icon property.

`QPixmap` objects can be passed around by value since the `QPixmap` class uses implicit data sharing. 
For more information, see the Implicit Data Sharing documentation. 
`QPixmap` objects can also be streamed.

Note that the pixel data in a pixmap is internal and is managed by the underlying window system. 
Because `QPixmap` is a `QPaintDevice` subclass, `QPainter` can be used to draw directly onto pixmaps. 
Pixels can only be accessed through `QPainter` functions or by converting the `QPixmap` to a `QImage`.
However, the `fill()` function is available for initializing the entire pixmap with a given color.

There are functions to convert between `QImage` and `QPixmap`. 
Typically, the `QImage` class is used to load an image file, optionally manipulating the image data, 
before the `QImage` object is converted into a `QPixmap` to be shown on screen. 
Alternatively, if no manipulation is desired, the image file can be loaded directly into a `QPixmap`.

`QPixmap` provides a collection of functions that can be used to obtain a variety of information about the pixmap. 
In addition, there are several functions that enables transformation of the pixmap.

###Reading and Writing Image Files

`QPixmap` provides several ways of reading an image file: 
The file can be loaded when constructing the `QPixmap` object, or by using the `load()` or `loadFromData()` functions later on. 
When loading an image, the file name can either refer to an actual file on disk or to one of the application's embedded resources. 
See The Qt Resource System overview for details on how to embed images and other resource files in the application's executable.

Simply call the `save()` function to save a `QPixmap` object.

The complete list of supported file formats are available through the `QImageReader::supportedImageFormats()` and `QImageWriter::supportedImageFormats()` functions. 
New file formats can be added as plugins. By default, Qt supports the following formats:

+ || Format	|| Description												|| Qt's support ||
+ || BMP		|| Windows Bitmap										|| Read/write	|| 
+ || GIF		|| Graphic Interchange Format (optional)	|| Read				|| 
+ || JPG		|| Joint Photographic Experts Group			|| Read/write	|| 
+ || JPEG		|| Joint Photographic Experts Group			|| Read/write	|| 
+ || PNG		|| Portable Network Graphics						|| Read/write	|| 
+ || PBM		|| Portable Bitmap										|| Read				|| 
+ || PGM		|| Portable Graymap									|| Read				|| 
+ || PPM		|| Portable Pixmap										|| Read/write	|| 
+ || XBM		|| X11 Bitmap												|| Read/write	|| 
+ || XPM		|| X11 Pixmap												|| Read/write	|| 

###Pixmap  Information

`QPixmap` provides a collection of functions that can be used to obtain a variety of information about the pixmap:

Available Functions

1. Geometry	The `size()`, `width()` and `height()` functions provide information about the pixmap's size. The `rect()` function returns the image's enclosing rectangle.

2. Alpha component	The `hasAlphaChannel()` returns true if the pixmap has a format that respects the alpha channel, otherwise returns false. The `hasAlpha()`, `setMask()` and `mask()` functions are legacy and should not be used. They are potentially very slow.
The `createHeuristicMask()` function creates and returns a 1-bpp heuristic mask (i.e. a `QBitmap`) for this pixmap. It works by selecting a color from one of the corners and then chipping away pixels of that color, starting at all the edges. The `createMaskFromColor()` function creates and returns a mask (i.e. a `QBitmap`) for the pixmap based on a given color.

2. Low-level information	The `depth()` function returns the depth of the pixmap. The `defaultDepth()` function returns the default depth, i.e. the depth used by the application on the given screen.
The `cacheKey()` function returns a number that uniquely identifies the contents of the `QPixmap` object.
The x11`Info()` function returns information about the configuration of the X display used by the screen to which the pixmap currently belongs. The x11`PictureHandle()` function returns the X11 Picture handle of the pixmap for XRender support. Note that the two latter functions are only available on x11.

###Pixmap Conversion

A `QPixmap` object can be converted into a `QImage` using the `toImage()` function. Likewise, a `QImage` can be converted into a `QPixmap` using the `fromImage()`. If this is too expensive an operation, you can use `QBitmap`::`fromImage()` instead.

The `QPixmap` class also supports conversion to and from HICON: the `toWinHICON()` function creates a HICON equivalent to the `QPixmap`, and returns the HICON handle. The `fromWinHICON()` function returns a `QPixmap` that is equivalent to the given icon.

###Pixmap Transformations

`QPixmap` supports a number of functions for creating a new pixmap that is a transformed version of the original:

The `scaled()`, `scaledToWidth()` and `scaledToHeight()` functions return scaled copies of the pixmap, while the `copy()` function creates a `QPixmap` that is a plain copy of the original one.

The `transformed()` function returns a copy of the pixmap that is transformed with the given transformation matrix and transformation mode: Internally, the transformation matrix is adjusted to compensate for unwanted translation, i.e. `transformed()` returns the smallest pixmap containing all transformed points of the original pixmap. The static `trueMatrix()` function returns the actual matrix used for transforming the pixmap.

Note: When using the native X11 graphics system, the pixmap becomes invalid when the QApplication instance is destroyed.

See also `QBitmap`, `QImage`, `QImage`Reader, and `QImage`Writer.