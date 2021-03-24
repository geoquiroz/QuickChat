//
//  FloatLabelTextField.swift
//  QuickChat
//
//  Created by Geovanny quiroz on 1/19/21.
//

import SnapKit
import UIKit
import Snail

public class FloatLabelTextField: SimpleTextField {
    public var floatText: String?
    private var isFloating = false
    private var oldPlaceholderLabelFrame: CGRect = .zero

    public init(placeholder: String? = nil, floatText: String? = nil, text: String? = nil) {
        super.init()

        self.placeholder = placeholder
        self.text = text

        if !text.isNilOrEmpty {
            float()
        }
        setupBindings()
    }

    private func setupBindings() {
        textChanged.subscribe(onNext: { text in
            self.placeholderLabel.isHidden = false
            text.isEmpty ? self.reset() : self.float()
        }).add(to: disposer)

        didBeginEditing.subscribe(onNext: { self.float() }).add(to: disposer)

        didEndEditing.subscribe(onNext: {
            if self.text.isNilOrEmpty {
                self.reset()
            }
        }).add(to: disposer)

        clearButtonClicked.subscribe(onNext: {
            //it's possible the clear button can be clicked when this field isn't the firstResponder, when
            //that happens we want to reset the floating label
            if !self.textField.isFirstResponder {
                self.reset()
            }
        }).add(to: disposer)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 72)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        if isFloating, placeholderLabel.frame != oldPlaceholderLabelFrame {
            transformPlaceholderLabel(isFloating: isFloating)
        }
    }

    private func float() {
        if isFloating {
            return
        }
        isFloating = true
        textField.snp.updateConstraints { make in
            make.top.equalTo(self).offset(18)
        }
        if !floatText.isNilOrEmpty {
            placeholderLabel.text = floatText
        }
        UIView.animate(withDuration: 0.2) {
            self.transformPlaceholderLabel(isFloating: true)
        }
    }

    private func reset() {
        isFloating = false
        textField.snp.updateConstraints { make in
            make.top.equalTo(self).offset(4)
        }
        placeholderLabel.text = placeholder
        UIView.animate(withDuration: 0.2) {
            self.transformPlaceholderLabel(isFloating: false)
        }
    }

    private func transformPlaceholderLabel(isFloating: Bool) {
        var transform: CGAffineTransform = .identity
        if isFloating {
            let size = placeholderLabel.bounds.size
            let scaleFactor: CGFloat = 0.75
            let translationFactor = (1 - scaleFactor) / 2
            transform = transform.translatedBy(x: -size.width * translationFactor, y: -size.height * translationFactor).scaledBy(x: scaleFactor, y: scaleFactor)
        }
        placeholderLabel.transform = transform
    }

    override open var inputAccessoryView: UIView? {
        let keyboardView = KeyboardAccessoryView()
        keyboardView.doneButtonPressed.subscribe(onNext: { _ = self.resignFirstResponder() }).add(to: disposer)
        return keyboardType == .numberPad || keyboardType == .decimalPad || keyboardType == .phonePad ? keyboardView : nil
    }
}

