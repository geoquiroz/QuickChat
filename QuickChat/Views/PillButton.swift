//
//  PillButton.swift
//  QuickChat
//
//  Created by Geovanny quiroz on 1/19/21.
//

import Foundation
import UIKit

class PillButton: UIButton {
    var color: UIColor
    public init(text: String = "", color: UIColor = .blue, textColor: UIColor = .white, radius: CGFloat = 30, hasBorder: Bool = false, hasShadow: Bool = false, borderWidth: CGFloat = 3, borderColor: UIColor = .white) {
        self.color = color
        super.init(frame: .zero)
        backgroundColor = self.color
        layer.cornerRadius = radius
        clipsToBounds = true
        setTitle(text, for: .normal)
        setTitleColor(textColor, for: .normal)

        if hasShadow {
            dropShadow()
        }

        guard hasBorder else {
            return
        }
        layer.borderWidth = 3
        layer.borderColor = UIColor.white.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isEnabled: Bool {
        didSet {
            if self.isEnabled {
                self.backgroundColor = self.color
            }
            else {
                self.backgroundColor = UIColor.lightGray
            }
        }
    }

    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.backgroundColor = .white
            }
            else {
                self.backgroundColor = self.color
            }
        }
    }
}
