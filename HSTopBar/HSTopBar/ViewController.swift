//
//  ViewController.swift
//  HSTopBar
//
//  Created by 林海生 on 2018/1/2.
//  Copyright © 2018年 林海生. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.isTranslucent = false
        self.automaticallyAdjustsScrollViewInsets = true
    }
    @IBAction func normal1(_ sender: UIButton) {
        let vc = Normal1ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

