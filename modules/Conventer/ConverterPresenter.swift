//
//  ConverterPresenter.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//
import Foundation

final class ConverterPresenter: ConverterPresenterProtocol {
    private weak var view: ConverterViewProtocol?
    private let currencyService: CurrencyServiceProtocol

    private var ratesMap: [String: Double] = ["BYN": 1.0]
    private var sourceCode = "USD"
    private var targetCode = "BYN"
    private var amount: Double = 100.0

    init(view: ConverterViewProtocol, currencyService: CurrencyServiceProtocol) {
        self.view = view
        self.currencyService = currencyService
    }

    func viewDidLoad() {
        currencyService.fetchRates { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if case .success(let items) = result {
                    for item in items {
                        self.ratesMap[item.code] = item.unitRate
                    }
                    let allCodes = ["BYN"] + items.map { $0.code }
                    self.view?.setupCurrencies(list: allCodes)
                }
                self.view?.setSourceTitle(self.sourceCode)
                self.view?.setTargetTitle(self.targetCode)
                self.recalculate()
            }
        }
    }

    func didChangeAmount(_ amount: Double) {
        self.amount = amount
        recalculate()
    }

    func didSelectSourceCurrency(_ code: String) {
        sourceCode = code
        view?.setSourceTitle(code)
        recalculate()
    }

    func didSelectTargetCurrency(_ code: String) {
        targetCode = code
        view?.setTargetTitle(code)
        recalculate()
    }

    func didTapSwap() {
        swap(&sourceCode, &targetCode)
        view?.setSourceTitle(sourceCode)
        view?.setTargetTitle(targetCode)
        recalculate()
    }

    private func recalculate() {
        guard let sourceRate = ratesMap[sourceCode], let targetRate = ratesMap[targetCode] else { return }
        let inByn = amount * sourceRate
        let output = inByn / targetRate
        view?.updateResult(text: output.asCurrencyString(decimals: 2, symbol: targetCode))
    }
}
