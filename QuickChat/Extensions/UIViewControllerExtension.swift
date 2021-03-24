//
//  UIViewControllerExtension.swift
//  QuickChat
//
//  Created by Geovanny quiroz on 1/19/21.
//

import UIKit

extension UIViewController {
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }

    public func addRightNavigation(button: UIButton) {
        if let height = navigationController?.navigationBar.bounds.size.height {
            button.snp.makeConstraints { make in
                make.width.greaterThanOrEqualTo(height)
                make.height.equalTo(height)
            }
        }

        button.contentHorizontalAlignment = .right
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }

    public func embed(child: UIViewController,
                      inView view: UIView,
                      belowView: UIView? = nil,
                      inSafeArea: Bool = true,
                      insets: UIEdgeInsets = .zero) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
        let viewTop = inSafeArea ? view.safeArea : view
        let topConstraint = belowView?.snp.bottom ?? viewTop
        child.view.snp.makeConstraints { make in
            make.top.equalTo(topConstraint).inset(insets.top)
            make.left.equalTo(inSafeArea ? view.safeArea : view).inset(insets.left)
            make.bottom.equalTo(inSafeArea ? view.safeArea : view).inset(insets.bottom)
            make.right.equalTo(inSafeArea ? view.safeArea : view).inset(insets.right)
        }
    }

    func presentAlert(title: String = "Error", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
