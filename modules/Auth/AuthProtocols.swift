//
//  AuthProtocols.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//

import Foundation

protocol AuthViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showError(message: String)
    func updateBiometricButton(iconName: String)
}

protocol AuthPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapLogin(phone: String?, pin: String?)
    func didTapBiometrics()
    func didTapRegister()
}

protocol AuthModuleOutput: AnyObject {
    func didFinishAuthentication()
    func didRequestRegistration()
}
