## 环境要求

- iOS 10.0 以上
- Swift 5.0 以上

## 安装方法

### Cocoapods

在`podfile`中添加：

```
pod 'DDUtil', '~> 0.2.7'
```

### Manual

把本仓库下载到你本地，然后把`Sources`文件夹下的`Util`文件夹整个拖入Xcode，勾选拷贝文件选项即可，没有其它第三方依赖。

### 基础用法
#### DDToastView-Toast工具
Toast小窗工具DDToastView，弹窗位置支持视图的上、中、下、自定义位置，弹窗大小根据内容自适应。调用如下：
```
DDToastView.show("bring your ideas to life.",inView: self.view)
```
