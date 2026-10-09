//
//  CurrencyService.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//
import Foundation

protocol CurrencyServiceProtocol: AnyObject {
    func fetchRates(completion: @escaping (Result<[ExchangeRateItem], APIError>) -> Void)
}

final class CurrencyService: CurrencyServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private let cacheService: CacheServiceProtocol

    init(
        networkService: NetworkServiceProtocol = NetworkService(),
        cacheService: CacheServiceProtocol = CacheService()
    ) {
        self.networkService = networkService
        self.cacheService = cacheService
    }

    func fetchRates(completion: @escaping (Result<[ExchangeRateItem], APIError>) -> Void) {
        networkService.request(endpoint: .nbrbRates) { [weak self] (result: Result<[NBRBRateResponse], APIError>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let favorites = self.cacheService.loadFavorites()
                let items = response.map { item in
                    ExchangeRateItem(
                        code: item.curAbbreviation,
                        name: item.curName,
                        scale: item.curScale,
                        rate: item.curOfficialRate,
                        isFavorite: favorites.contains(item.curAbbreviation)
                    )
                }.sorted { $0.code < $1.code }
                completion(.success(items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
