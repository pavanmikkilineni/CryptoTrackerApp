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
    
}
