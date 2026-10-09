//
//  DashboardPresenter.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
import Foundation

final class DashboardPresenter: DashboardPresenterProtocol {
    private weak var view: DashboardViewProtocol?
    private let currencyService: CurrencyServiceProtocol
    private var usdRate: Double = 3.25
    init(view: DashboardViewProtocol, currencyService: CurrencyServiceProtocol) {
        self.view = view
        self.currencyService = currencyService
    }

    func viewDidLoad() {
        view?.showLoading()
        currencyService.fetchRates { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.view?.hideLoading()
                switch result {
                case .success(let items):
                    let preview = items.filter { ["USD", "EUR", "RUB", "CNY"].contains($0.code) }
                    self.view?.updateRatesPreview(preview)
                    if let usd = items.first(where: { $0.code == "USD" }) {
                        self.usdRate = usd.unitRate
                        self.didChangeQuickAmount(100)
                    }
                case .failure:
                    self.didChangeQuickAmount(100)
                }
            }
        }
    }

    func didChangeQuickAmount(_ amount: Double) {
        let total = amount * usdRate
        view?.updateQuickConverterResult("= " + total.asCurrencyString(decimals: 2, symbol: "BYN"))
    }
}
