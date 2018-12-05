# HSPageControl
swift 版本 简单的分页控制器、滑块视图联动的效果。

### 使用方式
下载Zip 
直接拖拽PageControl文件夹下所有文件

### 一、添加视图
```swift
var segmentView: LSSegmentView!
    var contentView: LSContentView!
    var vcArray: Array<UIViewController>!
    var v1: ViewController1!
    var v2: ViewController2!
    var v3: ViewController3!
    
override func viewDidLoad() {
      super.viewDidLoad()
      self.navigationController!.navigationBar.isTranslucent = false
      self.automaticallyAdjustsScrollViewInsets = true
      self.view.backgroundColor = UIColor.white;
        
      let titleArray = ["试图1","试图2","试图3"]
      self.segmentView = LSSegmentView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50), 
          delegate: self, titleArray: titleArray)
      self.view.addSubview(self.segmentView);

      self.contentView = LSContentView(frame: CGRect(x: 0, y: 50, width: UIScreen.main.bounds.size.width, 
          height: UIScreen.main.bounds.size.height-50), parentViewController: self, segmentView: self.segmentView,delegate:self)
      self.view.addSubview(self.contentView)
}
```


### 二、新增视图数组
```swift
        self.v1 = ViewController1()
        self.v2 = ViewController2()
        self.v3 = ViewController3()
        self.vcArray = [v1,v2,v3];
```


### 三、实现代理
```swift
    //分页数量
    func numberOfLSContentView()->Int{
        return self.vcArray.count;
    }
    //返回对应的分页试图
    //初始化完成操作，如果需要对SegmentView进行自定义。
    func childViewController(childVC: UIViewController?,forIndex  index:Int)->UIViewController{
        return self.vcArray[index]
    }
```
![](http://g.recordit.co/1bx8AGHq2P.gif)
