//
//
//  YCTitleView.swift
//  PageView-顶部标题视图
//
//  Created by yangqianhua on2018/3/14.
//  Copyright © 2018年 yangqianhua. All rights reserved.
//

import UIKit

/// 标题栏中点击某一个标题执行的代理
protocol YCTitleViewDelegate : class {
    
    /// 标题栏中点击某一个标题执行的代理
    ///
    /// - Parameters:
    ///   - titleView: 标题栏View
    ///   - selectedIndex: 点击的标题的索引
    func titleView(_ titleView : YCTitleView, selectedIndex index : Int)
}

/// 顶部的标题栏
class YCTitleView: UIView {
    
    /// 标题栏中点击某一个标题执行的代理
    weak var delegate : YCTitleViewDelegate?
    
    //标题信息数组
    private var titles : [String]
    
    //标题的样式
    private var style : YCTitleStyle
    
    //当前选中的标题的索引
    private lazy var currentIndex : Int = 0
    
    /// 标题组件UILabel的数组
    private lazy var titleLabels : [UILabel] = [UILabel]()
    
    /// 标题的滚动视图
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        //设置不显示滚动条
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        //设置点击状态栏时不会滚动到最开头
        scrollView.scrollsToTop = false
        return scrollView
    }()
    
    ///底部分割线
    private lazy var splitLineView : UIView = {
        let splitView = UIView()
        //设置分割线的属性
        splitView.backgroundColor = style.splitLineColor
        let h : CGFloat = style.splitLineH
        splitView.frame = CGRect(x: 0, y: self.frame.height - h, width: self.frame.width, height: h)
        return splitView
    }()
    
    /// 底部标题栏
    private lazy var bottomLine : UIView = {
        let bottomLine = UIView()
        //设置标题栏的颜色
        bottomLine.backgroundColor = self.style.bottomLineColor
        return bottomLine
    }()
    
    ///覆盖的视图
    private lazy var coverView : UIView = {
        let coverView = UIView()
        coverView.backgroundColor = self.style.coverBgColor
        coverView.alpha = self.style.coverAlpha
        return coverView
    }()
    
    // MARK: 计算属性
    //未选中颜色RGB
    private lazy var normalColorRGB : (r : CGFloat, g : CGFloat, b : CGFloat) = self.getRGBWithColor(self.style.normalColor)
    
    //选中颜色RGB
    private lazy var selectedColorRGB : (r : CGFloat, g : CGFloat, b : CGFloat) = self.getRGBWithColor(self.style.selectedColor)
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - frame: 位置
    ///   - titles: 标题信息
    ///   - style: 标题组件样式
    init(frame: CGRect, titles : [String], style : YCTitleStyle) {
        self.titles = titles
        self.style = style
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //设置UI
        setupUI()
    }
}

// MARK: - 设置UI
extension YCTitleView {
    
    private func setupUI() {
        // 1.添加Scrollview
        addSubview(scrollView)
        
        // 2.添加底部分割线
        if(style.isShowSplitLine){
            addSubview(splitLineView)
        }
        
        // 3.设置所有的标题Label
        setupTitleLabels()
        
        // 4.设置Label的位置
        setupTitleLabelsPosition()
        
        // 5.设置底部的滚动条
        if style.isShowBottomLine {
            setupBottomLine()
        }
        
        // 6.设置遮盖的View
        if style.isShowCover {
            setupCoverView()
        }
    }
    
    /// 设置标题
    private func setupTitleLabels() {
        //循环设置标题
        for (index, title) in titles.enumerated() {
            //创建UILabel
            let label = UILabel()
            //设置UILabel相关的属性
            label.tag = index
            label.text = title
            label.textColor = index == 0 ? style.selectedColor : style.normalColor
            label.font = style.font
            label.textAlignment = .center
            
            // 添加点击手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_ :)))
            label.addGestureRecognizer(tapGes)
            
            //将label加入到一个数组中管理
            titleLabels.append(label)
            
            //添加标题组件
            scrollView.addSubview(label)
        }
    }
    
    /// 设置标题Frame
    private func setupTitleLabelsPosition() {
        //标题的x、宽、y、高
        var titleX: CGFloat = 0.0
        var titleW: CGFloat = 0.0
        let titleY: CGFloat = 0.0
        let titleH : CGFloat = frame.height
        
        //标题的数量
        let count = titles.count
        
        //循环设置标题的Frame
        for (index, label) in titleLabels.enumerated() {
            //可以滚动
            if style.isScrollEnable {
                //获取标题控件的大小
                let rect = (label.text! as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0.0), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : style.font], context: nil)
                
                //标题的宽度
                titleW = rect.width
                
                //第一个标题距离左侧为间距的一半
                if index == 0 {
                    titleX = style.titleMargin * 0.5
                } else {
                    //获取非第一个标题的位置
                    let preLabel = titleLabels[index - 1]
                    titleX = preLabel.frame.maxX + style.titleMargin
                }
                
            } else { //不可以滚动
                // 宽度是平分
                titleW = frame.width / CGFloat(count)
                titleX = titleW * CGFloat(index)
            }
            
            //设置label的Frame
            label.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
            
            // 标题放大
            if index == 0 && style.isNeedScale {
                let scale = style.scaleRange
                label.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        
        //可以滚动时设置内容大小
        if style.isScrollEnable {
            scrollView.contentSize = CGSize(width: titleLabels.last!.frame.maxX + style.titleMargin * 0.5, height: 0)
        }
    }
    
    /// 设置底部的线条
    private func setupBottomLine() {
        bottomLine.frame = titleLabels.first!.frame
        bottomLine.frame.size.height = style.bottomLineH
        bottomLine.frame.origin.y = bounds.height - style.bottomLineH
        
        scrollView.addSubview(bottomLine)
    }
    
    /// 设置覆盖视图
    private func setupCoverView() {
        //覆盖视图添加到scrollView
        scrollView.insertSubview(coverView, at: 0)
        //第一个标题
        let firstLabel = titleLabels[0]
        
        //位置信息
        var coverW = firstLabel.frame.width
        let coverH = style.coverH
        var coverX = firstLabel.frame.origin.x
        let coverY = (bounds.height - coverH) * 0.5
        
        if style.isScrollEnable {
            coverX -= style.coverMargin
            coverW += style.coverMargin * 2
        }else{
            
        }
        coverView.frame = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
        coverView.layer.cornerRadius = style.coverRadius
        coverView.layer.masksToBounds = true
    }
}

// MARK:- 事件处理
extension YCTitleView {
    
    /// 标题点击手势事件
    ///
    /// - Parameter tap: 手势
    @objc private func titleLabelClick(_ tap : UITapGestureRecognizer) {
        // 获取当前Label
        guard let currentLabel = tap.view as? UILabel else { return }
        
        // 如果是重复点击同一个Title,那么直接返回
        if currentLabel.tag == currentIndex { return }
        
        //print("currentLabel.tag:\(currentLabel.tag)---currentIndex:\(currentIndex)")
        
        // 获取之前的Label
        let oldLabel = titleLabels[currentIndex]
        
        // 切换文字的颜色
        currentLabel.textColor = style.selectedColor
        oldLabel.textColor = style.normalColor
        
        // 保存最新Label的下标值
        currentIndex = currentLabel.tag
        
        for label in titleLabels{
            if(label !== currentLabel){
                // 3.2.变化targetLabel
                label.textColor = style.normalColor
                label.transform = CGAffineTransform.identity
            }
        }
        
        // 通知代理
        delegate?.titleView(self, selectedIndex: currentIndex)
        
        // 居中显示
        contentViewDidEndScroll()
        
        // 调整bottomLine
        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.15, animations: {
                self.bottomLine.frame.origin.x = currentLabel.frame.origin.x
                self.bottomLine.frame.size.width = currentLabel.frame.size.width
            })
        }
        
        // 调整缩放比例
        if style.isNeedScale {
            oldLabel.transform = CGAffineTransform.identity
            currentLabel.transform = CGAffineTransform(scaleX: style.scaleRange, y: style.scaleRange)
        }
        
        // 遮盖视图移动
        if style.isShowCover {
            let coverX = style.isScrollEnable ? (currentLabel.frame.origin.x - style.coverMargin) : currentLabel.frame.origin.x
            let coverW = style.isScrollEnable ? (currentLabel.frame.width + style.coverMargin * 2) : currentLabel.frame.width
            UIView.animate(withDuration: 0.15, animations: {
                self.coverView.frame.origin.x = coverX
                self.coverView.frame.size.width = coverW
            })
        }
    }
}

// MARK:- 获取RGB的值
extension YCTitleView {
    private func getRGBWithColor(_ color : UIColor) -> (CGFloat, CGFloat, CGFloat) {
        guard let components = color.cgColor.components else {
            fatalError("请使用RGB方式给Title赋值颜色")
        }
        return (components[0] * 255, components[1] * 255, components[2] * 255)
    }
}

// MARK:- 对外暴露的方法
extension YCTitleView {
    func setTitleWithProgress(_ progress : CGFloat, sourceIndex : Int, targetIndex : Int) {
        
        // 1.取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 3.颜色的渐变(复杂)
        // 3.1.取出变化的范围
        let colorDelta = (selectedColorRGB.0 - normalColorRGB.0, selectedColorRGB.1 - normalColorRGB.1, selectedColorRGB.2 - normalColorRGB.2)
        
        // 4.记录最新的index
        currentIndex = targetIndex
        
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveTotalW = targetLabel.frame.width - sourceLabel.frame.width
        
        if(sourceIndex != targetIndex){
            
            // 3.2.变化sourceLabel
            sourceLabel.textColor = UIColor(r: selectedColorRGB.0 - colorDelta.0 * progress, g: selectedColorRGB.1 - colorDelta.1 * progress, b: selectedColorRGB.2 - colorDelta.2 * progress)
            
            // 3.2.变化targetLabel
            targetLabel.textColor = UIColor(r: normalColorRGB.0 + colorDelta.0 * progress, g: normalColorRGB.1 + colorDelta.1 * progress, b: normalColorRGB.2 + colorDelta.2 * progress)
            
            // 6.放大的比例
            if style.isNeedScale {
                let scaleDelta = (style.scaleRange - 1.0) * progress
                sourceLabel.transform = CGAffineTransform(scaleX: style.scaleRange - scaleDelta, y: style.scaleRange - scaleDelta)
                targetLabel.transform = CGAffineTransform(scaleX: 1.0 + scaleDelta, y: 1.0 + scaleDelta)
            }
        }
        
        // 5.计算滚动的范围差值
        if style.isShowBottomLine {
            bottomLine.frame.size.width = sourceLabel.frame.width + moveTotalW * progress
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + moveTotalX * progress
        }
        
        // 7.计算cover的滚动
        if style.isShowCover {
            coverView.frame.size.width = style.isScrollEnable ? (sourceLabel.frame.width + 2 * style.coverMargin + moveTotalW * progress) : (sourceLabel.frame.width + moveTotalW * progress)
            coverView.frame.origin.x = style.isScrollEnable ? (sourceLabel.frame.origin.x - style.coverMargin + moveTotalX * progress) : (sourceLabel.frame.origin.x + moveTotalX * progress)
        }
    }
    
    /// 滚动结束
    func contentViewDidEndScroll() {
        // 0.如果是不需要滚动,则不需要调整中间位置
        guard style.isScrollEnable else { return }
        
        // 1.获取获取目标的Label
        let targetLabel = titleLabels[currentIndex]
        
        // 2.计算和中间位置的偏移量
        var offSetX = targetLabel.center.x - bounds.width * 0.5
        if offSetX < 0 {
            offSetX = 0
        }
        
        let maxOffset = scrollView.contentSize.width - bounds.width
        if offSetX > maxOffset {
            offSetX = maxOffset
        }
        
        // 3.滚动UIScrollView
        scrollView.setContentOffset(CGPoint(x: offSetX, y: 0), animated: true)
    }
}

