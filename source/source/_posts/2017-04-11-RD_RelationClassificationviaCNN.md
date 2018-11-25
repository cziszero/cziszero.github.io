---
layout: post
title: Relation classification via convolutional DNN 阅读笔记
description: 
date: 2017-04-11
categories: 
  - 论文阅读笔记
  - Relation Extraction
tags:
  - Relation Extraction
---

作者：中科院赵军研究组
年份：2014

## Abstract
+ 现在的先进方式是用统计机器学习，效果依赖于提取的特征，特征主要预先的NLP系统得到，导致了误差传导并阻碍了性能。
+ 使用CDNN提取词语和句子级别的特征，
+ 查表变换成vector，不是用POS、语法分析等其他手段，只用所有的词向量
+ 词汇级别的特征通过给定的名词提取，句子级别的特征通过卷积方法提取
+ 使用softmax对名词对进行分类预测

## Introduction
+ 定义：given a sentence S with the annotated（标注的） pairs of nominals e1 and e2, we aim to identify the relations between e1 and e2 (Hendrickx et al., 2010) 给定一个句子S及标注好的名词对e1 和 e1，我们的目标是明确e1 和 e2 的关系。
+ 相关研究：  
   有监督学习 (Zelenko et al., 2003; Bunescu and Mooney, 2005; Zhou et al., 2005; Mintz et al., 2009)  
     基于特征的
     基于核的
   缺陷：误差传播和不准确(Bach and Badaskar, 2007)
+ 使用CDNN提取特征的idea:Collobert et al. (2011) 做过POS tagging, chunking (CHUNK), Named Entity Recognition (NER) and Semantic Role Labeling (SRL)等任务
+ 提出了position features (PF) 用来编码两个名词之间的相对距离（encode the relative distances to the target noun pairs）
+ 使用SemEval-2010 Task 8 dataset测试

## Related Work
+ unsupervised方法，主要是利用上下文信息。
  - 理论基础：分布假设理论，Distributional hypothesis theory (Harris, 1954)，有相同上下文的词有类似的含义。  
   ==> 上下文结构相似的名词对有相似的关系。 
  - Hasegawa et al. (2004) 使用层次聚类法（hierarchical clustering method），将名词上下文聚类，然后简单的选出上下文中出现最多的单词来表示这个关系。
  - Chen et al. (2005) 提出了基于 <u>model order selection 和 discriminative label identification</u> 来解决这个问题。
+ supervised方法，作为一个多类别分类问题
  - 基于特征的(feature-based)
    + 问题主要在于如何把结构信息转化成特征。
  - 基于核的的(kernel-based)
    + 多种多样的树convolution tree kernel (Qian et al., 2008), subsequence kernel (Mooney and Bunescu, 2005) and dependency tree kernel (Bunescu and Mooney, 2005)
  - 主要问题是缺乏训练数据
    + Mintz et al. (2009) 提出了远程学习 distant supervision (DS) 来解决这个问题。DS就是利用知识库（knowledge base）中的知识作为训练的正样本。DS的主要问题是有wrong labels，容易导致噪音。为了解决这个问题，有下面的两个工作。
    + Riedel et al. (2010) 和 Hoffmann et al. (2011) 提出了<u>the relaxed DS assumption as multi-instance learning</u>
    + Takamatsu et al. (2012) 指出 relaxed DS assumption在某些情况下可能会失效，并提出了一个生成模型（generative model）来进行 the heuristic（启发式的） labeling process.
  - DNN的应用
    + word embeddings (Turian et al., 2010)词向量
    + Socher et al. (2012) 使用RNN在语法树上提取特征来做Relation Classification。
    + Hashimoto et al. (2013) 也使用了RNN来做Relation Classification。

## Methodology

### The Neural Network Architecture 神经网络结构
包含Word Representation, Feature Extraction and Output三层结构。如图所示。  

![](/images/NRE/ArchitectureofNN.jpg)

### Word Representation 单词表示
直接使用了可免费获得的(Turian et al., 2010)的词向量。

### Lexical Level Features 词语级别的特征
+ 以前经常使用nouns themselves, the types of the pairs of nominals and word sequences between the entities，要从NLP工具中得到。
+ 本文中只使用词向量和<u>WordNet hypernyms of nouns</u> , the WordNet hypernyms使用了[MVRNN (Socher et al., 2012)](https://sourceforge.net/projects/supersensetag/)  

| Features | Remark |
| :------: | :----: |
| L1 | Noun 1 |
| L2 | Noun 2 |
| L3 | Left and right tokens of noun 1 |
| L4 | Left and right tokens of noun 2 |
| L5 | WordNet hypernyms of nouns |

### Sentence Level Features 句子级别的特征
+ 虽然词向量已经能够很好的表示词语间的相似性，但无法提取到长距离的特征和语义合成性（semantic compositionality）。
+ 本文中使用max-pooled convolutional neural network来提取句子级别的特征。
+ 提取句子级别特征的框架如图所示。  
![](/images/NRE/FrameworkforSentenceFeature.jpg)
  - Window Processing component部分，每一个单词进一步表示成Word Features (WF) 和 Position Features (PF) 
  - convolutional component. 
  - Sentence level features. 通过一个非线性变换（a non-linear transformation）tanh得到。

#### Word Features 单词特征
就是直接把窗口内的词向量连接起来。

#### Position Features 位置特征
+ (Bunescu and Mooney, 2005) 使用过结构信息（tructure features） (e.g., 最短路径依赖the shortest dependency path between nominals)来解决Relation Classification。
+ 本文中的PF指的是句子中每个单词到名词对（w1，w2）中的两个词的距离， PF = [d1,d2]，并且d1和d2也都被映射到一个$d_e$维的向量空间，和上面的WF连接起来一起投入到下面的CNN中。

#### Convolution 卷积
+ 每个单词的特征向量只能表示它附近的上下文信息，对于Relation Classification，需要把整个句子都组合起来，<u>自然的想到卷积方法</u>
+ 和Collobert et al. (2011)类似，首先把从window process中得到的向量做一个线性变换。  
 
 $$Z = W_1X$$  
 
 其中，$X$是一个$n_0 \times t$ 的矩阵，$n_0 = w \times n$，$n$是每个单词特征向量的维度$[WF PF]$。$w$是窗口大小, $t$是输入句子中单词的个数。  
 $W_1$是一个$n_1 \times n_0$ 的矩阵，$n_1$是第一个隐藏层的输出个数。  
 输出$Z$是一个$n_1 \times t$的向量，使用max-pooling只记录影响最大的那个，如下式所示。   

 $$ m_i = \max Z(i,\cdot) \qquad   0 \leq i \leq n1 $$  

+ 然后我们获得了$m = \{m_1,m_2,···,m_n1\}$向量，与t没有关系了。

#### Sentence Level Feature Vector 句子级别的特征向量
+ 添加一个全连接层，使用双曲正切tanh作为激活函数，tanh具有一个良好的性质，如下式所示，在BP算法时容易计算导数。  

 $$ \frac{d}{dx}\tanh x  = 1 - \tanh^2x$$

+ 全连接层的表示为  

 $$ g = \tanh(W_2 m) $$  

 其中$W_2$是一个$n_2 \times n_1$的矩阵，$n_2$是本层的输出个数。
+ 输出g是一个n2维的向量，可以认为是一个高级别向量（句子级别向量）-- higher level features (sentence level features)。

### output 输出
+ 组合词语级别的向量l和上面得到的句子级别的向量g，得到向量f，$f = [l,g]$，其维度为$n_3$。
+ 添加一个softmax层来计算最后的概率。  

 $$ o = W_3 f $$  
 $$ p = softmax(o) $$  

 其中$W_3$是一个$n_4 \times n_3$维的变换矩阵，n4是关系类别个数。o可以看作对应的类别的confidence score，最后使用softmax计算出条件概率。

### Backpropagation Training BP训练
+ 本文假设各个句子是相互独立的。
+ 涉及的参数有
$\Theta = (X,N,W_1,W_2,W_3)$，其中$N$是the word embeddings of WordNet hypernyms。
+ 本模型就是输入一个句子s，输出其中名词对所属类别的概率。
+ 目标函数是对数似然值log likelihood $J(\Theta)$, 使用随机梯度下降法（stochastic gradient descent (SGD)）进行训练。
+ $N, W_1, W_2, W_3$ 随机初始化， X 初始为词向量。

## Dataset and Evaluation Metrics 数据集和评测
+ 使用SemEval-2010 Task 8 dataset (Hendrickx et al., 2010)数据集（免费开放），其中包含10717个标注实例，
有8000个训练样本和2717个测试样本，包含9个带方向的关系类型和1个不带方向的关系类型。
+ 使用9个带方向的关系类型的the macro-averaged F1-scores来评测。

## Experiments 实验
做了三组实验：
+ 测试三个超参数窗口大小w，第一个隐藏层神经元个数n1，第二个隐藏层神经元个数n2对性能的影响。
+ 将本方法与其他传统方法的性能对比。
+ 测试各个特征的影响。

### Parameter Settings 参数设置
+ 使用 5-fold cross-validation
+ w，n1，n2太大的时候参数太多，容易over fitting，所以太大的时候性能差了。
+ <u>heuristically（启发式的） choose $d_e$ = 5</u> 词向量大小和学习速率与 Collobert et al. (2011)相同。
+ 下表为超参数的值。

| Hyperparameter | Window size | Word dim. | Distance dim. | Hidden layer 1 | Hidden layer 2 | Learning rate |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | 
| Value | w =3 | n =50 | de =5 | n1 =200 | n2 =100 | λ =0.01 |

### Results of Comparison Experiments 对比实验结果
+ 使用了7个对照组，前五个使用SVM和MaxEnt在Hendrickx et al. (2010)中出现，RNN使用Socher et al. (2012)中的模型，还有MVRNN。  
实验结果如表所示：

| Classifier |	Feature Sets |	F1 |
| :---: | :---: | :---: |
| SVM	| POS, stemming, syntactic patterns | 	60.1
| SVM	| word pair, words in between | 	72.5
| SVM	| POS, stemming, syntactic patterns, WordNet |	74.8
| MaxEnt	| POS, morphological, noun compound, thesauri, Google n-grams, WordNet |	77.6
| SVM	| POS, prefixes, morphological, WordNet, dependency parse, Levin classed, ProBank, FrameNet, NomLex-Plus, Google n-gram, paraphrases, TextRunner |	82.2
| RNN	| - |	74.8
| 	  |POS, NER, WordNet	| 77.6
| MVRNN	| - |	79.1
| 	  | POS, NER, WordNet | 	82.4
| Proposed |	word pair, words around word pair, WordNet |	82.7

+ 结论  
  - 使用传统方法时，特征越多越有效。  
  - 使用RNN时，语法树处理时的误差阻止了性能的提高。MVRNN有效的提取了意义组合meaning combination，性能更好。  
  - 我们的模型最好。

### The Effect of Learned Features 不同特征的影响
 
| Lexical	| L1	| 34.7 |
| :---: | :---: | :---: |
| 	| +L2	| 53.1 |
| 	| +L3	| 59.4 |
| 	| +L4	| 65.9 |
| 	| +L5	| 73.3 |
| Sentence | WF	| 69.7 |
| 	|+PF	 | 78.9 |
| Combination	| all	| 82.7 |

## Conclusion 总结

## TODO
- [ ] bag-of-words model
- [ ] WordNet hypernyms

## Question
+ 到底在哪里使用了卷积？文中写卷积的地方是一个矩阵相乘啊
+ 为什么要把PF映射成一个向量？