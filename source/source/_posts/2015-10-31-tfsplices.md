# 获取所有op
 vs = []
 for i in [x for x in tf.get_default_graph().get_operations() ]:
     vs.append(i.name)
 vs = sorted(vs)
 for i in vs:
     print(i)