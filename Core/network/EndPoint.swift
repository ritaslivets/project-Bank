//
//  EndPoint.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//

import Foundation

enum Endpoint {
    case nbrbRates
    var url: URL? {
        switch self {
        case .nbrbRates:
            return URL(string: "https://api.nbrb.by/exrates/rates?periodicity=0")
        }
    }
}
