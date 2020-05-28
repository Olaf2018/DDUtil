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

#### DDLoadingView-LodingView工具
DDLoadingView，是一个轻量级的loading等待动画的视图工具，可设置手势消失，可手动控制消失，使用在视图等待、数据等待等场景下，可参考调用示例：
```
DDToastView.show("bring your ideas to life.",inView: self.view)
```
```
// loading展示，默认无手势
DDLoadingView.show(inView: self.view)
```
```
// loading展示，设置手势隐藏
DDLoadingView.show(inView: self.view, tappable: true)
```
```
// loading隐藏
DDLoadingView.hide()
```
