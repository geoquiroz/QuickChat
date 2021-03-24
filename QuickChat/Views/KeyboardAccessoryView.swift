//
//  KeyboardAccessoryView.swift
//  QuickChat
//
//  Created by Geovanny quiroz on 1/19/21.
//

import UIKit
import Snail

public class KeyboardAccessoryView: UIView {
    public class Button: UIButton {
        override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            return bounds.insetBy(dx: -10, dy: -10).contains(point) ? self : nil
        }
    }
    public let leftButton = Button()
    public let rightButton = Button()
    public let leftButtonPressed = Replay<Void>(1)
    public let rightButtonPressed = Replay<Void>(1)
    public let doneButtonPressed = Replay<Void>(1)

    public init() {
        super.init(frame: .zero)

        frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        backgroundColor = .lightGray

        leftButton.isEnabled = false
        leftButton.tintColor = .blue
        addSubview(leftButton)
        leftButton.snp.makeConstraints { make in
            make.left.equalTo(self).offset(20)
            make.centerY.equalTo(self)
        }
        leftButton.tap.subscribe(onNext: { [weak self] in self?.leftButtonPressed.on(.next(())) })

        rightButton.isEnabled = false
        rightButton.tintColor = .blue
        addSubview(rightButton)
        rightButton.snp.makeConstraints { make in
            make.left.equalTo(leftButton.snp.right).offset(30)
            make.centerY.equalTo(self)
        }
        rightButton.tap.subscribe(onNext: { [weak self] in self?.rightButtonPressed.on(.next(())) })

        let doneFont = UIFont.systemFont(ofSize: 18, weight: .regular)
        let doneButton = UIButton()
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.blue, for: .normal)
        doneButton.setTitleColor(.blue, for: .highlighted)
        doneButton.titleLabel?.font = doneFont
        addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
            make.centerY.equalTo(self).offset(-doneFont.descender * 0.5)
            make.right.equalTo(self).inset(20)
        }
        doneButton.tap.subscribe(onNext: { [weak self] in self?.doneButtonPressed.on(.next(())) })

        let divider = SeparatorView.horizontal()
        addSubview(divider)
        divider.snp.makeConstraints { make in
            make.left.bottom.right.equalTo(self)
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
