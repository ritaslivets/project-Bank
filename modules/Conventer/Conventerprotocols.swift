//
//  Conventerprotocols.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//

import Foundation

protocol ConverterViewProtocol: AnyObject {
    func setupCurrencies(list: [String])
    func updateResult(text: String)
    func setSourceTitle(_ title: String)
    func setTargetTitle(_ title: String)
}

protocol ConverterPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didChangeAmount(_ amount: Double)
    func didSelectSourceCurrency(_ code: String)
    func didSelectTargetCurrency(_ code: String)
    func didTapSwap()
}
