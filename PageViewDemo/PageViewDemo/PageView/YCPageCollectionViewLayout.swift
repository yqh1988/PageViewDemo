//
//  YCTitleStyle.swift
//  PageView-UIColletionView布局
//
//  Created by yangqianhua on2018/3/14.
//  Copyright © 2018年 yangqianhua. All rights reserved.
//


import UIKit

class YCContentFlowLayout: UICollectionViewFlowLayout {
    
    //列数
    var cols : Int = 4
    //行数
    var rows : Int = 2
    
    //所有的布局属性数组
    private lazy var attrsArray : [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    //最大的宽度
    private lazy var maxW : CGFloat = 0
    
    override func prepare() {
        super.prepare()
        
        //每个ITEM的宽和高
        let itemW = (collectionView!.bounds.width - sectionInset.left - sectionInset.right - (CGFloat(cols) - 1) * minimumInteritemSpacing) / CGFloat(cols)
        let itemH = (collectionView!.bounds.height - sectionInset.top - sectionInset.bottom - CGFloat(rows - 1) * minimumLineSpacing) / CGFloat(rows)
        
        // 1.获取数据的多少组
        let sectionCount = collectionView!.numberOfSections
        
        // 2.给每组数据进行布局
        var pageNum = 0
        //循环处理每组
        for section in 0..<sectionCount {
            //每组的ITEM的个数
            let itemCount = collectionView!.numberOfItems(inSection: section)
            
            //循环处理每个ITEM
            for item in 0..<itemCount {
                //item的IndexPath
                let indexPath = IndexPath(item: item, section: section)
                
                //新建一个布局属性
                let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                //ITEM所属的页数
                let page = item / (cols * rows)
                //item在该页中的位置
                let index = item % (cols * rows)
                
                //计算ITEM的位置
                let x = (sectionInset.left + CGFloat(index % cols) * (itemW + minimumInteritemSpacing)) + collectionView!.bounds.width * CGFloat((page + pageNum))
                let y = sectionInset.top + CGFloat(index / cols) * (itemH + minimumLineSpacing)
                
                //设置Frame
                attrs.frame = CGRect(x: x, y: y, width: itemW, height: itemH)
                
                attrsArray.append(attrs)
            }
            
            let sectionNum = (itemCount - 1) / (cols * rows) + 1
            
            pageNum += sectionNum
        }
        
        // 3.计算最大width
        maxW = CGFloat(pageNum) * collectionView!.bounds.width
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsArray
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: maxW, height: 0)
    }
}


