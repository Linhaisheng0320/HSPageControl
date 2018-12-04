//
//  Normal1ViewController.swift
//  HSTopBar
//
//  Created by 林海生 on 2018/12/4.
//  Copyright © 2018年 林海生. All rights reserved.
//

import UIKit

class Normal1ViewController: UIViewController,LSSegementViewDelegate,LSContentDelgate {
    var segmentView: LSSegmentView!
    var contentView: LSContentView!
    var vcArray: Array<UIViewController>!
    var v1: ViewController1!
    var v2:ViewController2!
    var v3:ViewController3!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.isTranslucent = false
        self.automaticallyAdjustsScrollViewInsets = true
        self.view.backgroundColor = UIColor.white;
        self.v1 = ViewController1()
//        v1.view.layer.insertSublayer(self.randomRainbowColor(), at: 0)

        self.v2 = ViewController2()
//        v2.view.layer.insertSublayer(self.randomRainbowColor(), at: 0)

        self.v3 = ViewController3()
//        v3.view.layer.insertSublayer(self.randomRainbowColor(), at: 0)

        self.segmentView = LSSegmentView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50), delegate: self, titleArray: ["view1","view2","view3"])
        self.view.addSubview(self.segmentView);
//        self.segmentView.backgroundColor = self.randomColor();

        self.contentView = LSContentView(frame: CGRect(x: 0, y: 50, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-50), parentViewController: self, segmentView: self.segmentView,delegate:self)
        self.view.addSubview(self.contentView)
        self.vcArray = [v1,v2,v3];
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func selectedTitleItem(mcSegmentView: LSSegmentView, itemTag: Int){

    }

    func numberOfLSContentView()->Int{
        return self.vcArray.count;
    }

    //初始化完成操作，如果需要对SegmentView进行自定义。
    func childViewController(childVC: UIViewController?,forIndex  index:Int)->UIViewController{
        return self.vcArray[index]
    }

    //MARK: - HSTopViewControllerDelegate
    //默认背景图
    func noChildDefaultBackground()->UIView{
        let v = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width*0.2/2, y: UIScreen.main.bounds.height*0.2/2, width: UIScreen.main.bounds.width*0.8, height: UIScreen.main.bounds.height*0.8))
        v.image = UIImage(named: "noData")
        return v
    }

    //HSTopBarLineView线条
    func topViewlineView()->UIView{
        let v = UIImageView()
        v.image = UIImage(named: "icon_more_up")
        v.frame.size.width = 7
        v.frame.size.height = 7
        return v
    }

    func randomColor()->UIColor{
        let red = CGFloat(arc4random()%256)/255.0
        let green = CGFloat(arc4random()%256)/255.0
        let blue = CGFloat(arc4random()%256)/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

    func other(){
        //定义渐变的颜色（从黄色渐变到橙色）
        let topColor = UIColor(red: 0xfe/255, green: 0xd3/255, blue: 0x2f/255, alpha: 1)
        let buttomColor = UIColor(red: 0xfc/255, green: 0x68/255, blue: 0x20/255, alpha: 1)
        let gradientColors = [topColor.cgColor, buttomColor.cgColor]

        //定义每种颜色所在的位置
        let gradientLocations:[NSNumber] = [0.0, 1.0]

        //创建CAGradientLayer对象并设置参数
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations

        //设置其CAGradientLayer对象的frame，并插入view的layer
        gradientLayer.frame = self.view.frame
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }

    func randomRainbowColor()->CAGradientLayer{
        let gradientColors = [UIColor.red.cgColor,
                              UIColor.orange.cgColor,
                              UIColor.yellow.cgColor,
                              UIColor.green.cgColor,
                              UIColor.cyan.cgColor,
                              UIColor.blue.cgColor,
                              UIColor.purple.cgColor]
        
        //定义每种颜色所在的位置
        let gradientLocations:[NSNumber] = [0.0, 0.17, 0.33, 0.5, 0.67, 0.83, 1.0]

        //创建CAGradientLayer对象并设置参数
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations

        //设置渲染的起始结束位置（横向渐变）
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)

        //设置其CAGradientLayer对象的frame，并插入view的layer
        gradientLayer.frame = self.view.frame
        return gradientLayer;
    }
}
