//
//  Demo3ViewController.swift
//  PageViewDemo
//
//  Created by yangqianhua on 2018/3/15.
//  Copyright © 2018年 yangqianhua. All rights reserved.
//

import UIKit

class Demo3ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // 标题
        let titles = ["关注", "推荐", "苏州", "视频", "热点", "新时代", "娱乐", "问答","图片","科技","懂车帝","体育","财经","军事","国际","段子","趣图","街拍","健康","数码","育儿","历史","小视频","其它"]
        
        //样式
        let style = YCTitleStyle()
        //可以滚动
        style.isScrollEnable = true
        
        // 子控制器
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
