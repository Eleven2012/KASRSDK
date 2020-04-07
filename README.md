# KASRSDK
语音识别SDK,集成siri和百度sdk,支持离线识别

简书地址：[IOS音视频（四十六）离线在线语音识别方案](https://www.jianshu.com/p/5e184be8dc30)
@[TOC](IOS音视频（四十六）离线在线语音识别方案)


最近做了一个语音识别相关的研究，因为公司需要使用离线语音识别功能，为了兼顾性能和价格方面的问题，最终选择的方案是，在线时使用siri,离线使用百度语音识别方案。

封装了一个离线在线合成的SDK：[语音识别SDK](https://github.com/Eleven2012/KASRSDK.git) 这个Demo里面没有上传百度libBaiduSpeechSDK.a 文件，因为这个文件太大了超过了100M，无法上传到Git,需要自己从官方SDK下载替换到Demo中。

这里总结一下现有的几种离线语音识别方案

* 简易使用第三方SDK方案

|方案| 优点 |缺点|价格|成功率|
|--|--|--|--|--|
| 科大讯飞 |成功率高95%  |价格贵，增加ipa包大小 | 可用买断或按流量，一台设备成本4元左右 |成功率95%左右 |
| 百度AI |成功率比较高90% ，价格便宜，离线识别免费 ，提供了自定义模型训练，训练后识别率提高较多| 增加ipa包大小, 识别率不高，离线只支持命令词方式，支持的语音只有中文和英文，在线时会强制使用在线识别方式，超过免费流量后就要收费，如果欠费，什么都用不了；离线引擎使用至少需要连一次外网| 离线命令词免费，在线识别按流量次数计算，1600元套餐包（200万次中文识别，5万次英文识别） | 在线识别成功率95%左右，离线识别基本上达不到90%|
| siri |成功高，免费，原始自带，苹果系统自带，不会增加包大小  | 有局限性，要求IOS10以上系统才能使用siri api,  IOS 系统13以上支持离线语音识别，但离线识别不支持中文识别，英文离线识别比百度的准确率高| 完全免费 | 在线识别率跟科大讯飞差不多95%以上，离线英文识别也有90%左右|
|  |  | |  | |
|  |  | |  | |

* 开源代码方案

|方案| 优点 |缺点|说明|成功率|
|--|--|--|--|--|
|  KALDI开源框架| KALDI是著名的开源自动语音识别（ASR）工具，这套工具提供了搭建目前工业界最常用的ASR模型的训练工具，同时也提供了其他一些子任务例如说话人验证（speaker verification）和语种识别（language recognition）的pipeline。KALDI目前由Daniel Povey维护，他之前在剑桥做ASR相关的研究，后来去了JHU开发KALDI，目前在北京小米总部作为语音的负责人。同时他也是另一个著名的ASR工具HTK的主要作者之一。 | |  | |
| CMU-Sphinx开源框架 | 功能包括按特定语法进行识别、唤醒词识别、n-gram识别等等，这款语音识别开源框架相比于Kaldi比较适合做开发，各种函数上的封装浅显易懂，解码部分的代码非常容易看懂，且除开PC平台，作者也考虑到了嵌入式平台，Android开发也很方便，已有对应的Demo，Wiki上有基于PocketSphinx的语音评测的例子，且实时性相比Kaldi好了很多。 | 相比于Kaldi，使用的是GMM-HMM框架，准确率上可能会差一些；其他杂项处理程序（如pitch提取等等）没有Kaldi多。|  | |
| HTK-Cambridage | 是C语音编写，支持win,linux,ios | |  | |




# 方案三：使用开源框架

## 1. KALDI
kaldi源码下载：[kaldi源码下载](https://github.com/kaldi-asr/kaldi)
安装git后运行

```shell
git clone https://github.com/kaldi-asr/kaldi.git kaldi-trunk --origin golden
```

速度过慢可以参考:[github下载提速](https://www.jianshu.com/p/02841aec86f6)

通过http://git.oschina.net/离线下载的方式

```shell
git clone https://gitee.com/cocoon_zz/kaldi.git kaldi-trunk --origin golden
```

* Kaldi官网 http://kaldi-asr.org/doc/index.html 包括一大堆原理和工具的使用说明，有什么问题请首先看这个。
* Kaldi Lecture http://www.danielpovey.com/kaldi-lectures.html 相比于上一个会给一个更简略的原理、流程介绍。
* Kaldi中文翻译1 如果感觉英语读起来比较头疼的话建议搜一下这个来看看，是对官网上文件的翻译。这个文档来源于一个学习交流Kaldi的QQ群。
* Kaldi中文翻译2 https://shiweipku.gitbooks.io/chinese-doc-of-kaldi/content/index.html

### KALDI简介
[KALDI](http://kaldi-asr.org/) 简介
>KALDI是著名的开源自动语音识别（ASR）工具，这套工具提供了搭建目前工业界最常用的ASR模型的训练工具，同时也提供了其他一些子任务例如说话人验证（speaker verification）和语种识别（language recognition）的pipeline。KALDI目前由Daniel Povey维护，他之前在剑桥做ASR相关的研究，后来去了JHU开发KALDI，目前在北京小米总部作为语音的负责人。同时他也是另一个著名的ASR工具HTK的主要作者之一。
KALDI之所以在ASR领域如此流行，是因为该工具提供了其他ASR工具不具备的可以在工业中使用的神经网络模型（DNN，TDNN，LSTM）。但是与其他基于Python接口的通用神经网络库（TensorFlow，PyTorch等）相比，KALDI提供的接口是一系列的命令行工具，这就需要学习者和使用者需要比较强的shell脚本能力。同时，KALDI为了简化搭建语音识别pipeline的过程，提供了大量的通用处理脚本，这些脚本主要是用shell，perl以及python写的，这里主要需要读懂shell和python脚本，perl脚本主要是一些文本处理工作，并且可以被python取代，因此学习的性价比并不高。整个KALDI工具箱的结构如下图所示。![KALDI工具箱的结构](https://upload-images.jianshu.io/upload_images/10798403-e670b7f9d7d6bf61?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
>可以看到KALDI的矩阵计算功能以及构图解码功能分别是基于BLAS/LAPACK/MKL和OpenFST这两个开源工具库的，在这些库的基础上，KALDI实现了Matrix，Utils，Feat，GMM，SGMM，Transforms，LM，Tree，FST ext，HMM，Decoder等工具，通过编译之后可以生成命令行工具，也就是图中的C++ Executables文件。最后KALDI提供的样例以及通用脚本展示了如何使用这些工具来搭建ASR Pipeline，是很好的学习材料。
除了KALDI本身提供的脚本，还有其官方网站的Documents也是很好的学习资料。当然，除了KALDI工具本身，ASR的原理也需要去学习，只有双管齐下，才能更好的掌握这个难度较高的领域。

### KALDI 源码编译 安装

如何安装参考下载好的目录内INSTALL文件

```shell
This is the official Kaldi INSTALL. Look also at INSTALL.md for the git mirror installation.
[for native Windows install, see windows/INSTALL]

(1)
go to tools/  and follow INSTALL instructions there.

(2)
go to src/ and follow INSTALL instructions there.
```

出现问题首先查看各个目录下面的`INSTALL`文件，有些配置的问题（例如`gcc`的版本以及CUDA等）都可以查看该文档进行解决。

**依赖文件编译**

首先检查依赖项

```shell
cd extras
sudo bash check_dependencies.sh
```

注意make -j4可以多进程进行

```shell
cd kaldi-trunk/tools
make
```

**配置Kaldi源码**

```shell
cd ../src
#如果没有GPU请查阅configure，设置不使用CUDA
./configure --shared
```

**编译Kaldi源码**

```shell
make all
#注意在这里有可能关于CUDA的编译不成功，原因是configure脚本没有正确的找出CUDA的位置，需要手动编辑configure查找的路径，修改CUDA库的位置
```

**测试安装是否成功**

```shell
cd ../egs/yesno/s5
./run.sh
```
![安装成功效果图](https://upload-images.jianshu.io/upload_images/10798403-2c68a43a11fab453?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

解码的结果放置在exp目录(export)下，例如我们查看一下
~/kaldi-bak/egs/yesno/s5/exp/mono0a/log$ vim align.38.1.log

![yesno结果](https://upload-images.jianshu.io/upload_images/10798403-3059507ff23736b0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
这里面0,1就分别代表说的是no还是yes啦。

#### 语音识别原理相关资料

语音识别的原理 https://www.zhihu.com/question/20398418

HTK Book http://www.ee.columbia.edu/ln/LabROSA/doc/HTKBook21/HTKBook.html

如何用简单易懂的例子解释隐马尔可夫模型？ https://www.zhihu.com/question/20962240/answer/33438846



#### kaldi一些文件解读

1:`run.sh`　　总的运行文件，里面把其他运行文件都集成了。
｛
执行顺序：run.sh >>> path.sh >>> directory(存放训练数据的目录) >>> mono-phone>>>triphone>>>lda_mllt>>>sat>>>quitck
data preparation:
>1:generate text,wav.scp,utt2spk,spk2utt   (将数据生成这些文件) (由local/data_prep.sh生成)
text:包含每段发音的标注　　sw02001-A_002736-002893 AND IS
wav.scp:    （extended-filename:实际的文件名）
sw02001-A /home/dpovey/kaldi-trunk/tools/sph2pipe_v2.5/sph2pipe -f wav -p -c 1 /export/corpora3/LDC/LDC97S62/swb1/sw02001.sph |
utt2spk: 　指明某段发音是哪个人说的（注意一点，说话人编号并不需要与说话人实际的名字完全一致——只需要大概能够猜出来就行。）
sw02001-A_000098-001156 2001-A
spk2utt:   ...　（utt2spk和spk2utt文件中包含的信息是一样的）
2:produce MFCC features
3:prepare language stuff(build a large lexicon that invovles words in both the training and decoding.)
4:monophone单音素训练
5:tri1三音素训练(以单音素模型为输入训练上下文相关的三音素模型)， trib2进行lda_mllt声学特征变换，trib3进行sat自然语言适应(运用基于特征空间的最大似然线性回归（fMLLR）进行说话人自适应训练)，trib4做quick
LDA-MLLT（Linear Discriminant Analysis – Maximum Likelihood Linear Transform）， LDA根据降维特征向量建立HMM状态。MLLT根据LDA降维后的特征空间获得每一个说话人的唯一变换。MLLT实际上是说话人的归一化。 
SAT（Speaker Adaptive Training）。SAT同样对说话人和噪声的归一化。
5:DNN
}

2:`cmd.sh`   　一般需要修改
>export train_cmd=run.pl #将原来的queue.pl改为run.pl
export decode_cmd="run.pl"#将原来的queue.pl改为run.pl这里的--mem 4G 
export mkgraph_cmd="run.pl"#将原来的queue.pl改为run.pl  这里的--mem 8G 
export cuda_cmd="run.pl" #将原来的queue.pl改为run.pl 这里去掉原来的--gpu 1(如果没有gpu)

3:`path.sh`  (设置环境变量)
>export KALDI_ROOT=`pwd`/../../..
[ -f $KALDI_ROOT/tools/env.sh ] && . $KALDI_ROOT/tools/env.sh
export PATH=$PWD/utils/:$KALDI_ROOT/tools/openfst/bin:$PWD:$PATH
[ ! -f $KALDI_ROOT/tools/config/common_path.sh ] && echo >&2 "The standard file $KALDI_ROOT/tools/config/common_path.sh is not present -> Exit!" && exit 1
. $KALDI_ROOT/tools/config/common_path.sh
export LC_ALL=C
我们看到是在运行run.sh是要用到的环境变量,在这里先设置一下.
我们看到先是设置了KALDI_ROOT，它实际就是kaldi的源码的根目录。
[ -f $KALDI_ROOT/tools/env.sh ] && . $KALDI_ROOT/tools/env.sh 
这句话的意思是如果存在这个环境变量脚本就执行这个脚本，但是我没有在该路径下发现这个脚本。
然后是将本目录下的utils目录, kaldi根目录下的tools/openfst/bin目录 和 本目录加入到环境变量PATH中。
然后是判断如果在kaldi根目录下的tools/config/common_path.sh不存在，就打印提示缺少该文件，并且退出。

Kaldi训练脚本针对不同的语料库，需要重写数据准备部分，脚本一般放在conf、local文件夹里；
`conf`放置一些配置文件，如提取mfcc、filterbank等参数的配置，解码时的参数配置 (主要是配置频率，将系统采样频率与语料库的采样频率设置为一致）
`local`一般用来放置处理语料库的数据准备部分脚本 > 中文识别，应该准备：发音词典、音频文件对应的文本内容和一个基本可用的语言模型(解码时使用)
数据训练完后：
`exp`目录下：
final.mdl　训练出来的模型
graph_word目录下：
words.txt  HCLG.fst  一个是字典，一个是有限状态机（fst:发音字典，输入是音素，输出是词)

### kaldi编译成iOS静态库

编译脚本如下：

```shell
#!/bin/bash

if [ ! \( -x "./configure" \) ] ; then
    echo "This script must be run in the folder containing the \"configure\" script."
    exit 1
fi

export DEVROOT=`xcode-select --print-path`
export SDKROOT=$DEVROOT/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk

# Set up relevant environment variables
export CPPFLAGS="-I$SDKROOT/usr/include/c++/4.2.1/ -I$SDKROOT/usr/include/ -miphoneos-version-min=10.0 -arch arm64"
export CFLAGS="$CPPFLAGS -arch arm64 -pipe -no-cpp-precomp -isysroot $SDKROOT"
#export CXXFLAGS="$CFLAGS"
export CXXFLAGS="$CFLAGS  -std=c++11 -stdlib=libc++"

MODULES="online2 ivector nnet2 lat decoder feat transform gmm hmm tree matrix util base itf cudamatrix fstext"
INCLUDE_DIR=include/kaldi
mkdir -p $INCLUDE_DIR

echo "Copying include files"
LIBS=""
for m in $MODULES
do
  cd $m
  echo
  echo "BUILDING MODULE $m"
  echo
  if [[ -f Makefile ]]
  then
    make
    lib=$(ls *.a)  # this will fail (gracefully) for ift module since it only contains .h files
    LIBS+=" $m/$lib"
  fi

  echo "创建模块文件夹：$INCLUDE_DIR/$m"
  cd ..
  mkdir -p $INCLUDE_DIR/$m
  echo "拷贝文件到：$INCLUDE_DIR/$m/"
  cp -v $m/*h $INCLUDE_DIR/$m/
done

echo "LIBS: $LIBS"

LIBNAME="kaldi-ios.a"
libtool -static -o $LIBNAME $LIBS

cat >&2 << EOF

Build succeeded! 

Library is in $LIBNAME
h files are in $INCLUDE_DIR

EOF

```
上面这个脚本只编译了支持arm64架构的静态库，在真机环境下测试，想支持其他的架构的，可以直接添加：

```shell
export CPPFLAGS="-I$SDKROOT/usr/include/c++/4.2.1/ -I$SDKROOT/usr/include/ -miphoneos-version-min=10.0 -arch arm64"
```

上面的脚本来自大神：`长风浮云` 他的简书地址：https://www.jianshu.com/p/faff2cd489ea 他写了好多关于kaldi的相关博客，如果需要研究可以参考他的博客。

### 基于kaldi 源码编译的IOS 在线，离线语音识别Demo
这里引用他提供的IOS 在线和离线识别的两个demo:

* [在线识别Demo](https://github.com/andyweiqiu/SpeechRecognition)
* [离线识别Demo](https://github.com/andyweiqiu/asr-ios-local)




## 2. CMUSphinx
 [CMUSphinx](http://cmusphinx.github.io) 
 官方资源导航:
* 入门 https://cmusphinx.github.io/wiki/tutorial/
* 进阶 https://cmusphinx.github.io/wiki/
* 问题搜索 https://sourceforge.net/p/cmusphinx/discussion/

* 优点

>1. 这款语音识别开源框架相比于Kaldi比较适合做开发，各种函数上的封装浅显易懂，解码部分的代码非常容易看懂，且除开PC平台，作者也考虑到了嵌入式平台，Android开发也很方便，已有对应的Demo，Wiki上有基于PocketSphinx的语音评测的例子，且实时性相比Kaldi好了很多。
>2. 由于适合开发，有很多基于它的各种开源程序、教育评测论文。
>3. 总的来说，从PocketSphinx来入门语音识别是一个不错的选择。

* 缺点

>相比于Kaldi，使用的是GMM-HMM框架，准确率上可能会差一些；其他杂项处理程序（如pitch提取等等）没有Kaldi多。


* 语音识别CMUSphinx(1)Windows下安装:参考这篇文章：http://cmusphinx.github.io/wiki/tutorialpocketsphinx/
* android demo :https://cmusphinx.github.io/wiki/tutorialandroid/

 ### Sphinx工具介绍
Pocketsphinx —用C语言编写的轻量级识别库，主要是进行识别的。

Sphinxbase — Pocketsphinx所需要的支持库，主要完成的是语音信号的特征提取；

Sphinx3 —为语音识别研究用C语言编写的解码器

Sphinx4 —为语音识别研究用JAVA语言编写的解码器

CMUclmtk —语言模型训练工具

Sphinxtrain —声学模型训练工具

下载网址：http://sourceforge.net/projects/cmusphinx/files/

   > Sphinx是由美国卡内基梅隆大学开发的大词汇量、非特定人、连续英语语音识别系统。Sphinx从开发之初就得到了CMU、DARPA等多个部门的资助和支持，后来逐步发展为开源项目。目前CMU Sphinx小组开发的下列译码器：

  > Sphinx-2采用半连续隐含马尔可夫模型（SCHMM）建模，采用的技术相对落后，使得识别精度要低于其它的译码器。

   >PocketSphinx是一个计算量和体积都很小的嵌入式语音识别引擎。在Sphinx-2的基础上针对嵌入式系统的需求修改、优化而来，是第一个开源面向嵌入式的中等词汇量连续语音识别项目。识别精度和Sphinx-2差不多。

  >Sphinx-3是CMU高水平的大词汇量语音识别系统，采用连续隐含马尔可夫模型CHMM建模。支持多种模式操作，高精度模式扁平译码器，由Sphinx3的最初版本优化而来；快速搜索模式树译码器。目前将这两种译码器融合在一起使用。

  >Sphinx-4是由JAVA语言编写的大词汇量语音识别系统，采用连续的隐含马尔可夫模型建模，和以前的版本相比，它在模块化、灵活性和算法方面做了改进，采用新的搜索策略，支持各种不同的语法和语言模型、听觉模型和特征流，创新的算法允许多种信息源合并成一种更符合实际语义的优雅的知识规则。由于完全采用JAVA语言开发，具有高度的可移植性，允许多线程技术和高度灵活的多线程接口。


## 3.  



参考： https://www.jianshu.com/p/0f4a53450209
