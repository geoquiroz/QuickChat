//
//  DeletableTextField.swift
//  QuickChat
//
//  Created by Geovanny quiroz on 1/19/21.
//

import UIKit
import Snail

public class DeletableTextField: UITextField {
    public let didDeleteBackwards = Replay<Void>(1)

    override public func deleteBackward() {
        didDeleteBackwards.on(.next(()))
        super.deleteBackward()
    }
}

