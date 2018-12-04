//
//  LSSegmentView.swift
//  HSTopBar
//
//  Created by 林海生 on 2018/12/3.
//  Copyright © 2018年 林海生. All rights reserved.
//

import UIKit

//选择代理
@objc protocol LSSegementViewDelegate: NSObjectProtocol{
    //点击操作代理
    func selectedTitleItem(mcSegmentView: LSSegmentView, itemTag: Int)

    //初始化完成操作，如果需要对SegmentView进行自定义。
    @objc optional func viewForIndexAtSegmentView(titleView: LSTitleView,index:Int,title:String)

}

typealias extraBtnOnClick = (UIButton)->()
class LSSegmentView: UIView,UIScrollViewDelegate {

     var scrollView: UIScrollView!

    //下划线
    var curLine: UIView!

    var clickBlack: extraBtnOnClick?

    weak var delegate: LSSegementViewDelegate?
    //存放当前选择的按钮tag
    var curSelected = 0{
        didSet {
            curSelectedItem()
        }
    }

    var titleArray = [String](){
        didSet {
            updateTitleButtons()
        }
    }

    var titleViewArray = [LSTitleView]()

    convenience init(frame: CGRect,delegate : LSSegementViewDelegate,titleArray:[String]) {
        self.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.delegate = delegate;
        self.initView()

        self.titleArray = titleArray
        self.updateTitleButtons()
    }

    private func initView(){
        //底部滑动
        self.scrollView = UIScrollView()
        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.scrollsToTop = false
        self.scrollView.bounces = true
        self.scrollView.isPagingEnabled = false
        self.scrollView.delegate = self
        self.addSubview(self.scrollView)
    }

    //跟新选择器按钮
    private func updateTitleButtons(){
        for v in self.scrollView.subviews{
            v.removeFromSuperview()
        }
        self.titleViewArray.removeAll()
        let all = self.titleArray.count
        let w = self.frame.width/CGFloat(max(all,1))
        for i in 0..<all{
            let titleView = LSTitleView(frame: CGRect(x:CGFloat(i)*w,y: 0,width: w,height: self.frame.height))
            titleView.title = self.titleArray[i]
            titleView.clickBtn.tag = i;
            titleView.clickBtn.addTarget(self, action: #selector(didTitleItem), for: UIControlEvents.touchUpInside)
            self.scrollView.addSubview(titleView)
            self.titleViewArray.append(titleView)
        }
        self.curSelected = 0
        let _ = self.addCurLine()
    }

    //添加下划线
    @objc func addCurLine()->UIView {
        if curLine == nil{
            self.curLine = UIView()
            self.addSubview(self.curLine)
        }
        self.curLine.backgroundColor = UIColor.red

        let rect = CGRect(x:self.titleViewArray[self.curSelected].center.x,y: self.frame.height,width: self.frame.width/CGFloat(self.titleViewArray.count) - 30,height: 2)
        self.curLine.bounds = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
        self.curLine.center.x = rect.origin.x
        self.curLine.center.y = rect.origin.y
        self.curLine.frame = CGRect(x: self.curLine.frame.origin.x, y:  self.curLine.frame.origin.y, width: self.curLine.frame.width, height: self.curLine.frame.height)
        return self.curLine
    }


    @objc func didTitleItem(btn: UIButton){
        self.clickBlack?(btn)
        self.scrollMove(tag: btn.tag)
        self.delegate?.selectedTitleItem(mcSegmentView: self, itemTag: btn.tag)
    }

    private func curSelectedItem(){
        for i in 0..<self.titleViewArray.count{
            self.titleViewArray[i].isSelected = i==self.curSelected
        }
    }

    
    //滑动结束时方法
    func scrollMove(tag: Int){
        self.curSelected = tag
        if self.curLine != nil{
            UIView.animate(withDuration: 0.35, animations: { () -> Void in
                self.curLine.center.x = self.titleViewArray[self.curSelected].center.x
            })
        }
    }

}

