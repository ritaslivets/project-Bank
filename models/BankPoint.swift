//
//  BankPoint.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//
import Foundation
import CoreLocation

enum BankPointType: String, CaseIterable {
    case atm = "Банкомат"
    case branch = "Отделение"
}

struct BankPoint: Identifiable {
    let id: UUID = UUID()
    let title: String
    let address: String
    let type: BankPointType
    let coordinate: CLLocationCoordinate2D
    let workingHours: String
    let services: [String]
    let phone: String?
}
