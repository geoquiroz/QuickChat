//
//  TextField.swift
//  QuickChat
//
//  Created by Geovanny quiroz on 1/19/21.
//

import Foundation
import UIKit
import Snail

public class TextField: UIView {
    public enum Format {
        case number
        case currency(withCents: Bool)

        func format(_ string: String?) -> String? {
            switch self {
            case .number: return NumberFormatter.number(Unformatter.number(string)) ?? string
            case .currency(let withCents): return NumberFormatter.currency(Unformatter.currency(string), decimalPlaces: withCents ? 2 : 0) ?? string
            }
        }
    }
    public let textField = DeletableTextField()
    let placeholderLabel = Label()

    let lock = Lock()

    public let textChanged = Replay<String>(1)
    public let textChangedNil = Replay<String?>(1)
    public let didBeginEditing = Replay<Void>(1)
    public let didEndEditing = Replay<Void>(1)
    public let didDeleteBackwards = Replay<Void>(1)
    public let returnAction = Replay<Void>(1)
    public let shouldClear = Observable<Void>()

    public var format: Format?
    public var shouldBeginEditing: (() -> Bool)?
    public var shouldUseTextChangedNil = false

    public var text: String? {
        get { return textField.text }
        set {
            let update = textField.isEditing ? newValue : format?.format(newValue) ?? newValue
            if update != textField.text {
                textField.text = update
                textField.sendActions(for: .editingChanged)
            }
        }
    }

    public var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
            placeholderLabel.isHidden = placeholder.isNilOrEmpty || !textField.text.isNilOrEmpty
        }
    }

    public var placeHolderNumberOfLines: Int {
        get {
            return placeholderLabel.numberOfLines
        }
        set {
            placeholderLabel.numberOfLines = newValue
        }
    }

    public var font: UIFont? {
        get { return textField.font }
        set {
            textField.font = newValue
            placeholderLabel.font = newValue
        }
    }

    public var isEnabled: Bool {
        get { return textField.isEnabled }
        set { textField.isEnabled = newValue }
    }

    public var autocorrectionType: UITextAutocorrectionType {
        get { return textField.autocorrectionType }
        set { textField.autocorrectionType = newValue }
    }

    public var autocapitalizationType: UITextAutocapitalizationType {
        get { return textField.autocapitalizationType }
        set { textField.autocapitalizationType = newValue }
    }

    public var keyboardType: UIKeyboardType {
        get { return textField.keyboardType }
        set { textField.keyboardType = newValue }
    }

    public var returnKeyType: UIReturnKeyType {
        get { return textField.returnKeyType }
        set { textField.returnKeyType = newValue }
    }

    public var textAlignment: NSTextAlignment {
        get { return textField.textAlignment }
        set { textField.textAlignment = newValue }
    }

    public var textColor: UIColor? {
        get { return textField.textColor }
        set { textField.textColor = newValue }
    }

    public var leftViewMode: UITextField.ViewMode {
        get { return textField.leftViewMode }
        set { textField.leftViewMode = newValue }
    }

    public var leftView: UIView? {
        get { return textField.leftView }
        set { textField.leftView = newValue }
    }

    public var clearButtonMode: UITextField.ViewMode {
        get { return textField.clearButtonMode }
        set { textField.clearButtonMode = newValue }
    }

    public init() {
        super.init(frame: .zero)

        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        textField.textColor = .black
        textField.tintColor = .black
        textField.adjustsFontForContentSizeCategory = true
        textField.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        addSubview(textField) { make in
            make.edges.equalTo(self)
        }

        placeholderLabel.textColor = .darkGray
        placeholderLabel.font = textField.font
        addSubview(placeholderLabel) { make in
            make.left.equalTo(textField).inset(1)
            make.top.bottom.equalTo(self)
            make.right.lessThanOrEqualTo(self)
        }

        setupBindings()
    }

    private func setupBindings() {
        textField.controlEvent(.editingChanged).subscribe(onNext: {
            self.placeholderLabel.isHidden = self.placeholder.isNilOrEmpty == true || self.textField.text.isNilOrEmpty == false
            if self.shouldUseTextChangedNil == true {
                self.textChangedNil.on(.next(self.textField.text))
            } else {
                self.textChanged.on(.next(self.textField.text ?? ""))
            }
        }).add(to: disposer)

        textField.didDeleteBackwards.subscribe(queue: .main, onNext: {
            guard self.text?.count == 1 else {
                return
            }
            self.didDeleteBackwards.on(.next(()))
        }).add(to: disposer)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public var isFirstResponder: Bool {
        return textField.isFirstResponder
    }

    override public func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
        return super.becomeFirstResponder()
    }

    override public func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
        return super.resignFirstResponder()
    }

    public func twoWayBind(with: Variable<String?>, onUpdate: (() -> Void)? = nil) {
        text = with.value
        with.asObservable().subscribe(queue: .global(), onNext: { value in
            self.lock.sync {
                DispatchQueue.main.async {
                    self.text = value
                    onUpdate?()
                }
            }
        }).add(to: disposer)
        textChanged.debounce(0.4).subscribe(queue: .global(), onNext: { value in
            self.lock.sync {
                DispatchQueue.main.async {
                    with.value = value
                }
            }
        }).add(to: disposer)
    }
}

extension TextField: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        didBeginEditing.on(.next(()))
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        text = format?.format(text) ?? text
        didEndEditing.on(.next(()))
    }

    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return shouldBeginEditing?() ?? true
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        returnAction.on(.next(()))
        return false
    }

    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        shouldClear.on(.next(()))
        return true
    }
}
