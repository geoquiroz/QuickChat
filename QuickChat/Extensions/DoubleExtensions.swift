//
//  DoubleExtensions.swift
//  QuickChat
//
//  Created by Geovanny quiroz on 1/19/21.
//

import Foundation

extension Double {
    var digits: Int {
        return self == 0 ? 1 : Int(log10(abs(self)) + 1)
    }

    public init?(_ string: String?) {
        guard let string = string else {
            return nil
        }
        self.init(string)
    }

    public func asString(type: ValueType? = nil) -> String {
        guard let type = type else {
            return "\(self)"
        }
        switch type {
        case .double: return "\(Double(self))"
        case .int: return "\(Int(self))"
        default: return "\(self)"
        }
    }

    public func asInt(type: ValueType? = ValueType.double) -> Int? {
        guard let type = type else {
            return nil
        }
        switch type {
        case .double: return Int(self)
        default: return nil
        }
    }
}

extension Optional where Wrapped == Double {
    public func asString(type: ValueType? = nil) -> String? {
        return self?.asString(type: type)
    }

    public func asInt(type: ValueType? = ValueType.double) -> Int? {
        return self?.asInt(type: type)
    }
}
