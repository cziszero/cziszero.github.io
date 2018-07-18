---
layout: post
title:  A Survey of Techniques for Internet Traffic Classification using ML论文阅读笔记
description:
date: 2017-09-15
categories: 
  - [论文阅读笔记 , 方法应用于网络]
  - [survery]

tags:
  - ML方法应用于网络
  - survey
---

## Abstract  
## Introduce  
### 传统方法  
根据TCP端口及内容推测。基于两个假设：  
1. 第三方可以获取到包内信息。
2. 知道包格式  
但现在两个假设都不容易满足，所以想要根据其他特性来对流量类型进行聚类。  
### 使用ML进行流量分类的步骤  
1. 定义特征（最大/小包的长度，典型包的长度，间隔时间等）
2. 使用ML方法训练和识别  
### 文章组织
* II概括了IP流量分类对网络操作的重要性，并介绍了如何评价分类的准确性，并讨论论文传统的根据端口和负载进行流量分类的缺点。
* III介绍了ML的背景知识和利用ML方法进行流量分类后操作网络的必要条件。
* IV主要介绍了2004-2007年的主要工作，并分析了他们是否满足了III中的条件。
* 总结和展望  
## II. Application context for machine learning based ip traffic classification  
### A. The importance of IP traffic classification  
1. QoS和依照QoS进行的计价系统需要IP分类
2. 合法的信息侦听（LI）  
### B. Traffic classification metrics  
1. Positives, negatives, accuracy, precision and recall
2. Byte and Flow accuracy  
## C. Limitations of packet inspection for traffic classification  
1. Port based IP traffic classification: 用户不用公开默认的端口，不到70%的准确率
2. Payload based IP traffic classification： 负载大，需要维护庞大的协议列表，可能违法  
## D. Classification based on statistical traffic properties  
假设： 每种流量的持续时间，间隔，长度等统计特性都不一样，可以根据这个来进行分类  
## III. Background on machine learning and the application of machine learning in ip traffic classification  
### A. A review of classification with Machine Learning  
Witten and Frank [29] 把学习方法分为4种：
* Classification (or supervised learning)  
决策树、朴素贝叶斯  
ROC曲线，Neyman Pearson criterion（给定FP，最大化TP）  
stratified cross-validation  
* Clustering (or unsupervised learning)  
k-means、 incremental clustering、probabilitybased clustering method  
评估：external criteria, internal criteria and relative criteria
* Association（联想）
* Numeric prediction

**特征选择**方法：
filter method or wrapper method（例如Correlation-based Feature Selection (CFS) filter techniques with Greedy, Best-First or Genetic search[29] [40] [41] [42] [43]） 

### B. The application of ML in IP traffic classification  
* 特征  
包的长度，到达时间的标准差，流的长度（bytes或包个数），间隔时间的傅里叶变换等  

When evaluating supervised ML schemes in an operational context it is worthwhile considering how the classifier will be supplied with adequate（充足的） supervised training examples, when it will be necessary to re-train, and how the user will detect a new type of applications.  
When evaluating unsupervised ML schemes in an operational context it is worthwhile considering how clusters will be labeled (mapped to specific applications), how labels will be updated as new applications are detected, and the optimal number of clusters (balancing accuracy, cost of labeling and label lookup, and computational complexity).

### C. Challenges for operational deployment  
* 及时并且连续的分类Timely and continuous classification  
要从流的任意地方开始，用尽量少的包就可以确定流的类型，而不能等到流完了再给出类型。
* Directional neutrality  
有些类型的流服务端到客户端和客户端到服务端的特性不一样，也无法预知哪个是服务端哪个是客户端，这种情况下要根据
任意一个方向的流来判断这个流的类型。
* Efficient use of memory and processors
* 可移植性和鲁棒性（Portability and Robustness）  
## IV. A review of machine learning based ip traffic classification techniques  
### A. Clustering Approaches  
1. 在2004年，McGregor等使用EM算法对HTTP, FTP, SMTP, IMAP, NTP和DNS流量进行聚类[48]，虽然现在我们对流量属于哪个应用更感兴趣，但这种方法在初期我们对网络流量一无所知的时候作为一种预处理方法来分析网络流量的性质还是很有帮助的。
2. Zander[46]在2005年使用AutoClass[50]来对流量进行分类，使用EM和贝叶斯聚类来确定类别。特征的计算也是分为两个方向，基于整个流进行的，但是设置了超时时间为60秒。之后在[48]中使用intra-class homogeneit H改进了评估方法。一个类别的H定义为该类别中最大量流所占比例，所有类别的H定义为各个类别的平均。目标为最大化H以实现不同应用流量的分离。实验证明，这种方法可以实现各应用流量的分离，并且特征越多，H越高，最高可以达到85%~89%。
这种方法按照应用的个数进行聚类和评估，每种应用作为一类。
3. TCP-based application identification using Simple KMeans  
在2006年，Bernaille[53]提出了一种使用K均值法进行聚类的方法，与前两种不同的是他可以利用TCP流的前几个包提前做出判断，基于前几个包包含了协商部分，这对于每个应用来说是独特的。训练过程是离线的，使用前p个包作为训练数据，使用欧氏距离来度量两个样本的距离。使用前5个包时，正确率超过80%。他的主要问题在于需要捕捉到前面的包。
4. Identifying Web and P2P traffic in the network core
Erman [47]在2007解决网络核心（the network core）的流量分类问题，网络核心流的信息是受限的，他们的方案是基于单向流的，并且发现了对于TCP连接，server-to-client方向的流量包含了更多的信息。也是使用了K均值法来聚类，使用欧氏距离来度量差别。该工作的主要贡献在于尝试提出了使用单向的网络流量进行分类的可能性，为了验证，他在server-to-client和client-to-server及混合流量上都做了实验。
开始时先对流量进行手动分类，然后进行聚类，把聚类得到的每个cluster中占比最大的一种流量作为该类（class）流量的标签。  
### B. Supervised Learning Approaches  
1. Statistical signature-based approach using NN, LDA and QDA algorithms  
在2005年，Roughan等[18]使用nearest neighbours (NN), linear discriminate analysis (LDA) and Quadratic Discriminant Analysis (QDA)机器学习方法将不同的网络应用映射到不同的QoS网络级别。作者列举了对整个流级别上可以利用的特征，并将它们分为5个类别。分别是：  
•	Packet Level:包长度的均值，方差，均方差等。  
•	Flow Level: 对每个方向的流计算持续时间，每个流的数据量，每个流包的数量（并求他们的均值和方差）  
•	Connection Level:TCP窗口大小，吞吐量的分布，连接的对称性  
•	Intra-flow/connection features:两个包之间的间隔时间  
•	Multi-flow:并发的连接数  
他们做了3个级别的实验，分别是分成3类(Bulk data (FTP-data), Interactive (Telnet), and Streaming (RealMedia);)，四类（Interactive (Telnet), Bulk data (FTP-data), Streaming (RealMedia) and Transactional (DNS)）和七类（DNS, FTP-data, HTTPS, Kazaa, RealMedia, Telnet and WWW.）类数越多，错误率越高，三类时错误率2.5% ~3.4%，5类时错误率5.1% ~7.9%，三类时错误率9.4% ~12.6%。
2. Classification using Bayesian analysis techniques  
2005年Moore and Zuev提出了应用朴素贝叶斯分类的方法来对流量进行分类，实现了大概65%左右的准确率。使用NBKE（Naive Bayes Kernel Estimation）和FCBF（Fast Correlation-Based Filter )优化后可以达到95%。Recall对于不同应用差别较大，比如www98%，bulk data90%，而services traffic44%，P2P55%。[55]使用贝叶斯网络优化了该方法，并达到了当日流量分类正确率99%，8个月后流量分类正确率95%的好成绩。
3. Real-time traffic classification using Multiple Sub-Flows features  
在2006年，Nguyen and Armitage [56]实验了使用部分包进行分类。他们使用multiple subflows特征训练分类器，首先从原始双向数据中抽取出数段长度为N个包的subflows，使用它上的统计特性作为分类的依据。使用朴素贝叶斯作为分类器。当使用全部流量但前面的几个包丢掉了的时候，性能相当差。而使用这种方法，sub-flow设置为25个包的时候，即使从中间开始也可以达到95%的召回率和98%的准确率。但其实验是在基于Web, DNS, NTP, SMTP, SSH, Telnet, P2P 等多种应用流量中分离出基于UDP的第一人称射击游戏的流量。
4. Real-time traffic classification using Multiple Synthetic Sub-Flows Pairs  
在2006年，Nguyen and Armitage[54]扩展了之前的工作，将截取的包反转作为反向流量加入到训练数据中来解决directional neutrality的问题。
5. GA-based classification techniques  
Park等[60]在2006年使用遗传算法来选择在[44]中提到的特征，并使用三种分类器（the Naive Bayesian classifier with Kernel Estimation (NBKE), Decision Tree J48 and the Reduced Error Pruning Tree (REPTree) ）分别进行了实验。
6. Simple statistical protocol fingerprint method  
Crotti等在2007年提出了一种新的基于IP包（IP包长度，两个包之间像个时间和到达顺序）的方法称之为protocol fingerprints，其特征使用PDF表示，PDFi 表示第i个二元组Pi (Pi = {si, Δti})，其中si表示第i个包的大小，Δti表示两个包之间的长度。然后作者又定义了一个anomaly score来衡量两个PDF之间统计特性的差以确定这个流量属于哪一累，最终在HTTP、SMTP和POP3上取得了91%的正确率。其问题也主要是需要捕获到第一个包并且需要区分出方向，对包的丢失或者重排序也无能为力。  
### C. Hybrid Approaches  
1. Erman[62]在2007年提出了一种半监督（semi-supervised）的方法来解决标注数据的缺乏和未知类别的处理两个问题。首先将部分带标签和部分不带标签的训练数据进行聚类，然后对聚得的cluster使用最大似然估计确定对应的class，对于某个cluster中没有标注过的数据，则将之设置为与最近的cluster的类别种类。  
### D. Comparisons and Related Work  
1. Comparison of different clustering algorithms  
2006年Erman[45]在两个数据集（the University of Auckland的公开数据集和the University of Calgary的私有数据）上测试了三种聚类算法（K-Means, DBSCAN and AutoClass），实验验证AutoClass的overall accuracy最高，K均值法次之，DBSCAN最差。
2. Comparison of clustering vs. supervised techniques  
Erman还使用recall, precision和overall accuracy三个指标在University of Auckland (NLANR)提供的两个72数据上，比较了朴素贝叶斯分类器和AutoClass聚类的区别。结果出乎意料的AutoClass全面优于朴素贝叶斯，作者分析原因应该是训练数据太少。除了结果之外，还比较了训练时间，AutoClass需要的训练时间远远超过朴素贝叶斯（2070s vs. 0.06s）。
3. Comparison of different supervised ML algorithms  
Williams[65]在公开的NLANR数据集上对比了不同分类算法（Naive Bayes with Discretisation (NBD), Naive Bayes with Kernel Density Estimation (NBK) , C4.5 Decision Tree, Bayesian Network, and Naive Bayes Tree）的性能。具体的，他们使用了三组特征，分别是所有的22个特征（见表），使用correlation-based feature selection (CFS) 和 consistency based feature selection (CON) 算法选择出来的特征子集。在全特征集上，除了NBK准确率为80%，其他分类算法都在95%以上。而是用两种特征子集都没有让分类算法的正确率发生大的衰退，最大的衰退只有2.5%。从算法性能来看，C4.5不论在哪个特征集上，其分类速度都是最快的，其他依次是NBD, Bayesian Network, Naive Bayes Tree, NBK。而模型的构建时间Naive Bayes Tree最长，其他依次是C4.5, Bayesian Network, NBD, NBK。
4. ACAS: Classification using machine learning techniques on application signatures  
Haffner[57]在2005年提出了一种使用ML方法构造应用指纹的思路，他分别实验了使用Naive Bayes, AdaBoost and Maximum Entropy三种方法对TCP单向流的前64bytes构造签名从而对流量进行分类，实验也取得了很好的效果，Recall可以达到94%，Precision可以达到99%。
5. Unsupervised approach for protocol inference using flow content  
在2006年，Ma[66]提出了另一种思路，即使用流的内容进行协议推理（protocol inference）而不是其统计信息进行分类。protocol 被定义为 ‘a pair of distributions on flows’ ，包括a byte sequence from the initiator to the responder 和a byte sequence from the responder to the initiator。它使用了product distribution, Markov processes, and common substring graphs (CSG)三种方法进行推理，取得了还不错的结果。
6. BLINC: Multilevel traffic classification in the dark:  
Karagiannis[15]开发了一种基于source host和传输层的行为进行分类的方法，利用包括源和目标地址及端口，传输协议，包的数量，大小等信息来描述source host的行为并对web, p2p, data transfer, network management traffic, mail, chat, media streaming, and gaming进行分类。作者总结出对于客户端其源端口和目的端口一般一样多，对于服务端一般源端口比目的端口少的特性。该方法提出了利用网络行为来进行区分节点角色和流量分类的新思路。
7. Pearson’s Chi-Square test and Naive Bayes classifier  
Bonfiglio[67]使用皮尔森卡方检验和朴素贝叶斯来实时的从一个流中识别出Skype流来，卡方检验的方法只需要看消息的前几个bytes，朴素贝叶斯只需要看连续的30个包。  
### E. Challenges for operational deployment  
1. Timely and continuous classification  
大部分工作（as [14] [18] [46] [48] [64] [65]）需要统计整个流的信息，[53]和[61]只需要统计前几个包的信息，但无法处理前面的包丢失的情况，[56]则使用了一个滑动窗口，所以它不需要必须捕获到最开始的包。
2. Directional neutrality  
大部分工作都使用了单向流( [14] [48] [53] [46] [68])并假设能知道流的方向，这给流的分类带来了遍历，但当不知道方向时就损害了性能。[54]则探究了不使用额外的信息来构建分类模型的方法。
3. Efficient use of memory and processors  
[14] 和[55]研究了分类准确性的潜力，但其特征数量很大，对于时间和空间的消耗很大。Williams[65]就研究了训练时间和分类时间的权衡。但其他的时间和正确性的权衡研究的并不多。
4. Portability and Robustness  
目前没有工作严肃的讨论了稳定性和可移植性的问题，没有实验在丢包，坏包，延迟及抖动等情况下的表现。虽然聚类方法理论上具备识别新流量的潜能，但之后[62]简单的提到了这一点。
5. Qualitative summary  
## V. Conclusion  
首先ML方法确实可以应用于流量分类。本综述介绍了使用不同的ML方法，例如AutoClass, Expectation Maximisation, Decision Tree, NaiveBayes进行离线分析和分类，证明最高可以到很高的正确率。以前的方法更注重静态的，统计的数据来进行离线分析，近来的工作更注重实用性。我们觉着基于ML的流量分类已经到了应用的临界点。
但现在也还有很大提升空间，例如要注意不同时间点的区别，换一个时间点可能就没有这么高的正确率。并且可以组合多种分类模型，提高计算效率，提高鲁棒性等。还有一些针对新兴应用的流量分类也需要进一步研究。
