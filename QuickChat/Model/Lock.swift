//
//  Lock.swift
//  QuickChat
//
//  Created by Geovanny quiroz on 1/19/21.
//

import Foundation

public class Lock {
    private var lock = NSRecursiveLock()

    public init() {}

    public func sync(action: () -> Void) {
        lock.lock()
        action()
        lock.unlock()
    }
}
