//
//  Double.swift
//  SwiftfulCrypto
//
//  Created by Pavan Mikkilineni on 31/01/22.
//

import Foundation

extension Double{
    
    ///converts a Double into a Currency with 6 decimal places
    ///```
    ///Convert 0.123456 to $0.123456
    ///
    ///```
    private var currencyFormatter:NumberFormatter{
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true // commas
        formatter.numberStyle = .currency
        formatter.locale = .current
        formatter.currencyCode = "usd"
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    ///converts a Double into a Currency with 2 decimal places
    ///```
    ///Convert 1234.56 to $1,234.56
    ///
    ///```
    private var currencyFormatter2:NumberFormatter{
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true // commas
        formatter.numberStyle = .currency
        formatter.locale = .current
        formatter.currencyCode = "usd"
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    ///converts a Double into a Currency as String with 6 decimal places
    ///```
    ///Convert 0.123456 to "$0.123456"
    ///
    ///```
    func asCurrencyWith6Decimals() -> String{
        let number = NSNumber(value: self)
        return currencyFormatter.string(from: number) ?? "$0.000000"
    }
    
    ///converts a Double into a Currency as String with 2 decimal places
    ///```
    ///Convert 0.123456 to "$0.12"
    ///
    ///```
    func asCurrencyWith2Decimals() -> String{
        let number = NSNumber(value: self)
        return currencyFormatter.string(from: number) ?? "$0.00"
    }
    
    ///converts a Double into a Percentage String representation
    ///```
    ///Convert 1234.56 to "1234.56%"
    ///
    ///```
    func asPercentageString()->String{
        return String(format: "%.2f", self) + "%"
    }
    
    ///converts a Double into a String representation
    ///```
    ///Convert 1234.56 to "1234.56"
    ///
    ///```
    func asNumberString()->String{
        return String(format: "%.2f", self)
    }
    
    /// Convert a Double to a String with K, M, Bn, Tr abbreviations.
    /// ```
    /// Convert 12 to 12.00
    /// Convert 1234 to 1.23K
    /// Convert 123456 to 123.45K
    /// Convert 12345678 to 12.34M
    /// Convert 1234567890 to 1.23Bn
    /// Convert 123456789012 to 123.45Bn
    /// Convert 12345678901234 to 12.34Tr
    /// ```
    func formattedWithAbbreviations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)K"
        case 0...:
            return self.asNumberString()

        default:
            return "\(sign)\(self)"
        }
    }
    
}
