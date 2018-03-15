//
//  YCTitleStyle.swift
//  PageView-顶部标题的样式
//
//  Created by yangqianhua on2018/3/14.
//  Copyright © 2018年 yangqianhua. All rights reserved.
//

import UIKit

class YCTitleStyle {
    /// TitleView背景色
    var titleBgColor = UIColor.white
    /// 是否是滚动的Title
    var isScrollEnable : Bool = true
    /// 普通Title颜色
    var normalColor : UIColor = UIColor(r: 0, g: 0, b: 0)
    /// 选中Title颜色
    var selectedColor : UIColor = UIColor(r: 255, g: 127, b: 0)
    /// Title字体大小
    var font : UIFont = UIFont.systemFont(ofSize: 16.0)
    /// 滚动Title的字体间距
    var titleMargin : CGFloat = 20
    /// 设置titleView的高度
    var titleHeight : CGFloat = 44
    
    /// 是否显示底部滚动条
    var isShowBottomLine : Bool = false
    /// 底部滚动条的颜色
    var bottomLineColor : UIColor = UIColor.orange
    /// 底部滚动条的高度
    var bottomLineH : CGFloat = 2
    
    /// 是否进行缩放
    var isNeedScale : Bool = false
    /// 缩放比例
    var scaleRange : CGFloat = 1.2
    
    /// 是否显示遮盖
    var isShowCover : Bool = false
    /// 遮盖背景颜色
    var coverBgColor : UIColor = UIColor.lightGray
    /// 遮盖背景透明度
    var coverAlpha : CGFloat = 0.6
    /// 文字&遮盖间隙
    var coverMargin : CGFloat = 5
    /// 遮盖的高度
    var coverH : CGFloat = 25
    /// 设置圆角大小
    var coverRadius : CGFloat = 12
    
    /// 是否显示底部分割线
    var isShowSplitLine : Bool = true
    /// 底部分割线的颜色
    var splitLineColor : UIColor = UIColor.orange
    /// 底部分割线高度
    var splitLineH : CGFloat = 0.5
}
