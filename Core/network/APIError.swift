//
//  APIError.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//
import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Некорректный адрес запроса."
        case .networkError(let error):
            return "Ошибка сети: \(error.localizedDescription)"
        case .decodingError:
            return "Не удалось обработать ответ от сервера."
        case .noData:
            return "Сервер вернул пустой ответ."
        }
    }
}
