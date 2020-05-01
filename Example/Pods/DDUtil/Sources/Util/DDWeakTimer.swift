//
//  DDWeakTimer.swift
//  DDUtil
//
//  Created by DDBB on 2020/3/11.
//  Copyright © 2020 DDWin. All rights reserved.
//

import UIKit

public class DDWeakTimer: NSObject {
    weak var target: NSObjectProtocol?
    var sel: Selector?
    
    ///实例化timer之后需要将timer赋值给proxy，否则就算释放了，timer依然会运行
    public weak var timer: Timer?
    
    public required init(target: NSObjectProtocol?, sel: Selector?) {
        super.init()
        self.target = target
        self.sel = sel
        guard target?.responds(to: sel) == true else {
            return
        }
        
        // selector替换，该方法会重新处理事件
        let method = class_getInstanceMethod(self.classForCoder, #selector(DDWeakTimer.replaceMethod))!
        class_replaceMethod(self.classForCoder, sel!, method_getImplementation(method), method_getTypeEncoding(method))
    }
    
    @objc func replaceMethod(){
        //target未释放则调用target方法，否则释放timer
        if self.target != nil {
            self.target?.perform(self.sel)
        } else {
            self.timer?.invalidate()
            print("timer 释放了")
        }
    }
}
