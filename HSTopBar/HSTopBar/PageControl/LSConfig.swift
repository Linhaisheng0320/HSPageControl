//
//  LSConfig.swift
//  HSTopBar
//
//  Created by 林海生 on 2018/12/3.
//  Copyright © 2018年 林海生. All rights reserved.
//

import UIKit

//颜色
extension UIColor{
    ///不加#
    func colorWithHexCode(code : String) -> UIColor{
        let colorComponent = {(start : Int ,length : Int) -> CGFloat in
            let i = code.index(code.startIndex, offsetBy: start)
            let j = code.index(code.startIndex, offsetBy: start+length)
            var subHex = String(code[i..<j])
            subHex = subHex.count < 2 ? "\(subHex)\(subHex)" : subHex

            var component:UInt32 = 0
            Scanner(string: subHex).scanHexInt32(&component)
            return CGFloat(component) / 255.0
        }

        let argb = {() -> (CGFloat,CGFloat,CGFloat,CGFloat) in
            switch(code.count) {
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
