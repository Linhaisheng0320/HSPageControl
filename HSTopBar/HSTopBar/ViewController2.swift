//
//  ViewController2.swift
//  HSTopBar
//
//  Created by 林海生 on 2018/1/2.
//  Copyright © 2018年 林海生. All rights reserved.
//

import UIKit

class ViewController2: UIViewController,HSTopBarChildViewControllerDelegate {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateOnScrollThis(topBarViewController: HSTopBarViewController) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
