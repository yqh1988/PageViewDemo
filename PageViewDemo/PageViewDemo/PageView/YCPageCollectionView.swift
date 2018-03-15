//
//  YCPageCollectionView.swift
//  YCPageCollectionView
//
//  Created by apple on 16/11/11.
//  Copyright © 2016年 coderwYC. All rights reserved.
//

import UIKit

/// 数据代理
protocol YCPageCollectionViewDataSource : class {
    //一共有多少组
    func numberOfSections(in collectionView : UICollectionView) -> Int
    
    //每组的Item的数量
    func pageCollectionView(_ collectionView : UICollectionView, numsOfItemsInSection section : Int) -> Int
    
    //构造CELL
    func pageCollectionView(_ collectionView : UICollectionView, cellForItemAt indexPath : IndexPath) -> UICollectionViewCell
}


/// 行为代理
@objc protocol YCPageCollectionViewDelegate : class {
    //点击ITEM
    @objc optional func pageCollectionView(_ collectionView : UICollectionView, didSelected atIndexPath : IndexPath)
}

class YCPageCollectionView: UIView {
    
    // MARK: 对外属性
    //代理
    weak var dataSource : YCPageCollectionViewDataSource?
    weak var delegate : YCPageCollectionViewDelegate?
    
    // MARK: 内部属性
    //标题
    private var titles : [String]
    //样式
    private var style : YCTitleStyle
    //标题是否在顶部
    private var isTitleInTop : Bool = false
    //布局
    private var layout : YCContentFlowLayout
    
    //标题布局
    private var titleView : YCTitleView!
    //UICollectionView
    private var collectionView : UICollectionView!
    //分页控件
    private var pageControl : UIPageControl!
    
    private var sourceIndexPath : IndexPath = IndexPath(item: 0, section: 0)
    
    /// 构造方法
    ///
    /// - Parameters:
    ///   - frame: 位置
    ///   - titles: 标题
    ///   - style: 样式
    ///   - isTitleInTop: 标题是否在顶部
    ///   - layout: 布局
    init(frame: CGRect, titles : [String], style : YCTitleStyle, isTitleInTop : Bool, layout : YCContentFlowLayout) {
        self.titles = titles
        self.style = style
        self.isTitleInTop = isTitleInTop
        self.layout = layout
        
        super.init(frame: frame)
        
        //设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置UI
extension YCPageCollectionView {
    private func setupUI() {
        //标题的高度
        let titleH : CGFloat = style.titleHeight
        //标题的位置
        var titleFrame = CGRect(x: 0, y: 0, width: frame.width, height: titleH)
        //根据标题显示的位置修改Y轴位置
        titleFrame.origin.y = isTitleInTop ? 0 : frame.height - titleH
        
        //创建标题视图
        titleView = YCTitleView(frame: titleFrame, titles: titles, style: style)
        addSubview(titleView)
        titleView.delegate = self
        
        //创建分页控件
        let pageControlH : CGFloat = 20
        var pageControlFrame = CGRect(x: 0, y: 0, width: frame.width, height: pageControlH)
        pageControlFrame.origin.y = isTitleInTop ? frame.height - pageControlH : frame.height - titleH - pageControlH
        pageControl = UIPageControl(frame: pageControlFrame)
        pageControl.numberOfPages = 4
        pageControl.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        addSubview(pageControl)
        
        //创建UICollectionView
        var collectionViewFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - titleH - pageControlH)
        collectionViewFrame.origin.y = isTitleInTop ? titleFrame.maxY : 0
        collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        addSubview(collectionView)
    }
}

// MARK: - UICollectionView相关操作
extension YCPageCollectionView {
    func register(cellClass : AnyClass?, forCellID : String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: forCellID)
    }
    
    func regist(nib : UINib?, forCellID : String) {
        collectionView.register(nib, forCellWithReuseIdentifier: forCellID)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension YCPageCollectionView : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections(in: collectionView) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numOfSection = dataSource?.pageCollectionView(collectionView, numsOfItemsInSection: section) ?? 0
        
        // 设置第一组的分页
        if section == 0 {
            let numOfPage = (numOfSection - 1) / (layout.cols * layout.rows) + 1
            pageControl.numberOfPages = numOfPage
        }
        
        return numOfSection
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSource!.pageCollectionView(collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pageCollectionView?(collectionView, didSelected: indexPath)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionViewDidEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            collectionViewDidEndScroll()
        }
    }
    
    func collectionViewDidEndScroll() {
        
        // 获取该页第一个Cell
        let offsetX = collectionView.contentOffset.x
        let targetIndex = collectionView.indexPathForItem(at: CGPoint(x: offsetX + layout.sectionInset.left + 1, y: layout.sectionInset.top + 1))!
        
        pageControl.currentPage = (targetIndex.item) / (layout.cols * layout.rows)
        
        // 判断section发生改变
        if sourceIndexPath.section != targetIndex.section {
            titleView.setTitleWithProgress(1.0, sourceIndex: sourceIndexPath.section, targetIndex: targetIndex.section)
            
            sourceIndexPath = targetIndex
            
            let numOfSection = dataSource?.pageCollectionView(collectionView, numsOfItemsInSection: targetIndex.section) ?? 0
            let numOfPage = (numOfSection - 1) / (layout.cols * layout.rows) + 1
            pageControl.numberOfPages = numOfPage
        }
        
    }
}

// MARK: - YCTitleViewDelegate
extension YCPageCollectionView : YCTitleViewDelegate {
    func titleView(_ titleView: YCTitleView, selectedIndex index: Int) {
        let indexPath = IndexPath(item: 0, section: index)
        
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        collectionView.contentOffset.x -= layout.sectionInset.left
        
        let numOfSection = dataSource?.pageCollectionView(collectionView, numsOfItemsInSection: indexPath.section) ?? 0
        let numOfPage = (numOfSection - 1) / (layout.cols * layout.rows) + 1
        pageControl.numberOfPages = numOfPage
        pageControl.currentPage = 0
        
        sourceIndexPath = indexPath
    }
}
