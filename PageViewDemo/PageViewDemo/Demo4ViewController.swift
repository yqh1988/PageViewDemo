//
//  Demo4ViewController.swift
//  PageViewDemo
//
//  Created by yangqianhua on 2018/3/15.
//  Copyright © 2018年 yangqianhua. All rights reserved.
//

import UIKit

class Demo4ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /// 标题
        let titles = ["推荐","游戏", "娱乐", "趣玩", "美女"]
        //样式
        let style = YCTitleStyle()
        //可以滚动
        style.isScrollEnable = false
        
        // 所以的子控制器
        var childVcs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childVcs.append(vc)
        }
        
        // pageView的frame
        let pageFrame = CGRect(x: 0, y: NavH, width: view.bounds.width, height: view.bounds.height - 64)
        
        // 创建YCPageView,并且添加到控制器的view中
        let pageView = YCPageView(frame: pageFrame, titles: titles, childVcs: childVcs, parentVc: self, style : style)
        view.addSubview(pageView)
    }

}
