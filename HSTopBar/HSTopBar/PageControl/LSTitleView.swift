//
//  LSTitleView.swift
//  HSTopBar
//
//  Created by 林海生 on 2018/12/3.
//  Copyright © 2018年 林海生. All rights reserved.
//

import UIKit

class LSTitleView: UIView {
    var selectColor: UIColor = UIColor.red //选择颜色
    var normalColor: UIColor = UIColor.black //默认颜色

    var clickBtn: UIButton! //底部按钮

    //标题
    var title:String = ""{
        didSet{
            self.titleLabel.text = title
            self.titleLabel.sizeToFit()
            self.titleLabel.center = CGPoint(x: self.frame.size.width/2,y:self.frame.size.height/2)
        }
    }
    var titleLabel: UILabel! //标题Label

    //是否点击
    var isSelected: Bool = false {
        didSet{
            if isSelected{
                self.titleLabel.textColor = selectColor
            }else{
                self.titleLabel.textColor = normalColor
            }

            self.titleLabel.sizeToFit()
            self.titleLabel.center = CGPoint(x: self.frame.size.width/2,y:self.frame.size.height/2)
        }
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLabel = UILabel()
        self.clickBtn = UIButton()
        self.clickBtn.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        self.addSubview(self.clickBtn)
        self.addSubview(self.titleLabel)
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
