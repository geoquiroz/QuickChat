//
//  Unformatter.swift
//  QuickChat
//
//  Created by Geovanny quiroz on 1/19/21.
//

import Foundation

public enum Unformatter {
    public static func number(_ value: String?) -> Double? {
        return Double(value?.removingOccurrences(of: [","]))
    }

    public static func currency(_ value: String?) -> Double? {
        return Double(value?.removingOccurrences(of: ["$", ","]))
    }
}

