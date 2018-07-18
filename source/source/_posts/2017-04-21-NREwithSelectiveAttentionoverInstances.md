---
layout: post
title: Neural Relation Extraction with Selective Attention over Instances 阅读笔记
description: 
date: 2017-04-21
categories: 
  - [论文阅读笔记 , Relation Extraction]
tags:
  - Relation Extraction
---

## Abstract
+ 远程监督的关系提取（Distant supervised relation extraction）已经被广泛的使用来发现新的关系了，但主要问题是无可避免的引入了噪音，对关系提取的性能影响很大。
+ 为了解决这个问题，我们提出了句子级别的attention-based模型(sentence-level attention-based model)，本文中使用CNN来编码句子语义，并在多个实例上应用了sentence-level attention，以期能够动态的减少噪音的权值。
+ 实验结果显示，我们的方法可以保留所有信息并且有效的减少噪音的影响。
+ 实验代码可以在<https://github.com/thunlp/NRE>找到.

## 1. Introduction
+ 知识库knowledge bases (KBs) eg. Freebase (Bollacker et al., 2008), DBpedia (Auer et al., 2007) and YAGO (Suchanek et al., 2007)越来越多的被应用与NLP问题。
+ 知识库KB主要是由三元组（e1,e2,relation）构成的，虽然这些关系库都很大了，但还远远不够大，所以想自动地提取关系。
+ (Mintz et al., 2009) 提出了distant supervision 通过对其KB和文本来自动的生成训练数据。
+ 假设如果在KB中两个实体有某种关系，则认为在所有包含这两个实体的句子中也表达了这种关系。  
 ==> 很容易导致错误标注。
+ (Riedel et al., 2010; Hoffmann et al., 2011; Surdeanu et al., 2012) 使用多实例学习(multi-instance learning)减少错误标注的影响。这些方法的问题在于他们使用了NLP工具例如POS标注等，工具产生的误差会传导到分类中。
+ (Socher et al., 2012; Zeng et al., 2014; dos Santos et al., 2015)尝试在RE中使用DNN而不是人工提取特征，但这些工作是基于标注好的语句上的，没法大规模扩展到KBs上。
+ (Zeng et al., 2015) 之后将 DS multi-instance learning 应用到了CDNN中。 该方法假设包含两个实体的句子中至少有一个表示了他们的关系，然后只选择这个最可能的句子来作为实体对的训练和预测样本。
+ 本文提出了一个句子级别的attention-based的CNN来做远程监督的关系提取（sentence-level attention-based convolutional neural network (CNN) for distant supervised relation extraction），如下图所示。  
 ![image](/images/NRE/NREwithSelectiveAttention.jpg)  
 图中$x_i$代表一个原始的句子，  
 $X_i$代表表示这个句子的向量，  
 $\alpha_i$代表第i个句子的权值，即Attention模型，  
 $s$代表最终形成的训练样本。
+ 创新点
  - 与现有的NRE模型比较，我们的模型能够利用所有包含有效信息的句子。
  - 为了减少远程学习中错误标注的问题，我们使用selective attention来降低噪音的影响。
  - 在实验中，我们验证了selective attention 对NRE问题中的两种 CNN 模型都有效。

## 2. Related Work

+ 关系抽取Relation extraction 和 远程监督 distant supervision
  - 监督学习需要大量标注好的训练样本 ==> (Mintz et al., 2009)提出远程监督（distant supervision），将文本和freebase对齐。==> 出现了错误标注问题。
  - 为了解决错误标注问题，(Riedel et al., 2010)提出了multi-instance single-label learing，(Hoffmann et al., 2011; Surdeanu et al., 2012) 提出了multi-instance multi-label learning。
  - (Zeng et al., 2015)将 multi-instance learning 和 CNN 和 DS 结合起来
+ 多实例学习Multi-instance learning 
  - 基本原理就是考虑没有示例的可靠性（the reliability of the labels for each instance）。
  - 最开始是为了解决训练数据的歧义标注问题ambiguously-labelled training data when predicting the activity of drugs (Dietterich et al., 1997)
  - 之后(Bunescu and Mooney, 2007)将弱监督学习（weak supervision）和多实例（muti-instance）结合起来应用于关系提取。
  - 但是这些基于特征的方法都依赖于NLP工具提取的特征，带来了错误的传递。
+ 深度学习deep learning (Bengio, 2009)已经应用于很多其他的NLP问题
  - 词性批注 part-of-speech tagging (Collobert et al., 2011),
  - 语义分析 sentiment analysis (dos Santos and Gatti, 2014)
  - 语法分析 parsing (Socher et al., 2013), 
  - 机器翻译 machine translation (Sutskever et al., 2014)
  - 关系提取 使用RNN自动提取特征(Socher et al., 2012)，首先构建语法树然后把树上的节点用向量表示。
  - 关系提取 (Zeng et al., 2014; dos Santos et al., 2015)使用CNN来做RE
  - (Xie et al., 2016) 尝试把文本信息包含进关系提取中。
+ 基于注意力的模型 attention-based models
  - attention-based modes的权重可以使用多种方式学习。
  - 图像分类 image classification (Mnih et al., 2014), 
  - 语音识别 speech recognition (Chorowski et al., 2014), 
  - 图像注释生成 image caption generation (Xu et al., 2015),
  - 机器翻译 machine translation (Bahdanau et al., 2014).

## 3. Methodology 

概述：给定一个句子集合[$S=\{x_1,x_2,··· ,x_n\}$]()和两个对应的实体，我们想要评价对于每一个可能关系[$r$]()的概率。  
分为两个部分：  
+ Sentence Encoder : 给定一个句子[${x}$]()和两个对应实体，通过一个CNN来构建一个语句向量[$X$]()。
+ Selective Attention Over Instances。

### 3.1 Sentence Encoder

![Sentence Encoder](/images/NRE/sentenceEncoder.jpg)

#### 3.1.1 Input Representation

+ 输入是raw句子[$x$]()，类似上一篇文章(Zeng et al., 2014)，同时使用单词向量WF和位置向量PF。
  - 单词向量WF [$w$]() ：提取单词的语义和语法信息，维度是[$d^a$]()
  - 位置向量PF : 靠近实体的通常更有意义。维度是[$d^b x 2$]()
  - 总长度为 [$d$]() $d=d^a+d^b$
#### 3.1.2 Convolution, Max-pooling and Non-linear Layers

+ 在关系提取这个问题中，一个主要的挑战是句子长度是变换的，重要的信息可能出现在句子的任何地方。我们应该应用局部特征（Local Features）然后做一个整体的预测（Prediction globally），本文使用卷积层来合并所有的这些特征。
+ 卷积层首先提取长度为$l$的滑动窗口内的局部特征(Local features)，然后使用max-pooling操作提取出一个大小固定的向量。
+ 使用[$W$]()来表示卷积矩阵，其维度为$d^cx(lxd)$,其中[$d^c$]()是句子向量的长度。
+ 使用[$q_i$]()代表第$i$个窗口的单词连接成的向量，超出范围的使用0向量扩展padding。
+ 卷积第$i$个通道filter的计算就是  
$$p_i = [Wq + b]_i$$   
其中$b$是偏置向量。
+ 然后对每一个维度做max-pooling得到句子向量[$x$]()
+ PCNN(Zeng et al., 2015)，是CNN的一种变体，就是用两个实体把句子分成三段，每一段有一个单独的卷积核$(p_{i1},p_{i2},p_{i3})$，然后再对每一段分别进行max-pooling操作，每个维度得到3个值然后连接扩展该维。
+ 使用一个非线性激活函数$\tanh$

### 3.2 Selective Attention over Instances

+ 在包含两个相同实体的句子集合[$S=\{x_1,x_2,··· ,x_n\}$]()表示成一个向量$s$，用来代表这个集合用来预测关系$r$。
+ $s$是$S$中句子向量的加权和。  
$$s=\sum\limits_i {\alpha_i w_i}$$  
$\alpha_i$就是每个句子的权值，也正是本文中Selective Attention的含义。
+ 本文使用两种方法来定义权值$\alpha$
  - 平均：Average
  - Selective Attention  
  计算公式为  
  $$\alpha_i = \frac{exp(e_i)}{\sum_k{exp(e_k)}}$$  
  $e_i$是用来度量输入的句子
  $x_i$和预测的关系$r$匹配的得分，我们选择bilinear form（双线性形式）。  
  $$e_i = x_i A r$$  
  $A$是一个weighted diagonal matrix，$r$是对应关系的向量表示。
  最后，我们使用softmax定义一个条件概率$p(r|S,\theta)$，公式为：
  
  $$p(r|S,\theta ) =  \frac {exp(o\_r)}{\sum_{k=1}^{n\_r}{exp(o_k)}}$$

  $n_r$表示关系总数。

  $o$代表神经网络的最后输出，定义为

  $$o=Ms+d$$

  $d$ 是偏置向量， $M$ 是<u>关系矩阵（representation matrix of relations）</u>

  即在最后添加两个一个softmax层。
  
### 3.3 Optimization and Implementation Details

+ 使用交叉熵cross-entropy 作为目标函数。
+ 使用随机梯度下降SGD最小化目标函数。
+ 在输出层应用了 dropout (Srivastava et al., 2014)技术来防止过拟合，dropout就是在输出层定义一个概率$p$，把输出结果呈上按照概率为$p$的伯努利分布。所以，输出公式应该写为  
$$o=M(s h)+d$$

## 4. Experiments

### 4.1 Dataset and Evaluation Metrics

+ 使用(Riedel et al., 2010)开发的，(Hoffmann et al., 2011; Surdeanu et al., 2012)也使用的一个数据集。
+ 这个数据集是将NYT和freebase对齐，使用Stanford named entity tagger (Finkel et al., 2005)来识别实体，然后和freebase中的实体进行对齐。
+ 使用语料库中2005-2006年的句子作为训练集，使用2007年的作为测试集。
+ 规模
  - 共有53中关系，其中包含一种特殊的NA，表示两个实体没有关系。
  - 训练集：522611个句子，281270个实体对，18252个关系实例
  - 测试集：172448个句子，96678 个实体对，1950 个关系示例
+ <u>使用held-out evaluation(可行性存疑)</u> 
  - 将从语料库中语句提取的关系和相应实体对在freebase中的语句提取的关系进行对比。
  - 基于这样一个假设：关系示例在freebase内外的结构应该是类似的。
  - 提供了一个不用耗费时间和经历的近似评价。 
+ 在试验中使用 precision/recall 曲线和 recision@N (P@N) 评价。  

### 4.2 Experimental Settings

#### 4.2.1 Word Embeddings
使用google的word2vec训练NYT语料库，把出现次数大于100次的添加到词典中，同时把包含多个单词的实体连接起来，作为一个单词。

#### 4.2.2 Parameter Settings 

+ 参数设置如下表所示

| 含义 | 符号 | 数值 |
| :---: | :---: | :---: |
| 窗口大小 Window size                 | $l$	| 3 |
| 句子向量维度 Sentence embedding size | $d^c$	| 230 |
| 词向量维度 Word dimension            | $d^a$	| 50 |
| 位置向量维度 Position dimension      | $d^b$	| 5 |
| 每批次大小 Batch size               | $B$ |	160 |
| 学习速率 Learning rate             | $\lambda$ |	0.01 |
| Dropout概率 Dropout probability    | $p$	| 0.5 | 

### 4.3 Effect of Sentence-level Selective Attention 

+ 我们选择了CNN (Zeng et al.,2014)和PCNN(Zeng et al., 2015) 作为我们的句子编码器，并且自己实现了，然后得到了可以和我们方法比较的数据。
+ 我们分别对CNN和PCNN应用ATT(Sentence-Level Attention)、AVE(Average)、ONE(at-least-one multi-instance learning (Zeng et al., 2015).)
实验结果如图所示
![](/images/NRE/reult.jpg)
+ 从图中我们可以看出
  - 不管是CNN还是PCNN，加了个ONE方法之后表现都比原来的好，因为原始的远程监督会包含很多噪音，损害了性能。
  - 不管是CNN还是PCNN，加了AVE之后都是有益的，因为这些噪音相互抵消。
  - 不管是CNN还是PCNN，ONE和AVE的性能差不多，因为AVE把每个句子看成相同的，还是引入了错误标记
  - 不管是CNN还是PCNN，ATT方法都是最高性能的方法。ATT方法可以过滤出没有意义的语句，减少DS带来的错误标记的问题。

### 4.4 Effect of Sentence Number 句子数量的影响

+ 在原先的测试集中，有74,857个实体对只有一个句子包含，接近总数的3/4。因为我们方法的有点主要在从多个句子中选择注意力，所以我们比较了CNN/PCNN+ONE, CNN/PCNN+AVE and CNN/PCNN+ATT 在不只有一个句子时的性能，我们使用了下面的三种设置。
  - One： 随机选择一个句子，使用这个句子来预测关系。
  - Two： 随机选择两个句子来预测关系。
  - All： 使用包含该实体对的所有句子来预测关系。  
注意：我们使用了所有的句子进行训练。我们分别使用<u>100, 200, 300</u>个测试。

![](/images/NRE/differentSeeting.jpg)
+ 从结果中我们可以发现
  - 不管对CNN还是PCNN，在不同设置中，ATT方法都取得了最好的性能，证明我们的方法是有效的。
  - 在使用One设置时，不管对CNN还是PCNN，AVE和ATT差不多，
  - CNN+AVE和CNN+ATT比CNN+ONE在One的测试中都有5%-8%的提高，此时唯一的区别就是训练过程中有没有使用所有的样本，试验中证明使用所有的样本可以带来更多的信息。
  - 不管是CNN还是PCNN，在Two和All中，ATT方法比另外两个高5%，9%。正说明把更多的句子考虑进来对关系提取很有帮助，

### 4.5 Comparison with Feature-based Approaches

+ 选择3个基于特征的方法进行比较（都有代码）
  - Mintz (Mintz et al., 2009)传统的DS模型
  - MultiR (Hoffmann et al., 2011)多实例概率图，并且处理了重叠关系
  - MIML (Surdeanu et al., 2012) 联合多例和多关系模型。
![](/images/NRE/pcopmatm.jpg)

+ 实验现实
  -  CNN/PCNN+ATT 明显比基于特征的模型好很多。recall高于0.1时，基于特征的方法的准确率就快速下降了，而我们的方法直到recall到0.3的时候准确率还是比较高的。这证明人设计的特征不能很好的表达语句的意义，NLP工具带来的必然误差损害了关系提取的性能。相比之下，CNN/PCNN+ATT自动学习句子的表达可以很好地表示一个句子。
  - 整个曲线，PCNN+ATT比CNN+ATT表现的都好很多。这说明selective attention 是考虑的所有句子的信息而不是每一个句子内部的信息。这说明如果换一个更好的sentence encoder会取得更好的结果。

### 4.6 Case Study

![](/images/NRE/casetest.jpg)

## 5. Conclusion and Future Works

未来工作  
+ 我们的模型把multi-instance learning 和 neural network 通过 instance-level selective attention 结合起来，这不仅可以应用于远程监督的关系提取，还可以应用于其他的多实例学习任务。我们将会在其他领域例如文本分类拓展我们的模型。
+ CNN对于NRE来说是一个有效的工具。研究者也提出过很多的其他模型，将来我们将我们的instance-level selective attention和其他的模型集合起来。

## 符号表

| 含义 | 符号 | 数值 |
| :---: | :---: | :---: |
| <span id = "s1"></span>窗口大小 Window size                 | $l$	| 3 |
| <span id = "s2"></span>句子向量维度 Sentence embedding size | $d^c$	| 230 |
| <span id = "s3"></span>词向量维度 Word dimension            | $d^a$	| 50 |
| <span id = "s4"></span>位置向量维度 Position dimension      | $d^b$	| 5 |
| <span id = "s5"></span>每批次大小 Batch size               | $B$ |	160 |
| <span id = "s6"></span>学习速率 Learning rate             | $\lambda$ |	0.01 |
| <span id = "s7"></span>Dropout概率 Dropout probability    | $p$	| 0.5 | 

## TODO

- [ ] 设置参数的时候可以使用测试集么？
- [ ] 以实体对为单位还是以句子为单位？
- [ ] Attention的权值向量是不是不是参数，只是句子向量s的一个函数？