//
//  TimerExtension.swift
//  DDUtil
//
//  Created by DDB on 2020/3/11.
//  Copyright © 2020 DDWin. All rights reserved.
//

import UIKit

class TimerExtension: NSObject {
    /// Timer弱引用，自动添加进RunLoop
    class func weak_scheduledTimer(time: TimeInterval, target: NSObjectProtocol, selector: Selector, userInfo: Any?, repeats: Bool) -> Timer {
        let proxy = DDWeakTimer.init(target: target, sel: selector)
        let timer = Timer.scheduledTimer(timeInterval: time, target: target, selector: selector, userInfo: userInfo, repeats: repeats)
        proxy.timer = timer
        return timer
    }
    
    /// Timer弱引用，需手动添加进RunLoop
    class func weak_timer(time: TimeInterval, target: NSObjectProtocol, selector: Selector, userInfo: Any?, repeats: Bool) -> Timer {
        let proxy = DDWeakTimer.init(target: target, sel: selector)
        let timer = Timer.init(timeInterval: time, target: target, selector: selector, userInfo: userInfo, repeats: repeats)
        proxy.timer = timer
        return timer
    }
}
