//
//  DDLoadingView.swift
//  Example
//
//  Created by DDBB on 2020/5/28.
//  Copyright © 2020 DDWin. All rights reserved.
//

import UIKit

public class DDLoadingView: UIView {
    
    // MARK: - private
    
    /// 正在显示的loading
    private static var showingView: DDLoadingView?
    
    /// 点的直径
    private let dotSize: CGFloat = 10
    
    /// 区域宽高
    private let contentLength: CGFloat = 40
    
    /// 动画时长
    private let animationDuration = 2.0
    
    /// 容器
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        return view
    }()
    
    // MARK: - public
        
    /// 显示，tappable: 是否支持点击消失
    @discardableResult
    public static func show(inView view: UIView? = nil, tappable: Bool = false) -> DDLoadingView {
        if let showingView = DDLoadingView.showingView {
            if showingView.superview == view {
                return showingView
            }
            showingView.dismiss(animated: false)
        }
        return DDLoadingView().show(inView: view, tappable: tappable)
    }
    
    /// 隐藏
    public static func hide(animated: Bool = true) {
        guard let showingView = DDLoadingView.showingView else {
            return
        }
        showingView.dismiss(animated: animated)
    }
    
    /// 点击手势
    private lazy var singleTap: UITapGestureRecognizer = { [unowned self] in
        return UITapGestureRecognizer(target: self, action: #selector(didSingleTap))
    }()
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentView)
        contentView.layer.cornerRadius = dotSize
        contentView.layer.masksToBounds = true
    }
    
    private convenience init() {
        self.init(frame: .zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 显示
    @discardableResult
    public func show(inView view: UIView? = nil, tappable: Bool = false) -> Self {
        DDLoadingView.showingView?.dismiss(animated: false)
        let view = view ?? UIView()
        DDLoadingView.showingView = self
        view.addSubview(self)
        frame = view.bounds
        
        contentView.frame.size = CGSize(width: contentLength * 1.8, height: contentLength * 1.8)
        contentView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        
        let size = CGSize(width: contentLength, height: contentLength)
        setupAnimationInLayer(layer: contentView.layer, size: size, tintColor: UIColor.yellow)
        
        self.contentView.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.contentView.alpha = 1
        })
        
        if tappable {
            removeGestureRecognizer(singleTap)
            isUserInteractionEnabled = true
            addGestureRecognizer(singleTap)
        }
        return self
    }
    
    /// 消失
    public func dismiss(animated: Bool = true) {
        DDLoadingView.showingView = nil

        if animated {
            UIView.animate(withDuration: 0.25, animations: {
                self.contentView.alpha = 0
            }, completion: { (_) in
                self.removeFromSuperview()
            })
        } else {
            removeFromSuperview()
        }
    }
    
    /// 单击事件
    @objc private func didSingleTap() {
        dismiss()
    }
    
    /// 开始支画
    private func startAnimating() {
        let size = CGSize(width: contentLength, height: contentLength)
        setupAnimationInLayer(layer: contentView.layer, size: size, tintColor: UIColor.yellow)
    }
    
    /// 设置动画
    private func setupAnimationInLayer(layer: CALayer, size: CGSize, tintColor: UIColor) {
        let beginTime = CACurrentMediaTime()
        let layerWith = layer.bounds.size.width
        let circleSize = size.width / 4
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: circleSize, height: circleSize))
        let oX = (layerWith - size.width) / 2.0
        let pointA = CGPoint(x: oX + size.width / 2.0, y: oX + circleSize / 2.0)
        let pointB = CGPoint(x: oX + circleSize / 2.0, y: oX + size.width / 2.0)
        let pointC = CGPoint(x: oX + size.width / 2.0, y: oX + size.width - circleSize / 2.0)
        let pointD = CGPoint(x: oX + size.width - circleSize / 2.0, y: oX + size.width / 2.0)
        
        for i in 0..<4 {
            let circle = CAShapeLayer()
            circle.path = path.cgPath
            circle.fillColor = tintColor.cgColor
            circle.strokeColor = circle.fillColor
            circle.bounds = CGRect(x: 0, y: 0, width: circleSize, height: circleSize)
            circle.position = pointA
            circle.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            circle.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
            circle.shouldRasterize = true
            circle.rasterizationScale = UIScreen.main.scale
            
            let transform = CAKeyframeAnimation(keyPath: "transform")
            transform.isRemovedOnCompletion = false
            transform.repeatCount = HUGE
            transform.duration = 2.0
            transform.beginTime = beginTime - (Double(i) * transform.duration / 4.0)
            
            transform.keyTimes = [0, 0.25, 0.5, 0.75, 1.0]
            transform.timingFunctions = [CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut),
                                         CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut),
                                         CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut),
                                         CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut),
                                         CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)]
            let t1 = CATransform3DMakeTranslation(pointB.x - pointA.x, pointB.y - pointA.y, 0.0)
            let t2 = CATransform3DMakeTranslation(pointC.x - pointA.x, pointC.y - pointA.y, 0.0)
            let t3 = CATransform3DMakeTranslation(pointD.x - pointA.x, pointD.y - pointA.y, 0.0)
            let t4 = CATransform3DMakeTranslation(0, 0, 0)
            
            transform.values = [NSValue(caTransform3D: CATransform3DIdentity),
                                NSValue(caTransform3D: t1),
                                NSValue(caTransform3D: t2),
                                NSValue(caTransform3D: t3),
                                NSValue(caTransform3D: t4)]
            
            layer.addSublayer(circle)
            circle.add(transform, forKey: "animation")
        }
    }
}
