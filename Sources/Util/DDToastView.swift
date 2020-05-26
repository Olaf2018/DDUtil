//
//  DDToastView.swift
//  Example
//
//  Created by DDBB on 2020/5/26.
//  Copyright © 2020 DDWin. All rights reserved.
//

import UIKit

public class DDToastView: UIView {
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    /// 中心点位置枚举
    enum Position {
        /// 屏幕中心
        case center
        /// 上方
        case up
        /// 下方
        case down
        /// 自定
        case custom(CGFloat)
    }
    
    // MARK: - 类方法
    
    /// 显示
    @discardableResult
    static func show(_ message: String, isNotAutoDismiss: Bool,
                     position: Position = .center, inView view: UIView) -> DDToastView {
        let toast = DDToastView()
        switch position {
        case .center:
            toast.contentCenterY = UIScreen.main.bounds.height * 0.5
        case .up:
            toast.contentCenterY = 237.5
        case .down:
            toast.contentCenterY = 429.5
        case .custom(let offset):
            toast.contentCenterY = offset
        }
        toast.show(withMessage: message, inView: view)
        toast.isNotAutoDismiss = isNotAutoDismiss
        return toast
    }
    
    /// 显示
    @discardableResult
    static func show(_ message: String, position: Position = .center, inView view: UIView) -> DDToastView {
        let toast = DDToastView()
        switch position {
        case .center:
            toast.contentCenterY = UIScreen.main.bounds.height * 0.5
        case .up:
            toast.contentCenterY = 237.5
        case .down:
            toast.contentCenterY = 429.5
        case .custom(let offset):
            toast.contentCenterY = offset
        }
        toast.show(withMessage: message, inView: view)
        return toast
    }
    
    // MARK: - 公开属性
    
    /// 中心坐标的Y轴偏移值，默认值0：位于屏幕中心无偏移
    var contentCenterY: CGFloat = UIScreen.main.bounds.height * 0.5 {
        didSet {
            setNeedsUpdateConstraints()
        }
    }
    /// 内容背景高度
    var  contentheight: CGFloat = 190 / 2
    /// 内容背景
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    /// 文字
    let messageLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
//        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    // MARK: - 私有属性
    
    /// 所有当前显示中的Toast，最后加入的排在最前
    private static var showingToasts = [DDToastView]()
    
    /// 动画时长
    private let animationDuration = 0.25
    
    /// 消失后回调
    private var dismissCallback: (() -> Void)?
    
    /// 是否自动消失
    private var isNotAutoDismiss: Bool = false
    
    // MARK: - 生命周期
    
    private override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(backgroundView)
        backgroundView.addSubview(messageLabel)
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(spaceDidTap))
        addGestureRecognizer(tap)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(spaceDidTap))
        addGestureRecognizer(pan)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func updateConstraints() {
        super.updateConstraints()
        guard let message = messageLabel.text else {
                   return
        }
        let maxWidth: CGFloat = screenWidth*4/5
        let maxHeight: CGFloat = screenHeight*4/5
        let commonInset: CGFloat = 10
        let string = NSMutableAttributedString.init(string: message)
               string.addAttributes([.font: UIFont.systemFont(ofSize: 16)], range: NSRange.init(location: 0, length: string.length))
        let rect = string.boundingRect(with: CGSize.init(width: maxWidth, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        let size = CGSize.init(width: CGFloat(ceilf(Float(rect.size.width))), height: CGFloat(ceilf(rect.size.height < maxHeight ? Float(rect.size.height) : Float(maxHeight))))
        messageLabel.frame = CGRect.init(x: commonInset, y: commonInset, width: size.width, height: size.height)
        backgroundView.frame = CGRect.init(x: (UIScreen.main.bounds.width - size.width - 2*commonInset)/2, y: contentCenterY, width: size.width + 2*commonInset, height: size.height + 2*commonInset)
        self.contentheight = backgroundView.frame.size.height
    }
    
    // MARK: - 公开方法
    
    /// 显示
    func show(withMessage message: String, inView view: UIView) {
        messageLabel.text = message
        // 如果与最近一个message相同，则不显示
        if isEqualToLastMessage() {
            return
        }
        
        // 若需要移动已存在toast，则等待其移动完成后再显示本toast
        // 否则有前面的toast待移动
        if moveShowingToasts() {
            // 等待其移动完毕再显示本toast
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration, execute: {
                self._show(inView: view)
            })
        } else {
            _show(inView: view)
        }
    }
    
    /// 消失
    func dismiss(animated: Bool) {
        if animated {
            UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseIn, .beginFromCurrentState], animations: {
                self.backgroundView.alpha = 0
            }) {  _ in
                self.removeSelf()
            }
        } else {
            self.removeSelf()
        }
    }
    
    /// 消失后，回调
    func addCallbackWhenDismissCompleted(_ callback: @escaping () -> Void) {
        dismissCallback = callback
    }
    
    // MARK: - 内部方法
    
    /// 显示
    @objc private func _show(inView view: UIView) {
        guard let message = self.messageLabel.text else { return }
        view.addSubview(self)
        DDToastView.showingToasts.insert(self, at: 0)
        
        self.backgroundView.alpha = 0
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.backgroundView.alpha = 1
        }) {  _ in
            if self.isNotAutoDismiss == false {
                // 根据message长度计算消失延时时间，单位毫秒，最大6秒
                let delay: Int = min(300 + message.count * 150, 6 * 1000)
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay), execute: {
                    self.dismiss(animated: true)
                })
            }
        }
    }
    
    /// 点空白
    @objc private func spaceDidTap() {
        dismiss(animated: true)
    }
    
    /// 把当前显示中的Toast向屏幕上方移动，若不需要移动则返回false，若有移动则返回true
    private func moveShowingToasts() -> Bool {
        if DDToastView.showingToasts.count <= 0 {
            return false
        }
        for (index, toast) in DDToastView.showingToasts.enumerated() {
            // 所遍历的toast应调整到的位置
            let position = contentCenterY - (CGFloat(index + 1) * (10 + toast.contentheight))
            // 如果此toast位置合格，则无需移动
            if toast.contentCenterY < (position - toast.contentheight / 2.0) {
                continue
            }
            if toast.contentCenterY < (position - toast.contentheight / 2.0) {
                continue
            }

            UIView.animate(withDuration: animationDuration, animations: {
                toast.layoutIfNeeded()
            })
        }
        return true
    }
    
    /// 从视图栈移除
    private func removeSelf() {
        self.removeFromSuperview()
        if let index = DDToastView.showingToasts.firstIndex(of: self) {
            DDToastView.showingToasts.remove(at: index)
        }
        if dismissCallback != nil {
            dismissCallback!()
            dismissCallback = nil
        }
    }
    
    /// 判断是否与最近一个message相同
    private func isEqualToLastMessage() -> Bool {
        if DDToastView.showingToasts.count <= 0 {
            return false
        }
        guard let element = DDToastView.showingToasts.first else {
            return false
        }
        return element.messageLabel.text == self.messageLabel.text
    }
}
