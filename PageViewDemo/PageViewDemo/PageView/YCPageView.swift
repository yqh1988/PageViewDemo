//
//  YCPageViewswift
//  PageView
//
//  Created by yangqianhua on2018/3/14.
//  Copyright © 2018年 yangqianhua. All rights reserved.
//

import UIKit

class YCPageView: UIView {
    
    /// 标题内容数据
    private var titles : [String]
    
    //子控制器数组
    private var childVcs : [UIViewController]
    
    //父控制器
    private var parentVc : UIViewController
    
    //标题样式
    private var style : YCTitleStyle
    
    //标题视图
    private var titleView : YCTitleView!
    
    //内容视图
    private var contentView : YCContentView!
    
    init(frame: CGRect, titles : [String], childVcs : [UIViewController], parentVc : UIViewController, style : YCTitleStyle) {
        
        assert(titles.count == childVcs.count, "标题&控制器个数不同,请检测!!!")
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.style = style
        
        super.init(frame: frame)
        //设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置UI界面
extension YCPageView {
    
    /// 设置UI
    private func setupUI() {
        //设置标题
        setupTitleView()
        //设置内容
        setupContentView()
    }
    
    /// 设置标题
    private func setupTitleView() {
        //标题frame
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeight)
        titleView = YCTitleView(frame: titleFrame, titles: titles, style : style)
        addSubview(titleView)
        titleView.backgroundColor = style.titleBgColor
        
        // 代理设置
        titleView.delegate = self
    }
    
    /// 设置内容
    private func setupContentView() {
        // 1.取到类型一定是可选类型
        let contentFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight)
        contentView = YCContentView(frame: contentFrame, childVcs: childVcs, parentVc: parentVc)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
        
        // 代理设置
        contentView.delegate = self
    }
}

// MARK:- 设置YCContentView的代理
extension YCPageView : YCContentViewDelegate {
    func contentView(_ contentView: YCContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        titleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func contentViewEndScroll(_ contentView: YCContentView) {
        titleView.contentViewDidEndScroll()
    }
}

// MARK:- 设置YCTitleView的代理
extension YCPageView : YCTitleViewDelegate {
    func titleView(_ titleView: YCTitleView, selectedIndex index: Int) {
        contentView.setCurrentIndex(index)
    }
}
