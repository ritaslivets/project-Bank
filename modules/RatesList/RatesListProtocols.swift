//
//  RatesListProtocols.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//
import Foundation

protocol RatesListViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func displayRates(_ rates: [ExchangeRateItem])
    func showError(message: String)
}

protocol RatesListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didPullToRefresh()
    func didSearch(query: String)
    func didToggleFavorite(for code: String)
}
