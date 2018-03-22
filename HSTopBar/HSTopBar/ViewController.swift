//
//  ViewController.swift
//  HSTopBar
//
//  Created by 林海生 on 2018/1/2.
//  Copyright © 2018年 林海生. All rights reserved.
//

import UIKit

class ViewController: HSTopBarViewController,HSTopViewControllerDelegate {
    let v1 = ViewController1()
    let v2 = ViewController2()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isDynamicVC = true
        self.delegate = self
        let vc1 = HSTopBarItem(title: "视图1", vc: v1)
        let vc2 = HSTopBarItem(title: "视图2", vc: v2)
        self.topBarItems = [vc1,vc2]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
}

