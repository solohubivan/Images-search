//
//  NumberFormatterExtension.swift
//  Images search
//
//  Created by Ivan Solohub on 12.03.2024.
//

import Foundation

extension NumberFormatter {
    static func formatNumberWithSpaces(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }
}
