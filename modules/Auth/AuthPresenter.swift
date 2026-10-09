//
//  AuthPresenter.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//

import Foundation
import LocalAuthentication

final class AuthPresenter: AuthPresenterProtocol {
    private weak var view: AuthViewProtocol?
    private weak var output: AuthModuleOutput?
    private let authService: AuthServiceProtocol

    init(
        view: AuthViewProtocol,
        authService: AuthServiceProtocol = AuthService(),
        output: AuthModuleOutput?
    ) {
        self.view = view
        self.authService = authService
        self.output = output
    }

    func viewDidLoad() {
        let context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            let icon = context.biometryType == .faceID ? "faceid" : "touchid"
            view?.updateBiometricButton(iconName: icon)
        } else {
            view?.updateBiometricButton(iconName: "faceid")
        }
    }

    func didTapLogin(phone: String?, pin: String?) {
        guard let phone = phone, !phone.isEmpty,
              let pin = pin, !pin.isEmpty else {
            view?.showError(message: "Заполните номер телефона и PIN-код (по умолчанию 1234)")
            return
        }

        view?.showLoading()
        authService.login(phone: phone, pin: pin) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                switch result {
                case .success:
                    self?.output?.didFinishAuthentication()
                case .failure(let error):
                    self?.view?.showError(message: error.localizedDescription)
                }
            }
        }
    }

    func didTapBiometrics() {
        authService.authenticateWithBiometrics { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.output?.didFinishAuthentication()
                case .failure(let error):
                    self?.view?.showError(message: error.localizedDescription)
                }
            }
        }
    }
    
    func didTapRegister() {
        output?.didRequestRegistration()
    }
}
