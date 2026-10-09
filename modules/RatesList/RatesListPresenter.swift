//
//  RatesListPresenter.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//

import Foundation

final class RatesListPresenter: RatesListPresenterProtocol {
    private weak var view: RatesListViewProtocol?
    private let currencyService: CurrencyServiceProtocol
    private let cacheService: CacheServiceProtocol
    
    private var allRates: [ExchangeRateItem] = []
    private var favoriteCodes: Set<String> = []

    init(
        view: RatesListViewProtocol,
        currencyService: CurrencyServiceProtocol,
        cacheService: CacheServiceProtocol = CacheService()
    ) {
        self.view = view
        self.currencyService = currencyService
        self.cacheService = cacheService
    }

    func viewDidLoad() {
        favoriteCodes = cacheService.loadFavorites()
        loadData()
    }

    func didPullToRefresh() {
        loadData()
    }

    private func loadData() {
        view?.showLoading()
        currencyService.fetchRates { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.view?.hideLoading()
                switch result {
                case .success(let items):
                    self.allRates = items.map {
                        var itm = $0
                        itm.isFavorite = self.favoriteCodes.contains(itm.code)
                        return itm
                    }
                    self.sortAndDeliver(self.allRates)
                case .failure(let err):
                    self.view?.showError(message: err.localizedDescription)
                }
            }
        }
    }

    private func sortAndDeliver(_ items: [ExchangeRateItem]) {
        let sorted = items.sorted {
            if $0.isFavorite == $1.isFavorite { return $0.code < $1.code }
            return $0.isFavorite && !$1.isFavorite
        }
        view?.displayRates(sorted)
    }

    func didSearch(query: String) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            sortAndDeliver(allRates)
            return
        }
        let filtered = allRates.filter {
            $0.code.localizedCaseInsensitiveContains(query) || $0.name.localizedCaseInsensitiveContains(query)
        }
        sortAndDeliver(filtered)
    }

    func didToggleFavorite(for code: String) {
        if favoriteCodes.contains(code) {
            favoriteCodes.remove(code)
        } else {
            favoriteCodes.insert(code)
        }
        cacheService.saveFavorites(favoriteCodes)
        
        allRates = allRates.map {
            var item = $0
            if item.code == code { item.isFavorite.toggle() }
            return item
        }
        sortAndDeliver(allRates)
    }
}
