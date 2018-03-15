//
//  YCContentView.swift
//  PageView-内容视图
//
//  Created by yangqianhua on2018/3/14.
//  Copyright © 2018年 yangqianhua. All rights reserved.
//

import UIKit

//CELLID
private let kContentCellID = "kContentCellID"

///内容代理
protocol YCContentViewDelegate : class {
    /// 内容滚动中执行的代理
    ///
    /// - Parameters:
    ///   - contentView: 内容视图
    ///   - progress: 滚动进度
    ///   - sourceIndex: 开始索引
    ///   - targetIndex: 目标索引
    func contentView(_ contentView : YCContentView, progress : CGFloat, sourceIndex : Int, targetIndex : Int)
    
    /// 结束滚动
    ///
    /// - Parameter contentView: YCContentView
    func contentViewEndScroll(_ contentView : YCContentView)
}

class YCContentView: UIView {
    //内容代理
    weak var delegate : YCContentViewDelegate?

    //子控制器数组
    private var childVcs : [UIViewController]
    
    //父控制器
    private var parentVc : UIViewController
    
    //滚动开始时的偏移值
    private var startOffsetX : CGFloat = 0
    
    //是否禁止滚动
    private var isForbidScrollDelegate : Bool = false
    
    /// 设置UICollectionView
    private lazy var collectionView : UICollectionView = {
        //设置布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        //设置数据源
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //注册CELL
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentCellID)
        
        //设置可以分页、无弹簧效果、不能点击状态栏滚动到顶部，不显示滚动条
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    /// 构造方法
    ///
    /// - Parameters:
    ///   - frame: 大小
    ///   - childVcs: 子控制器数组
    ///   - parentVc: 父控制器
    init(frame: CGRect, childVcs : [UIViewController], parentVc : UIViewController) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        
        //设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置UI
extension YCContentView {
    
    /// 设置UI
    private func setupUI() {
        // 1.将所有子控制器添加到父控制器中
        for childVc in childVcs {
            parentVc.addChildViewController(childVc)
        }
        
        // 2.添加UICollection用于展示内容
        addSubview(collectionView)
    }
}

// MARK: -UICollectionViewDataSource
extension YCContentView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //获取CELL
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentCellID, for: indexPath)
        
        //删除子视图
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        
        //获取到当前的字控制器，并设置大小
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        
        //将控制器的视图添加到CELL中
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}

// MARK:- UICollectionView的delegate
extension YCContentView : UICollectionViewDelegate {
    /// 开始拖动
    ///
    /// - Parameter scrollView: UIScrollView
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //禁止在滚动
        isForbidScrollDelegate = false
        
        // 当前的索引
        startOffsetX = scrollView.contentOffset.x
    }
    
    /// 滚动中代理
    ///
    /// - Parameter scrollView: UIScrollView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 0.判断是否是点击事件
        if isForbidScrollDelegate { return }
        
        // 1.定义获取需要的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        // 2.判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX { // 左滑
            // 1.计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            // 2.计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            
            // 4.如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        } else { // 右滑
            // 1.计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            // 2.计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
        }
        
        // 3.将progress/sourceIndex/targetIndex传递给titleView
        delegate?.contentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
        delegate?.contentViewEndScroll(self)
    }
    
    /// 滚动结束且弹簧效果结束
    ///
    /// - Parameter scrollView: UIScrollView
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.contentViewEndScroll(self)
    }
    
    /// 结束拖拽
    ///
    /// - Parameters:
    ///   - scrollView: UIScrollView
    ///   - decelerate: 是否结束弹簧效果
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //结束弹簧效果
        if !decelerate {
            delegate?.contentViewEndScroll(self)
        }
    }
}

// MARK:- 对外暴露的方法
extension YCContentView {
    func setCurrentIndex(_ currentIndex : Int) {
        
        // 1.记录需要进制执行代理方法
        isForbidScrollDelegate = true
        
        // 2.滚动正确的位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
