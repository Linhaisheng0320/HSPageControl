//
//  LSCollectionView.swift
//  HSTopBar
//
//  Created by 林海生 on 2018/12/3.
//  Copyright © 2018年 林海生. All rights reserved.
//

import UIKit
typealias LSShouldBeginHandler = (LSCollectionView, UIPanGestureRecognizer) -> Bool



class LSCollectionView: UICollectionView {
    var gestureBeginHandler : LSShouldBeginHandler?
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if (self.gestureBeginHandler != nil) && gestureRecognizer == self.panGestureRecognizer{
            return gestureBeginHandler!(self,gestureRecognizer as! UIPanGestureRecognizer)
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
