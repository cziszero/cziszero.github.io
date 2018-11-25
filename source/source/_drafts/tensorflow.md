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

##  正则化
###  L1正则
###  L2正则

##  滑动平均

# tf中的初始化函数

# 常用op
##  `tf`

###  `tf.variable_scope(name)`
完整的签名为`tf.variable_scope(name_or_scope, default_name=None, values=None, initializer=None, regularizer=None, caching_device=None, partitioner=None, custom_getter=None, reuse=None, dtype=None, use_resource=None, constraint=None, auxiliary_name_scope=True)`，作用即为声明一个变量的作用域。
###  `tf.get_variable(name)`
完整的签名为`tf.get_variable(name, shape=None, dtype=None, initializer=None, regularizer=None, trainable=True, collections=None, caching_device=None, partitioner=None, validate_shape=True, use_resource=None, custom_getter=None, constraint=None)`,需要在variable_scope上下文中声明是否reuse，`with tf.variable_scope("foo", reuse=tf.AUTO_REUSE):`可以这样写，找不到则创建一个，如果找到了则返回已经创建的。
###  `tf.add_n(inputs, name=None)`
将inputs这个列表里面的tensor逐个相加
###  `tf.control_dependencies(control_inputs)`
创建一个 context manager 来控制依赖关系 
###  `tf.clip_by_value(t, clip_value_min, clip_value_max, name=None)`
将t限制在[clip_value_min, clip_value_max]内。
###  `tf.greater(x, y, name=None)`
逐元素计算x>y，返回一个与x，y大小相同的bool张量。
###  `tf.where(condition, x=None, y=None, name=None)`
根据condition逐元素的选择是x对应的值还是y对应的值。
###  `tf.add_to_collection(name, value)`
将一些tensor加入名为name的collection，反向操作是`tf.get_collection(key, scope=None)`

##  `tf.nn`
###  `tf.nn.conv2d(input, filter, strides, padding)`
`tf.nn.conv2d(input, filter, strides, padding, use_cudnn_on_gpu=True, data_format='NHWC', dilations=[1, 1, 1, 1], name=None)`
strides步长，第一维和最后一维必须为1。padding表示填充方式，'VALID'表示不填充，SAME表示填充0.
####  `tf.nn.bias_add(value, bias)`
`tf.nn.bias_add(value, bias, data_format=None, name=None)`用于在经过卷积核后加上bias
###  `tf.nn.max_pool/avg_pool`
`tf.nn.max_pool(value, ksize, strides, padding, data_format='NHWC', name=None)` max-pooling

###  `tf.nn.l2_loss(t, name=None)`
计算$output = sum(t^2)/2$，注意，这里没有开方。
###   `tf.nn.softmax_cross_entropy_with_logits(_sentinel=None, labels=None, logits=None, dim=-1, name=None)`
接在softmax后面计算cross entropy。
##  `tf.nn.sparse_softmax_cross_entropy_with_logits(_sentinel=None, labels=None, logits=None, name=None)`
`tf.nn.softmax_cross_entropy_with_logits`针对非多标记问题的优化实现。

##  `tf.contrib.layers`
###  `tf.contrib.layers.l1_regularizer(scale, scope=None)`
返回一个可以计算给定参数L1正则的函数，与之类似的还有`tf.contrib.layers.l1_regularizer(scale, scope=None)` 和 `tf.contrib.layers.l1_l2_regularizer(scale_l1=1.0, scale_l2=1.0, scope=None)`。  
与`tf.nn.l2_loss(t)`不同的是：这个返回一个函数，用于计算带系数的L2正则项，L2正则的计算完全相同。
##  ``

##  `tf.train`
###  tf.train.ExponentialMovingAverage(decay, num_updates=None, zero_debias=False)`
可以对一组var做指数滑动平均，对每个var维护一个shadow变量，算式为:

$$shadow_var = decay * shadow_var + (1-decay)*var$$

首先生成使用`ema = tf.train.ExponentialMovingAverage(decay, num_updates=None, zero_debias=False)`生成一个实例，然后使用`op = ema.assign([va,vb...vc])`指定要维护的变量列表，可以使用`ema.average(va)`指定要求滑动平均的变量。

##  指定gpu

# 片段
## 获取所有op
 vs = []
 for i in [x for x in tf.get_default_graph().get_operations() ]:
     vs.append(i.name)
 vs = sorted(vs)
 for i in vs:
     print(i)



