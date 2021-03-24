//
//  Label.swift
//  QuickChat
//
//  Created by Geovanny quiroz on 1/19/21.
//

import Foundation

import UIKit

open class Label: UILabel {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        adjustsFontForContentSizeCategory = true
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension Label: Reusable {
    public func prepareForReuse() {
        return
    }
}

public protocol Reusable {
    func prepareForReuse()
}
