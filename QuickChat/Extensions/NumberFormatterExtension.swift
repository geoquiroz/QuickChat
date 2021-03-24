//
//  NumberFormatterExtension.swift
//  QuickChat
//
//  Created by Geovanny quiroz on 1/19/21.
//

import Foundation

extension NumberFormatter {
    public static func currency(_ value: Double?, decimalPlaces: Int = 0) -> String? {
        guard let value = value else {
            return nil
        }
        let formatter = NumberFormatter.currencyFormatter(decimalPlaces: decimalPlaces)
        return formatter.string(for: value)
    }

    public static func currencyFormatter(decimalPlaces: Int = 0) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = decimalPlaces
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }

    public static func number(_ value: Double?, maxDecimalPlaces: Int = 0, minDecimalPlaces: Int = 0) -> String? {
        guard let value = value else {
            return nil
        }
        let formatter = NumberFormatter.numberFormatter(maxDecimalPlaces: maxDecimalPlaces, minDecimalPlaces: minDecimalPlaces)
        return formatter.string(for: value)
    }

    public static func numberFormatter(maxDecimalPlaces: Int = 0, minDecimalPlaces: Int = 0) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = minDecimalPlaces
        formatter.maximumFractionDigits = maxDecimalPlaces
        formatter.numberStyle = .decimal
        formatter.roundingMode = .halfUp

        return formatter
    }
}
