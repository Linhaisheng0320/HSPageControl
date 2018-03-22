//
//  HSSegmentView.swift
//  HSTopBar
//
//  Created by 林海生 on 2018/1/2.
//  Copyright © 2018年 林海生. All rights reserved.
//

import UIKit
//选择代理
protocol HSSegementViewDelegate: NSObjectProtocol{
    func selectedTitleItem(mcSegmentView: HSSegmentView, itemTag: Int)
}

class HSSegmentView: UIView {
    
    //下划线
    var curLine: UIView!
    
    weak var delegate: HSSegementViewDelegate?
    //存放当前选择的按钮tag
    var curSelected = 0{
        didSet {
            curSelectedItem()
        }
    }
    
    var titleButtons = [UIButton](){
        didSet {
            updateTitleButtons()
        }
    }
    
    convenience init(frame: CGRect, titleButtons: [UIButton]) {
        self.init(frame: frame)
        self.titleButtons = titleButtons
        self.updateTitleButtons()
    }
    
    //跟新选择器按钮
    private func updateTitleButtons(){
        for v in self.subviews{
            v.removeFromSuperview()
        }
        let all = self.titleButtons.count
        let w = self.frame.width/CGFloat(max(all,1))
        for i in 0..<all{
            self.titleButtons[i].frame = CGRect(x:CGFloat(i)*w,y: 0,width: w,height: self.frame.height)
            self.titleButtons[i].backgroundColor = UIColor.green
            self.titleButtons[i].setTitleColor(UIColor.white, for: .selected)
            self.titleButtons[i].setTitleColor(UIColor.black, for: .normal)
            
            self.titleButtons[i].tag = i
            self.titleButtons[i].titleLabel?.adjustsFontSizeToFitWidth = true
            //            self.titleButtons[i].adjustsImageWhenDisabled = true
            self.titleButtons[i].addTarget(self, action: #selector(self.didTitleItem(btn:)), for: .touchUpInside)
            self.addSubview(self.titleButtons[i])
        }
        self.curSelected = 0
    }
    
    //添加下划线
    func addCurLine()->UIView {
        if curLine == nil{
            self.curLine = UIView()
            self.curLine.backgroundColor = UIColor.clear
            
            let rect = CGRect(x:self.titleButtons[self.curSelected].center.x,y: self.frame.height,width: self.frame.width/CGFloat(self.titleButtons.count) - 30,height: 2)
            self.curLine.bounds = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
            self.curLine.center.x = rect.origin.x
            self.curLine.center.y = rect.origin.y
            self.curLine.frame = CGRect(x: self.curLine.frame.origin.x, y:  self.curLine.frame.origin.y, width: self.curLine.frame.width, height: self.curLine.frame.height)
            self.addSubview(self.curLine)
        }
        return self.curLine
    }
    
    
    @objc func didTitleItem(btn: UIButton){
        self.curSelected = btn.tag
        self.delegate?.selectedTitleItem(mcSegmentView: self, itemTag: btn.tag)
        if self.curLine != nil{
            UIView.animate(withDuration: 0.35, animations: { () -> Void in
                self.curLine.center.x = btn.center.x
            })
        }
    }
    
    private func curSelectedItem(){
        for i in 0..<self.titleButtons.count{
            self.titleButtons[i].isSelected = i==self.curSelected
        }
    }
    
    func curLineMove(x: CGFloat = 0){
        self.curLine.center.x = x + (self.frame.width/CGFloat(self.titleButtons.count))/2
    }
    
    //滑动结束时方法
    func lineEndMove(tag: Int){
        self.curSelected = tag
    }

}


//颜色
extension UIColor{
    ///不加#
    func colorWithHexCode(code : String) -> UIColor{
        let colorComponent = {(start : Int ,length : Int) -> CGFloat in
            let i = code.index(code.startIndex, offsetBy: start)
            let j = code.index(code.startIndex, offsetBy: start+length)
            var subHex = String(code[i..<j])
            subHex = subHex.characters.count < 2 ? "\(subHex)\(subHex)" : subHex
            var component:UInt32 = 0
            Scanner(string: subHex).scanHexInt32(&component)
            return CGFloat(component) / 255.0
        }
        
        let argb = {() -> (CGFloat,CGFloat,CGFloat,CGFloat) in
            switch(code.characters.count) {
            case 3: //#RGB
                let red = colorComponent(0,1)
                let green = colorComponent(1,1)
                let blue = colorComponent(2,1)
                return (red,green,blue,1.0)
            case 4: //#ARGB
                let alpha = colorComponent(0,1)
                let red = colorComponent(1,1)
                let green = colorComponent(2,1)
                let blue = colorComponent(3,1)
                return (red,green,blue,alpha)
            case 6: //#RRGGBB
                let red = colorComponent(0,2)
                let green = colorComponent(2,2)
                let blue = colorComponent(4,2)
                return (red,green,blue,1.0)
            case 8: //#AARRGGBB
                let alpha = colorComponent(0,2)
                let red = colorComponent(2,2)
                let green = colorComponent(4,2)
                let blue = colorComponent(6,2)
                return (red,green,blue,alpha)
            default:
                return (1.0,1.0,1.0,1.0)
            }}
        let color = argb()
        return UIColor(red: color.0, green: color.1, blue: color.2, alpha: color.3)
    }
}
