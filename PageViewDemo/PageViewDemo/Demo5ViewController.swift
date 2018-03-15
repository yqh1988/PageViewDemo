//
//  Demo5ViewController.swift
//  PageViewDemo
//
//  Created by yangqianhua on 2018/3/15.
//  Copyright © 2018年 yangqianhua. All rights reserved.
//

import UIKit

class Demo5ViewController: UIViewController {

    private var pageCollectionView :YCPageCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.red
        let style = YCTitleStyle()
        style.isScrollEnable = false
        style.isShowBottomLine = true
        style.normalColor = UIColor(r: 255, g: 255, b: 255)
        
        let layout = YCContentFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.cols = 4
        layout.rows = 2
        
        let pageViewFrame = CGRect.init(x: 0, y: 200, width: UIScreen.main.bounds.width, height: 300)
        pageCollectionView = YCPageCollectionView(frame: pageViewFrame, titles: ["游戏", "娱乐", "趣玩", "美女"], style: style, isTitleInTop: true, layout : layout)
        
        pageCollectionView.dataSource = self
        pageCollectionView.delegate = self
        
        pageCollectionView.register(cellClass: UICollectionViewCell.self, forCellID: "cell")
        
        self.view.addSubview(pageCollectionView)
    }
}

// MARK:- 数据设置
extension Demo5ViewController : YCPageCollectionViewDataSource, YCPageCollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func pageCollectionView(_ collectionView: UICollectionView, numsOfItemsInSection section: Int) -> Int {
        if(section == 0){
            return 12
        }else if(section == 1){
            return 22
        }else if(section == 2){
            return 32
        }else{
            return 6
        }
    }
    
    func pageCollectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = UIColor.randomColor()
        
        return cell
    }
    
    func pageCollectionView(_ collectionView: UICollectionView, didSelected atIndexPath: IndexPath) {
        print("点击了：\(atIndexPath)")
    }
}
