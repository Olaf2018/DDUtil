//
//  UIColorExtension.swift
//  DDUtil
//
//  Created by DDB on 2020/3/11.
//  Copyright © 2020 DDWin. All rights reserved.
//

import UIKit

extension UIColor {
    /// rgb(a)十进制
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha
        )
    }

    /// rgb(a)0xffffff十六进制
    convenience init(_ hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            alpha: alpha
        )
    }

    /// 参数：16进制字符串
    convenience init(_ hexStr: String) {
        let hex = strtoul(hexStr, nil, 16)
        self.init(Int(hex))
    }

    /// 随机色
    public class func randomColor() -> UIColor {
        return UIColor.init(red: CGFloat(arc4random_uniform(256)) / 255.0, green: CGFloat(arc4random_uniform(256)) / 255.0, blue: CGFloat(arc4random_uniform(256)) / 255.0, alpha: 1.0)
    }
    
    /// 用自身颜色生成UIImage
    public var image: UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
