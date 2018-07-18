---
layout: post
title:  Tensorflow随笔
description: 
date: 2017-04-09
categories: 
  - [类库 , Tensorflow]
  - [语言 , Python]
tags:
  - Tensorflow
  - Python
---

# get started阅读笔记
## [Getting Started With TensorFlow](https://www.tensorflow.org/get_started/get_started)
* 一些包含contrib的方法是正在开发中的方法，可能会变。
* 概念
    1. Graph 表示计算任务，在Session中执行Graph，Graph中的节点是op。
    1. Variable维护状态，feed fetch赋值或取数。
    1. tensor 存储数据，tensor的shape表示其大小，rank表示其维度。
    1. 使用update = tf.assign()更新变量，但需要tf.Session.run(update)之后才会真正更新。
    1. op构造器的返回值是这个op的输出，可以传递给其他op构造器作为输入。
* Session 对象在使用完后需要关闭以释放资源. 除了显式调用 close 外, 也可以使用 "with" 代码块 来自动完成关闭动作.
*  with...Device 语句用来指派特定的 CPU 或 GPU 执行操作:
    
    with tf.Session() as sess:
        with tf.device("/gpu:1"):
        matrix1 = tf.constant([[3., 3.]])
        matrix2 = tf.constant([[2.],[2.]])
        product = tf.matmul(matrix1, matrix2)
        ...
* 为了便于使用诸如 IPython 之类的 Python 交互环境, 可以使用 InteractiveSession 代替 Session 类, 使用Tensor.eval() 和 Operation.run() 方法代替 Session.run() . 这样可以避免使用一个变量来持有会话.（P24）
* 在执行前，Variable要先初始化，可以调用Variable.initializer.run()进行。或者使用tf.global_variables_initializer().run()进行初始化。
* 可以在sess.run()中加入多个tensor，然后就可以一次返回，即为fetch。代码如result = sess.run([mul, intermed])
* feed机制用于临时代替图中的tensor，使用tf.placeholder()实现，在每次run()的时候要feed上数据，例如` sess.run([output], feed_dict={input1:[7.], input2:[2.]})`,run()结束后失效。使用`tensor.eval(feed_dict={})`也可以。
* 可以使用feed_dict代替任何tensor，而不仅仅是placeholder。
* 在创建模型之前，我们要先初始化权重和偏置，一般来说，初始化应加入轻微的噪声来打破对称性，防止0梯度的问题。
* 为了减少过拟合，我们在输出层之前加入 dropout。我们用一个 placeholder 来代表一个神经元在 dropout 中被保留的概率。这样我们可以在训练过程中启用 dropout，在测试过程中关闭 dropout。
TensorFlow 的tf.nn.dropout操作会自动处理神经元输出值的scale。所以用 dropout 的时候可以不用考虑 scale。

# TODO
dropout


# API
## tf
1. tf.truncated_normal(shape, mean=0.0, stddev=1.0, dtype=tf.float32, seed=None, name=None)  
 产生一个截尾正态随机分布
5. tf.reshape(tensor, shape, name=None)  
 将tensor转成shape的形状，shape中可以有一个维度是-1，此时由原tensor和其他的维度值共同计算出这个维度的值来。
2. tf.expand_dims(input, axis=None, name=None, dim=None)  
 在input的第axis位置添加一个长度为1的维度
3. tf.name_scope(name, default_name=None, values=None)  
 上下文管理器，定义op时使用
 
## tf.nn
2. tf.nn.conv2d(input, filter, strides, padding, use_cudnn_on_gpu=None, data_format=None, name=None)  
 CNN中的卷积计算
3. tf.nn.max_pool(value, ksize, strides, padding, data_format='NHWC', name=None)  
 CNN中的max-pooling计算
4. tf.nn.relu(features, name=None)  
 计算relu型激活函数
6. tf.nn.dropout(x, keep_prob, noise_shape=None, seed=None, name=None)  
 实现dropout技术。
7. tf.nn.softmax(logits, dim=-1, name=None)  
 实现softmax计算
8. tf.nn.zero_fraction(value, name=None)  
 计算value向量中0的比例，常用于评估稀疏状况

## tf.train
### tf.train.Saver

1. tf.train.Saver(var_list=None, reshape=False, sharded=False, max_to_keep=5, keep_checkpoint_every_n_hours=10000.0, name=None, restore_sequentially=False, saver_def=None, builder=None, defer_build=False, allow_empty=False, write_version=2, pad_step_number=False)  
 创建一个Saver，用于保存变量等

### tf.train.AdamOptimizer

1. tf.train.AdamOptimizer.compute_gradients(self, loss, var_list=None, gate_gradients=1, aggregation_method=None, colocate_gradients_with_ops=False, grad_loss=None)  
 minimize()的第一步，对loss中的var_list中的变量计算梯度，返回(gradient, variable)列表
2. optimizer.apply_gradients(grads_and_vars, global_step=None, name=None)  
 minimize()的第二步，根据上一部中计算出的梯度更新参数值。


### np.random
1. np.random.uniform(low=0.0, high=1.0, size=None)  
 生成shape样的均匀分布，范围是[low,high)
 


