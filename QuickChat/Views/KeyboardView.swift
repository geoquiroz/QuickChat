//
//  KeyboardView.swift
//  QuickChat
//
//  Created by Geovanny quiroz on 1/19/21.
//

import Foundation
import SnapKit
import UIKit

extension UIViewController {
    private static var keyboardViewKey = "KeyboardViewKey"

    public var keyboardView: KeyboardView {
        if let view = objc_getAssociatedObject(self, &UIViewController.keyboardViewKey) as? KeyboardView {
            return view
        }
        let keyboardView = KeyboardView()
        view.addSubview(keyboardView) { make in
            make.left.right.equalTo(view.safeArea)
            keyboardView.keyboardBottomConstraint = make.bottom.equalTo(view.safeArea).constraint
            make.height.equalTo(0).priority(.low)
        }
        let safeAreaView = UIView()
        safeAreaView.backgroundColor = .white
        view.addSubview(safeAreaView) { make in
            make.top.equalTo(keyboardView.snp.bottom)
            make.left.right.bottom.equalTo(view)
        }
        objc_setAssociatedObject(self, &UIViewController.keyboardViewKey, keyboardView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return keyboardView
    }
}

public class KeyboardView: UIView {
    fileprivate var keyboardBottomConstraint: Constraint?

    public var view: UIView? {
        willSet {
            view?.removeFromSuperview()
        }
        didSet {
            guard let view = view else {
                return
            }
            addSubview(view) { make in
                make.edges.equalTo(self)
            }
        }
    }

    public init() {
        super.init(frame: .zero)
        observe(event: UIResponder.keyboardWillShowNotification).subscribe(onNext: { [weak self] in self?.keyboardWillShow($0) })
        observe(event: UIResponder.keyboardWillHideNotification).subscribe(onNext: { [weak self] in self?.keyboardWillHide($0) })
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let superview = superview else {
                return
        }
        let keyboardFrameInSuperviewCoordinates = superview.convert(keyboardFrame, from: nil)
        let intersectedHeight = superview.safeAreaBounds.intersection(keyboardFrameInSuperviewCoordinates).size.height
        update(offset: -intersectedHeight, duration: duration)
    }

    private func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        update(offset: 0, duration: duration)
    }

    private func update(offset: CGFloat, duration: Double) {
        superview?.layoutIfNeeded()
        keyboardBottomConstraint?.update(offset: offset)
        UIView.animate(withDuration: duration) {
            self.superview?.layoutIfNeeded()
        }
    }
}
