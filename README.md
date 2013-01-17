DXRBuilder
==========

DXRBuilder是用来转换SWF文件为[Flexlite](http://flexlite.org/)框架可用的DXR动画文件。

### 使用说明

[安装文件下载](http://github.com/bindiry/DXRBuilder/raw/master/DXRBuilder.air)，DXRBuilder只支持导出指定swf文件中含有链接名的MovieClip元件为FlexLite中使用的DXR文件，所以在进行导出前，请确保swf文件中只有MovieClip元件设置了链接名。

关于DXR动画文件的使用，请参考Flexlite的[WIKI](http://wiki.flexlite.org)、[源码](http://github.com/flexlite)和DXR动画文件[结构图](http://wiki.flexlite.org/uploads/201210/1350297604fFF5kVj7.png)。

##### 压缩格式说明
* JPEG32: 压缩率最高，但效果稍差
* JPEGXR: 压缩率高效果好但只支持FP11以上版本
* PNG: 压缩率不高，但效果好

### 编译环境
编译前，需在项目源路径中引入libs目录，项目需使用 [Flex SDK 4.6](http://www.adobe.com/devnet/flex/flex-sdk-download.html) 和 [Air SDK 3.5](http://www.adobe.com/devnet/air/air-sdk-download.html)。

![DXRBuilder载图](http://raw.github.com/bindiry/DXRBuilder/master/dxrbuilder.png)

### 版本记录

##### v1.0.1 (01/17/2012)
* 修正导出DXR时，动画不流畅的问题
* 修正可能导致动画出现重影的问题 (感谢 [DOM](http://blog.domlib.com) 指导)，[参考日志](http://blog.domlib.com/articles/353.html)。

##### v1.0.0 (01/15/2012)
* 首次发布

License
-------

This plugin released under MIT License:

    Copyright (c) 2013 Bindiry

    Permission is hereby granted, free of charge, to any person obtaining a copy of
    this software and associated documentation files (the "Software"), to deal in
    the Software without restriction, including without limitation the rights to
    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
    of the Software, and to permit persons to whom the Software is furnished to do
    so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.