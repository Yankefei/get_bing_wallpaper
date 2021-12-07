# get_bing_wallpaper

​		一种使用脚本自动获取bing搜索壁纸的方法。

​		get_bing_wallpaper by script.

## 简介

​	   这是一个可以在windows和linux平台上使用脚本自动获取`https://cn.bing.com`搜索网页的背景壁纸，如果你也喜欢该网页上的壁纸，可以使用手动在`chrome`浏览器中，使用鼠标右击检查，在浏览器内置的调试栏：`Sources`项中可以手动保存原始文件：

<img src=".\resc\img\get_by_hand.png" alt="手动获取" style="zoom: 33%;" />

​		如果你觉得这种方式每天都需要手动操作一遍，很麻烦，这里推荐一种使用脚本来自动化获取的方式：

## 使用

### 原理

​		`bing搜索`页面的`html`代码已经包含了每日壁纸的获取url请求，壁纸的名称信息以及壁纸的版权。所以仅仅使用`bash`的内部的函数和程序就可以完成自动下载的任务，过程如下：

```sh
1. 使用 curl 获取页面完整url.
2. 使用脚本工具 grep, awk 等拼装请求url的信息.
3. 使用 curl 获取图片文件保存到本地.
4. 进行重命名保存.
```

### windows 平台使用

#### 步骤一

​		鉴于脚本内容为`shell`脚本，所以如果在`windows`平台运行, 需要依赖软件`GitBash`. 该软件内部集成了基本完整的`linux`风格的`shell`环境，可以用于执行脚本。下载地址： `https://gitforwindows.org`

#### 步骤二

​		在windows上选择`Windows`管理工具中的`任务计划程序`：

<img src=".\resc\img\win_1.png" alt="添加定时任务" style="zoom:50%;" />

​		新建任务：

<img src=".\resc\img\win_2.png" alt="新建任务" style="zoom:50%;" />

​		设置每日运行时间：

<img src=".\resc\img\win_3.png" alt="设置时间" style="zoom:50%;" />

​		设置运行的程序名和参数，这里`程序`需要选择安装的`gitbash`程序中的`/usr/bin/bash.exe`，参数选择代码中脚本`get_bing_wallpaper.sh`的**绝对路径**.

<img src=".\resc\img\win_4.png" alt="添加运行参数" style="zoom:50%;" />

#### 步骤三
​		查看执行结果，程序每日的运行会将`1920*1080`格式的图片文件和`1920*1200`格式的文件分别发放在这两个目录中，命名方式为：`%M%D_图片名称.jpg`. 可以查看每日运行的详细内容，在`log_2021_12.log`的文件中，以月份最小生成间隔。

<img src=".\resc\img\win_5.png" alt="保存路径" style="zoom: 67%;" />

​		一开始预想将图片的版权信息也添加到文件名称中，如：`%M%D_图片名称 版权信息.jpg`，但是`bash`内部不支持这样长的文件名，原因未知，所以每日的日志文件大概率中会有重命名失败的日志，如果失败，则退而使用上面的`%M%D_图片名称.jpg`命名法。日志中的错误可以忽略。

<img src=".\resc\img\win_6.png" alt="保存路径2" style="zoom: 67%;" />

<img src=".\resc\img\win_7.png" alt="文件日志" style="zoom: 67%;" />

​		如果需要手动测试脚本，可以直接在`GitBash`的终端进行如下测试：

<img src=".\resc\img\win_8.png" alt="手动运行" style="zoom: 67%;" />

### linux 平台使用

​		`linux`平台使用起来方便了很多，直接使用`crontab`服务设置每天运行的任务即可，文件保存的内容和日志内容与上面**windows平台步骤三**的检查方法一致，这里不再赘述。

## 版权声明

​		bing搜索的壁纸版权属于`bing官方`，获取到的图片资料仅限于个人学习使用，请勿用于商业交流。

