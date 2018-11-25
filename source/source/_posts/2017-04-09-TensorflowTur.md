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

# tensorflow使用指定显卡及按需分配显存
``` python
# 声明可使用几号显卡
import os
os.environ['CUDA_VISIBLE_DEVICES'] = '0'
# 显存按需分配
config = tf.ConfigProto()
config.gpu_options.allow_growth = True
sess = tf.Session(config=config)
```
# 非线性激活函数

tensorflow中共有7中不同的非线性激活函数：
1. `tf.nn.relu`
2. `tf.sigmoid`
3. `tf.tanh`

# 损失函数
原则：损失函数的定义应该尽可能反应真实需求。
##  分类问题
###  交叉熵Cross Entropy
$$H(p,q)=-\sum_x{p(x)log{q(x)}}$$
衡量了两个概率分布的距离，$p(x)$为真实概率，$q(x)$为预测概率。
##  回归问题
###  均方误差MSE
$$MSE(y,y')=\frac{1}{n}\sum_{i=1}^n{(y-y')^2}$$

# 训练技巧
##  学习速率设置
1. 指数衰减Exponential Decay  
`tf.train.exponential_decay(init_learning_rate, global_step, decay_steps, decay_rate, staircase=False, name=None)`  
计算公式为:  

$$learning\_rate = init\_learning\_rate * decay\_rate^ {\frac{global\_step}{decay\_steps}}$$

一般所有样本过一个轮次换一次learning rate。

## 获取所有op
```python
 vs = []
 for i in [x for x in tf.get_default_graph().get_operations() ]:
     vs.append(i.name)
 vs = sorted(vs)
 for i in vs:
     print(i)
```

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
1. `tf.variable_scope(name)`
完整的签名为`tf.variable_scope(name_or_scope, default_name=None, values=None, initializer=None, regularizer=None, caching_device=None, partitioner=None, custom_getter=None, reuse=None, dtype=None, use_resource=None, constraint=None, auxiliary_name_scope=True)`，作用即为声明一个变量的作用域。
1.  `tf.get_variable(name)`
完整的签名为`tf.get_variable(name, shape=None, dtype=None, initializer=None, regularizer=None, trainable=True, collections=None, caching_device=None, partitioner=None, validate_shape=True, use_resource=None, custom_getter=None, constraint=None)`,需要在variable_scope上下文中声明是否reuse，`with tf.variable_scope("foo", reuse=tf.AUTO_REUSE):`可以这样写，找不到则创建一个，如果找到了则返回已经创建的。
1.  `tf.add_n(inputs, name=None)`
将inputs这个列表里面的tensor逐个相加
1.  `tf.control_dependencies(control_inputs)`
创建一个 context manager 来控制依赖关系 
1.  `tf.clip_by_value(t, clip_value_min, clip_value_max, name=None)`
将t限制在[clip_value_min, clip_value_max]内。
1.  `tf.greater(x, y, name=None)`
逐元素计算x>y，返回一个与x，y大小相同的bool张量。
1.  `tf.where(condition, x=None, y=None, name=None)`
根据condition逐元素的选择是x对应的值还是y对应的值。
1.  `tf.add_to_collection(name, value)`
将一些tensor加入名为name的collection，反向操作是`tf.get_collection(key, scope=None)`
 
## tf.nn
### `tf.nn.conv2d(input, filter, strides, padding)`
`tf.nn.conv2d(input, filter, strides, padding, use_cudnn_on_gpu=True, data_format='NHWC', dilations=[1, 1, 1, 1], name=None)`
strides步长，第一维和最后一维必须为1。padding表示填充方式，'VALID'表示不填充，SAME表示填充0.
### `tf.nn.max_pool/avg_pool`
`tf.nn.max_pool(value, ksize, strides, padding, data_format='NHWC', name=None)` max-pooling
### `tf.nn.relu(features, name=None)`  
 计算relu型激活函数
###  `tf.nn.bias_add(value, bias)`
`tf.nn.bias_add(value, bias, data_format=None, name=None)`用于在经过卷积核后加上bias
### `tf.nn.dropout(x, keep_prob, noise_shape=None, seed=None, name=None)`
 实现dropout技术。
### `tf.nn.softmax(logits, dim=-1, name=None)`  
 实现softmax计算
### `tf.nn.softmax_cross_entropy_with_logits(_sentinel=None, labels=None, logits=None, dim=-1, name=None)`
接在softmax后面计算cross entropy。
### `tf.nn.zero_fraction(value, name=None)`  
 计算value向量中0的比例，常用于评估稀疏状况
### `tf.nn.sparse_softmax_cross_entropy_with_logits(_sentinel=None, labels=None, logits=None, name=None)`
`tf.nn.softmax_cross_entropy_with_logits`针对非多标记问题的优化实现。
###  `tf.nn.l2_loss(t, name=None)`
计算$output = sum(t^2)/2$，注意，这里没有开方。

## tf.train

### `tf.train.ExponentialMovingAverage(decay, num_updates=None, zero_debias=False)`
可以对一组var做指数滑动平均，对每个var维护一个shadow变量，算式为:

$$shadow_var = decay * shadow_var + (1-decay)*var$$

首先生成使用`ema = tf.train.ExponentialMovingAverage(decay, num_updates=None, zero_debias=False)`生成一个实例，然后使用`op = ema.assign([va,vb...vc])`指定要维护的变量列表，可以使用`ema.average(va)`指定要求滑动平均的变量。

### tf.train.Saver

1. tf.train.Saver(var_list=None, reshape=False, sharded=False, max_to_keep=5, keep_checkpoint_every_n_hours=10000.0, name=None, restore_sequentially=False, saver_def=None, builder=None, defer_build=False, allow_empty=False, write_version=2, pad_step_number=False)  
 创建一个Saver，用于保存变量等

### tf.train.AdamOptimizer

1. `tf.train.AdamOptimizer.compute_gradients(self, loss, var_list=None, gate_gradients=1, aggregation_method=None, colocate_gradients_with_ops=False, grad_loss=None)  
 minimize()的第一步，对loss中的var_list中的变量计算梯度，返回(gradient, variable)列表
2. optimizer.apply_gradients(grads_and_vars, global_step=None, name=None)  
 minimize()的第二步，根据上一部中计算出的梯度更新参数值。

##  `tf.contrib.layers`
###  `tf.contrib.layers.l1_regularizer(scale, scope=None)`
返回一个可以计算给定参数L1正则的函数，与之类似的还有`tf.contrib.layers.l1_regularizer(scale, scope=None)` 和 `tf.contrib.layers.l1_l2_regularizer(scale_l1=1.0, scale_l2=1.0, scope=None)`。  
与`tf.nn.l2_loss(t)`不同的是：这个返回一个函数，用于计算带系数的L2正则项，L2正则的计算完全相同。



 


