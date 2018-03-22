//
//  HSTopBarViewController.swift
//  HSTopBar
//
//  Created by 林海生 on 2018/1/2.
//  Copyright © 2018年 林海生. All rights reserved.
//

@objc protocol HSTopViewControllerDelegate {
    //动态子VC时 无数据背景图
    @objc optional func noChildDefaultBackground()->UIView
    
    //下划线
    @objc optional func topViewlineView()->UIView
}

//child子视图刷新
protocol HSTopBarChildViewControllerDelegate: NSObjectProtocol{
    func updateOnScrollThis(topBarViewController:HSTopBarViewController)
}

struct HSTopBarItem{
    var title: String!
    var vc: UIViewController!
    
    init(title: String!, vc: UIViewController){
        self.title = title
        self.vc = vc
    }
}

import UIKit

class HSTopBarViewController: UIViewController,UIScrollViewDelegate,HSSegementViewDelegate {
    
    
    weak var delegate :HSTopViewControllerDelegate?
    
    //childVC List
    var topBarItems: [HSTopBarItem]?{
        didSet{
            self.childVCUpdate()
        }
    }
    
    var bodyTopView: HSSegmentView?
    
    var infoScrollView: UIScrollView?
    
    var backView: UIView?
    
    //MARK: -参数
    //动态子视图
    var isDynamicVC: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    //初始化Body视图
    func initBodyTop(){
        guard self.bodyTopView == nil else {
            return
        }
        
        self.bodyTopView = HSSegmentView()
        self.bodyTopView!.delegate = self
        self.bodyTopView!.frame = CGRect(x:0,y: 0,width: self.view.frame.size.width,height: 44)
        self.bodyTopView!.backgroundColor = UIColor.green
        self.view.addSubview(self.bodyTopView!)
        
        guard self.infoScrollView == nil else {
            self.infoScrollView!.frame = CGRect(x: 0, y: self.bodyTopView!.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height-self.bodyTopView!.frame.size.height)
            return
        }
        self.infoScrollView = UIScrollView()
        self.infoScrollView!.delegate = self
        self.infoScrollView!.alwaysBounceHorizontal = true
        self.infoScrollView!.showsHorizontalScrollIndicator = false
        self.infoScrollView!.isPagingEnabled = true
        self.infoScrollView!.frame = CGRect(x: 0, y: self.bodyTopView!.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height-self.bodyTopView!.frame.size.height)
        self.view.addSubview(self.infoScrollView!)
    }

    //部署
    func deployScrollView(){
        if self.topBarItems!.count < 1 {
            self.bodyTopView!.titleButtons = []
        }
        var btns = [UIButton]()
        for item in self.topBarItems!{
            let btn = UIButton()
            btn.setTitle(item.title, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btns.append(btn)
        }
        self.bodyTopView!.titleButtons = btns
        
        let w = UIScreen.main.bounds.width
        for (i, item) in self.topBarItems!.enumerated(){
            self.addChildViewController(item.vc)
            item.vc.view.frame = CGRect(x:CGFloat(i)*w,y: 0,width: w,height: self.infoScrollView!.frame.height)
            for v in item.vc.view.subviews{
                //当child视图含有UIScrollView时，修改UIScrollView的高度
                if let _ = v as? UIScrollView{
                    if (v.frame.size.height+v.frame.origin.y) > item.vc.view.frame.height{
                        v.frame.size.height -= (v.frame.size.height+v.frame.origin.y-item.vc.view.frame.height)
                    }
                }
            }
            self.infoScrollView!.addSubview(item.vc.view)
        }
        self.infoScrollView!.contentSize.width = CGFloat(self.topBarItems!.count)*w
    }
    
    //添加滑动下划线
    func addBottonLint(){
        if let view = self.delegate?.topViewlineView?(){
            _ = self.bodyTopView!.addCurLine()
            view.frame.origin.x = (self.bodyTopView!.addCurLine().frame.size.width-view.frame.size.width)/2
            view.frame.origin.y = -view.frame.size.height
            self.bodyTopView!.addCurLine().addSubview(view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //更新子ViewController
    func childVCUpdate(){
        //一.动态子视图。默认图片显示
        guard let childVC = self.topBarItems,childVC.count > 0 else{
            if isDynamicVC {
                //动态获取childVC时隐藏ScrollView
                for child in self.view.subviews {
                    child.removeFromSuperview()
                }
                guard let bv = self.delegate?.noChildDefaultBackground?() else {
                    return
                }
                
                self.backView?.removeFromSuperview()
                self.backView = UIView(frame: self.view.frame)
                self.backView?.addSubview(bv)
                self.view.addSubview(self.backView!)
            }
            return
        }
        
        self.backView?.removeFromSuperview()
        /* 一。 ============分割线==============*/
        
        //二.初始化Body(UIScrollView)
        self.initBodyTop()
        self.deployScrollView()
        /* 二。 ============分割线==============*/
        
        //五.下划线
        self.addBottonLint()
        /* 五。 ============分割线==============*/
    }
    
    //选择器点击代理
    func selectedTitleItem(mcSegmentView: HSSegmentView, itemTag: Int) {
        self.infoScrollView!.contentOffset.x = CGFloat(itemTag)*UIScreen.main.bounds.width
        self.loadDataByTag(tag: itemTag)
    }
    
    //刷新child数据
    func loadDataByTag(tag: Int){
        if let vc = self.topBarItems![tag].vc as? HSTopBarChildViewControllerDelegate{
            vc.updateOnScrollThis(topBarViewController: self)
        }
    }
    
    //MARK: UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        if scrollView != self.infoScrollView{
            return
        }
        let w = UIScreen.main.bounds.width
        guard scrollView.contentSize.width >= w else{
            return
        }
        
        let i = Int(scrollView.contentOffset.x/w)
        self.loadDataByTag(tag: i)
        
        //        let i = Int(x/(self.view.frame.width/CGFloat(self.bodyTopView.titleButtons.count)))
        self.bodyTopView?.lineEndMove(tag: i)
    }
    
    //UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        if scrollView != self.infoScrollView{
            return
        }
        let w = UIScreen.main.bounds.width
        guard scrollView.contentSize.width >= w else{
            return
        }
        self.bodyTopView?.curLineMove(x: (scrollView.contentOffset.x/scrollView.contentSize.width)*w)
    }

}
