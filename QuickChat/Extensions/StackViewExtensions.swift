//
//  StackViewExtensions.swift
//  QuickChat
//
//  Created by Geovanny quiroz on 1/19/21.
//

import SnapKit
import UIKit

extension UIStackView {
    public func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { view in
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }

    public func addArrangedSubview(_ view: UIView, isHidden: Bool = false) {
        addArrangedSubview(view)
        view.isHidden = isHidden
    }

    public func addArrangedSubview(_ view: UIView, isHidden: Bool = false, make: (ConstraintMaker) -> Void) {
        addArrangedSubview(view, isHidden: isHidden)
        view.snp.makeConstraints(make)
    }

    public convenience init(axis: NSLayoutConstraint.Axis) {
        self.init()
        self.axis = axis
    }

    public func allowEmptySpace() {
        guard distribution == .fill else {
            return
        }
        let stretchingView = UIView()
        stretchingView.setContentHuggingPriority(.init(1), for: .horizontal)
        stretchingView.backgroundColor = .clear
        stretchingView.translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(stretchingView)
    }

    public func addCustomSpacing(_ spacing: CGFloat, after arrangedSubview: UIView) {
        setCustomSpacing(spacing, after: arrangedSubview)
    }
}
