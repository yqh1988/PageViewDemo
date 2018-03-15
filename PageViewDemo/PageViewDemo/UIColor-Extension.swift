//
//  PageViewDemoTests.swift
//  UIColor
//
//  Created by yangqianhua on 2018/3/14.
//  Copyright © 2018年 yangqianhua. All rights reserved.
//

import UIKit

extension UIColor {
    // 在extension中给系统的类扩充构造函数,只能扩充`便利构造函数`
    
    /// 通过RGB整数值构造
    ///
    /// - Parameters:
    ///   - r: 颜色R值
    ///   - g: 颜色G值
    ///   - b: 颜色B值
    ///   - alpha: 颜色alpha值
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat, alpha : CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    /// 通过十六进制值构造
    ///
    /// - Parameters:
    ///   - hex: alpha
    ///   - alpha: 颜色alpha值
    convenience init?(hex : String, alpha : CGFloat = 1.0) {
        
        // 0xff0000
        // 1.判断字符串的长度是否符合
        guard hex.count >= 6 else {
            return nil
        }
        
        // 2.将字符串转成大写
        var tempHex = hex.uppercased()
        
        // 3.判断开头: 0x/#/##
        if tempHex.hasPrefix("0x") || tempHex.hasPrefix("##") {
            tempHex = (tempHex as NSString).substring(from: 2)
        }
        if tempHex.hasPrefix("#") {
            tempHex = (tempHex as NSString).substring(from: 1)
        }
        
        // 4.分别取出RGB
        // FF --> 255
        var range = NSRange(location: 0, length: 2)
        let rHex = (tempHex as NSString).substring(with: range)
        range.location = 2
        let gHex = (tempHex as NSString).substring(with: range)
        range.location = 4
        let bHex = (tempHex as NSString).substring(with: range)
        
        // 5.将十六进制转成数字 emoji表情
        var r : UInt32 = 0, g : UInt32 = 0, b : UInt32 = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        
        self.init(r : CGFloat(r), g : CGFloat(g), b : CGFloat(b))
    }
    
    /// 随即色
    ///
    /// - Returns: 颜色
    class func randomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    
    /// 获取两个颜色值之间的差值
    ///
    /// - Parameters:
    ///   - firstColor: 第一个颜色
    ///   - seccondColor: 第二个颜色
    /// - Returns: 差值
    class func getRGBDelta(_ firstColor : UIColor, _ seccondColor : UIColor) -> (CGFloat, CGFloat,  CGFloat) {
        let firstRGB = firstColor.getRGB()
        let secondRGB = seccondColor.getRGB()
        
        return (firstRGB.0 - secondRGB.0, firstRGB.1 - secondRGB.1, firstRGB.2 - secondRGB.2)
    }
    
    /// 获取颜色的RGB的值
    ///
    /// - Returns: RGB值
    func getRGB() -> (CGFloat, CGFloat, CGFloat) {
        guard let cmps = cgColor.components else {
            fatalError("保证普通颜色是RGB方式传入")
        }
        
        return (cmps[0] * 255, cmps[1] * 255, cmps[2] * 255)
    }
}
