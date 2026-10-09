//
//  DashBoardProtocol.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//
import Foundation

protocol DashboardViewProtocol: AnyObject {
    func updateRatesPreview(_ rates: [ExchangeRateItem])
    func updateQuickConverterResult(_ text: String)
    func showLoading()
    func hideLoading()
}

protocol DashboardPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didChangeQuickAmount(_ amount: Double)
}
