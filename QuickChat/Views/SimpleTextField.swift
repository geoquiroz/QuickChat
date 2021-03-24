//
//  SimpleTextField.swift
//  QuickChat
//
//  Created by Geovanny quiroz on 1/19/21.
//

import SnapKit
import UIKit
import Snail

public class SimpleTextField: TextField {
    public var marginX: CGFloat = 0 {
        didSet {
            textField.snp.updateConstraints { make in
                make.left.equalTo(self).offset(marginX)
            }
            bottomBorder.snp.updateConstraints { make in
                make.left.equalTo(self).offset(marginX)
            }
        }
    }
    let helperLabel = Label()

    public let bottomBorder = SeparatorView.horizontal(backgroundColor: .black)
    public let clearButtonClicked = Replay<Void>(1)

    public var helperText: String? {
        didSet {
            helperLabel.text = helperText
            helperLabel.isHidden = placeholderLabel.isHidden
        }
    }

    public var isError = false {
        didSet {
            textField.textColor = isError ? .red : .black
        }
    }

    override public init() {
        super.init()

        textField.textColor = .black
        textField.tintColor = .black
        textField.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        textField.snp.remakeConstraints { make in
            make.top.bottom.equalTo(self)
            make.left.equalTo(self).offset(marginX)
            make.right.equalTo(self).inset(10)
        }

        placeholderLabel.textColor = .darkGray
        placeholderLabel.font = textField.font

        helperLabel.textColor = placeholderLabel.textColor
        helperLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        addSubview(helperLabel)
        helperLabel.snp.remakeConstraints { make in
            make.left.equalTo(placeholderLabel.snp.right).offset(8)
            make.centerY.equalTo(placeholderLabel).offset(2)
        }

        addSubview(bottomBorder)
        bottomBorder.snp.makeConstraints { make in
            make.left.equalTo(self).offset(marginX)
            make.right.equalTo(self)
            make.bottom.equalTo(self)
        }

        textChanged.subscribe(onNext: { _ in self.helperLabel.isHidden = self.placeholderLabel.isHidden }).add(to: disposer)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 52)
    }
}

