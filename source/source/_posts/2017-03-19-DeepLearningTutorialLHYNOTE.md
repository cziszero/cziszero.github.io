---
layout: post
title: Deep Learning Tutorial李宏毅 笔记
description:
date: 2017-03-19
categories: 
  - 论文阅读笔记
  - Deep Learning
tags:
  - 论文阅读笔记
  - Deep Learning
---

# Introduction of Deep Learning
## Introduction
* Three Steps for Deep Learning
  + define a set of function (Neural Network)
  + goodness of function
  + pick the best function
* Neural Network
  + Neuron
  + Softmax layer as the output layer
  + Gradient Descent
    - Gradient descent may not guarantee global minima
    - Backpropagation(反向传播算法):an efficient way to compute ${\partial}L/{\partial}W$
  
  
# Tips for Training Deep Neural Network
  + Choosing proper loss
    - When using softmax output layer, choose cross entropy
  + Mini-batch
    - Mini-batch has better performance and accuracy
  + New activation function
    - ReLU
    - Maxout
  + Adaptive Learning Rate
    - Popular & Simple Idea: Reduce the learning rate by some factor every few epochs.
    - Learning rate is smaller an smaller for all parameters
    - Smaller derivatives, larger learning rate, and vice versa
    - Adagrad [John Duchi, JMLR’11]
    - [RMSprop](https://www.youtube.com/watch?v=O3sxAc4hxZU)
    - Adadelta [Matthew D. Zeiler, arXiv’12]
    - “No more pesky learning rates” [Tom Schaul, arXiv’12]
    - AdaSecant [Caglar Gulcehre, arXiv’14]
    - Adam [Diederik P. Kingma, ICLR’15]
    - [Nadam](http://cs229.stanford.edu/proj2015/054_report.pdf)
  + Momentum
    - Still not guarantee reaching global minima, but give some hope
  + Panacea for Overfitting
    - have more training data
    - Create more training data
  + Early Stopping
  + Regularization
    - Weight Decay
  + Dropout
    - Dropout is a kind of ensemble
    - More reference for dropout [Nitish Srivastava, JMLR’14] [Pierre Baldi,NIPS’13][Geoffrey E. Hinton, arXiv’12]
    - Dropout works better with Maxout [Ian J. Goodfellow, ICML’13]
    - Dropconnect [Li Wan, ICML’13] Dropout delete neurons; Dropconnect deletes the connection between neurons
    - Annealed dropout [S.J. Rennie, SLT’14] Dropout rate decreases by epochs
    - Standout [J. Ba, NISP’13] Each neural has different dropout rate
  + Network Structure
# Variants of Neural Network
## Convolutional Neural Network(CNN)
### Why CNN for Image?
1. Some patterns are much smaller than the whole image 
2. The same patterns appear in different regions
3. Subsampling the pixels will not change the object

1.2. ==> Convolutional
3 ==> Max Pooling
## Recurrent Neural Network(RNN)
1. Long Short-term Memory (LSTM)
2. Backpropagation through time (BPTT)
  RNN Learning is very difficult in practice
3. Gated Recurrent Unit (GRU):simpler than LSTM
# Next Wave
## Supervised Learning
* Ultra Deep Network
* [Attention Mode](http://speech.ee.ntu.edu.tw/~tlkagk/courses/MLDS_2015_2/Lecture/Attain%20(v3).ecm.mp4/index.html)
## Reinforcement Learning
[Lectures of David Silver](http://www0.cs.ucl.ac.uk/staff/D.Silver/web/Teaching.html)
[Deep Reinforcement Learning](http://videolectures.net/rldm2015_silver_reinforcement_learning/)
## Unsupervised Learning

# 进一步阅读
[Keras Github](https://github.com/fchollet/keras/tree/master/examples)
[Keras Documents](http://keras.io/)
[MNIST Data](http://yann.lecun.com/exdb/mnist/)
http://jmlr.org/proceedings/papers/v9/glorot10a/glorot10a.pdf