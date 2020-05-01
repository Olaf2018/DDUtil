//
//  ImageExtension.swift
//  DDUtil
//
//  Created by DDBB on 2020/4/26.
//  Copyright © 2020 DDWin. All rights reserved.
//

import UIKit

extension UIImage {
    /// 为图片添加文字。textStr: 添加的文本；point：文本坐标；textFont：文本字体；textColor文本颜色
    public func textDIY(_ textStr: String,
                        _ point: CGPoint = .zero,
                        _ textFont: CGFloat = 14.0,
                        _ textColor: UIColor = .black) -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(self.size, false, scale)
        let style = NSMutableParagraphStyle()
        style.alignment = .center

        let attributes = [NSAttributedString.Key.foregroundColor: textColor,
                          NSAttributedString.Key.paragraphStyle: style,
                          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let fontSpace: CGFloat = 3.0
        var rect: CGRect = CGRect(x: self.size.width/3, y: self.size.height - textFont - fontSpace, width: self.size.width/3, height: textFont)
        if point != .zero {
            rect = CGRect(x: point.x, y: point.y, width: self.size.width - point.x*2, height: textFont + fontSpace)
        }
        
        textStr.draw(in: rect, withAttributes: attributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
