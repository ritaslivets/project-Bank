//
//  RegisterProtocols.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//

import Foundation

protocol RegisterViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showError(message: String)
}

protocol RegisterPresenterProtocol: AnyObject {
    func didTapRegister(fullName: String?, phone: String?, pin: String?, repeatPin: String?)
    func didTapBackToLogin()
}

protocol RegisterModuleOutput: AnyObject {
    func didFinishRegistration()
    func didRequestLogin()
}
