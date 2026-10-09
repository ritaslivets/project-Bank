//
//  BankPointsService.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//
import Foundation
import CoreLocation

protocol BankPointsServiceProtocol: AnyObject {
    func fetchPoints() -> [BankPoint]
}

final class BankPointsService: BankPointsServiceProtocol {
    func fetchPoints() -> [BankPoint] {
        return [
            BankPoint(
                title: "Головное отделение «Минск»",
                address: "пр-т Независимости, 42",
                type: .branch,
                coordinate: CLLocationCoordinate2D(latitude: 53.9085, longitude: 27.5751),
                workingHours: "Пн-Пт: 09:00 - 19:00",
                services: ["Обмен валют", "Депозиты", "Оформление карт Белкарт/Visa", "Кредиты"],
                phone: "+375 (17) 215-00-00"
            ),
            BankPoint(
                title: "ATM ТРЦ Galleria Minsk",
                address: "пр-т Победителей, 9",
                type: .atm,
                coordinate: CLLocationCoordinate2D(latitude: 53.9084, longitude: 27.5486),
                workingHours: "Круглосуточно (24/7)",
                services: ["Выдача BYN/USD", "Прием наличных", "Белкарт Pay"],
                phone: nil
            ),
            BankPoint(
                title: "Отделение «Немига»",
                address: "ул. Немига, 8",
                type: .branch,
                coordinate: CLLocationCoordinate2D(latitude: 53.9038, longitude: 27.5516),
                workingHours: "Пн-Сб: 10:00 - 20:00",
                services: ["Международные переводы", "Обмен наличной валюты", "Страхование"],
                phone: "+375 (17) 222-33-44"
            ),
            BankPoint(
                title: "ATM ТРЦ Dana Mall",
                address: "ул. Петра Мстиславца, 11 (ст.м. Восток)",
                type: .atm,
                coordinate: CLLocationCoordinate2D(latitude: 53.9334, longitude: 27.6521),
                workingHours: "10:00 - 22:00",
                services: ["Выдача BYN", "Бесконтактное снятие по QR"],
                phone: nil
            )
        ]
    }
}
