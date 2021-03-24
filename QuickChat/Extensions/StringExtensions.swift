//
//  StringExtensions.swift
//  QuickChat
//
//  Created by Geovanny quiroz on 1/19/21.
//

import Foundation

extension String {
    private static let emailRegex = "[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?"

    public var isValidEmail: Bool {
        return validate(regex: String.emailRegex)
    }

    private func validate(regex: String) -> Bool {
        if isEmpty {
            return false
        }
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }

    public func add(suffix: String) -> String {
        return "\(self)\(suffix)"
    }

    public func removingOccurrences(of word: String?) -> String {
        guard let word = word else {
            return self
        }
        return replacingOccurrences(of: word, with: "")
    }

    public func removingOccurrences(of words: [String]) -> String {
        var result = self
        words.forEach { result = result.removingOccurrences(of: $0) }
        return result
    }

    public func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + dropFirst()
    }

    public var asUrl: URL? {
        if lowercased().hasPrefix("http:") || lowercased().hasPrefix("https:") {
            return URL(string: self)
        }

        return URL(string: "https" + (self.starts(with: "//") ? ":" + self : "://" + self))
    }
}

extension Optional where Wrapped == String {
    public var isNilOrEmpty: Bool {
        return self?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
    }

    public func add(suffix: String) -> String? {
        return self?.add(suffix: suffix)
    }
}
