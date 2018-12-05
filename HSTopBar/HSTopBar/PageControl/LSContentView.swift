//
//  LSContentView.swift
//  HSTopBar
//
//  Created by 林海生 on 2018/12/3.
//  Copyright © 2018年 林海生. All rights reserved.
//

import UIKit


protocol LSContentDelgate: NSObjectProtocol{
    //点击操作代理
    func numberOfLSContentView()->Int

    //初始化完成操作，如果需要对SegmentView进行自定义。
    func childViewController(childVC: UIViewController?,forIndex  index:Int)->UIViewController

}

protocol LSScrollPageViewChildVcDelegate: NSObjectProtocol{

}


class LSContentView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    var currentIndex: NSInteger = 0; //当前页
    var childVCDic = Dictionary<String, UIViewController>()
    var currentChildVC: UIViewController?
    private weak var parentVC: UIViewController!//主View的引用
    private weak var segmentView: LSSegmentView!
    weak var delegate: LSContentDelgate?
    var collectionView:LSCollectionView!
    var forbidTouchToAdjustPosition:Bool = false
    var oldOffSetX:CGFloat = 0
    var oldIndex:CGFloat = 0
    var scrollOverOnePage: Bool = false
    var changeAnimated: Bool = false

    convenience init(frame: CGRect,parentViewController:UIViewController,segmentView:LSSegmentView,delegate:LSContentDelgate) {
        self.init(frame: frame)
        self.parentVC = parentViewController
        self.segmentView = segmentView
        self.delegate = delegate
        self.segmentView.clickBlack = {[weak mySelf = self](btn : UIButton) in
            mySelf?.setContentOffSet(offset: CGPoint(x: (mySelf?.bounds.size.width ?? 0)*CGFloat(btn.tag), y: 0), animated: false)
        }
        self.initView()
    }
    

    private override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initView(){
        let layout = UICollectionViewFlowLayout();
        layout.itemSize = self.bounds.size;
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal;

        self.collectionView = LSCollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height
        ), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
//        let backView = UIView()
//        backView.frame = UIScreen.main.bounds
//        let backImage = UIImageView(image: UIImage(named: ""));
//        backImage.frame = UIScreen.main.bounds
//        backImage.addSubview(backImage)
//        collectionView.backgroundView = backView;


        collectionView.isPagingEnabled = true;
        collectionView.scrollsToTop = false;
        collectionView.showsHorizontalScrollIndicator = false;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.bounces = true;
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
//        collectionView.bounces = self.segmentView.segmentStyle.isContentViewBounces;
//        collectionView.scrollEnabled = self.segmentView.segmentStyle.isScrollContentView;
        self.addSubview(collectionView)

    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.delegate?.numberOfLSContentView() ?? 1;
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (currentIndex != indexPath.row){
            return;
        }
        guard let _ = self.delegate else{
            assert(false, "必须设置代理和实现代理方法")
            return;
        }
        self.currentChildVC = childVCDic["\(indexPath.row)"];
        if let _ = self.currentChildVC{
            let _ = self.delegate!.childViewController(childVC: self.currentChildVC!, forIndex: indexPath.row)
        }else{
            self.currentChildVC = self.delegate!.childViewController(childVC: nil, forIndex: indexPath.row)
            // 设置当前下标
            self.childVCDic["\(indexPath.row)"] = self.currentChildVC
        }
        self.parentVC.addChildViewController(self.currentChildVC!)
        self.currentChildVC!.view.frame = cell.contentView.bounds;
        cell.contentView.addSubview(self.currentChildVC!.view)
        //    NSLog(@"当前的index:%ld", indexPath.row);
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

    }
}

extension LSContentView:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.forbidTouchToAdjustPosition || // 点击标题滚动
            scrollView.contentOffset.x <= 0 || // first or last
            scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.bounds.size.width) {
            return;
        }
        let tempProgress = scrollView.contentOffset.x / self.bounds.size.width;
        let tempIndex = tempProgress;
        var progress = tempProgress - floor(tempProgress);
        let deltaX = scrollView.contentOffset.x - oldOffSetX
        if (deltaX > 0) {// 向左
            if (progress == 0.0) {
                return;
            }
            self.currentIndex = NSInteger(tempIndex+1);
            self.oldIndex = tempIndex;
        }
        else if (deltaX < 0) {
            progress = 1.0 - progress;
            self.oldIndex = tempIndex+1;
            self.currentIndex = NSInteger(tempIndex);
        }
        else {
            return;
        }

//        [self contentViewDidMoveFromIndex:_oldIndex toIndex:_currentIndex progress:progress];

    }

    /** 滚动减速完成时再更新title的位置 */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = (scrollView.contentOffset.x / self.bounds.size.width)
        self.segmentView.scrollMove(tag: Int(currentIndex))
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.oldOffSetX = scrollView.contentOffset.x
        self.forbidTouchToAdjustPosition = false;
    }

    func setContentOffSet(offset:CGPoint,animated:Bool) {
        self.forbidTouchToAdjustPosition = true;
        let currentIndex = offset.x/self.collectionView.bounds.size.width;
        self.oldIndex = CGFloat(self.currentIndex);
        self.currentIndex = NSInteger(currentIndex);
        self.scrollOverOnePage = false;

        let page = labs(self.currentIndex-Int(self.oldIndex));
        if (page>=2) {// 需要滚动两页以上的时候, 跳过中间页的动画
            self.scrollOverOnePage = true;
        }

        self.collectionView.setContentOffset(offset, animated: animated)
    }
}
