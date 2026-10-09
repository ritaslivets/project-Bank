//
//  ExchangeRate.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//

import Foundation

// MARK: - Ответ от открытого API НБРБ (Беларусь)
// https://api.nbrb.by/exrates/rates?periodicity=0
struct NBRBRateResponse: Decodable {
    let curID: Int
    let date: String
    let curAbbreviation: String
    let curScale: Int
    let curName: String
    let curOfficialRate: Double

    enum CodingKeys: String, CodingKey {
        case curID = "Cur_ID"
        case date = "Date"
        case curAbbreviation = "Cur_Abbreviation"
        case curScale = "Cur_Scale"
        case curName = "Cur_Name"
        case curOfficialRate = "Cur_OfficialRate"
    }
}

// MARK: - UI-модель элемента курса валюты
struct ExchangeRateItem: Hashable {
    let code: String
    let name: String
    let scale: Int
    let rate: Double
    var isFavorite: Bool = false

    // Стоимость 1 единицы валюты в BYN
    var unitRate: Double {
        guard scale > 0 else { return rate }
        return rate / Double(scale)
    }

    // Алиас для обратной совместимости с дашбордом
    var unitValue: Double {
        return unitRate
    }
}
