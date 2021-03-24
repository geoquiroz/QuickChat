//
//  UIViewExtension.swift
//  QuickChat
//
//  Created by Geovanny quiroz on 1/19/21.
//

import SnapKit
import UIKit

extension UIView {
    public convenience init(backgroundColor: UIColor?) {
        self.init()
        self.backgroundColor = backgroundColor
    }
    
    public static var identifier: String {
        return String(describing: self)
    }
    
    func addSubview(_ view: UIView, make: (ConstraintMaker) -> Void) {
        addSubview(view)
        view.snp.makeConstraints(make)
    }
    
    public var safeArea: ConstraintRelatableTarget {
        return safeAreaLayoutGuide
    }
    
    public var safeAreaBounds: CGRect {
        return safeAreaLayoutGuide.layoutFrame
    }
    
    public func layout(duration: TimeInterval = 0, delay: TimeInterval = 0, options: UIView.AnimationOptions = [], completion: ((Bool) -> Swift.Void)? = nil) {
        setNeedsLayout()
        layoutIfNeeded(duration: duration, delay: delay, options: options, completion: completion)
    }
    
    public func layoutIfNeeded(duration: TimeInterval = 0, delay: TimeInterval = 0, options: UIView.AnimationOptions = [], completion: ((Bool) -> Swift.Void)? = nil) {
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: { [weak self] in
            self?.layoutIfNeeded()
        }, completion: completion)
    }
    
    
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 3
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    
}
