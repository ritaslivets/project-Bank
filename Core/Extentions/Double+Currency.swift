//
//  Double+Currency.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//
import Foundation

extension Double {
    func asCurrencyString(decimals: Int = 2, symbol: String = "BYN") -> String {
        return String(format: "%.*f %@", decimals, self, symbol)
    }
}
