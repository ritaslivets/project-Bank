//
//  RegisterPresenter.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//

import Foundation

final class RegisterPresenter: RegisterPresenterProtocol {
    private weak var view: RegisterViewProtocol?
    private weak var output: RegisterModuleOutput?
    private let profileStorage: ProfileStorageProtocol
    private let authService: AuthServiceProtocol

    init(
        view: RegisterViewProtocol,
        output: RegisterModuleOutput?,
        profileStorage: ProfileStorageProtocol = ProfileStorage(),
        authService: AuthServiceProtocol = AuthService()
    ) {
        self.view = view
        self.output = output
        self.profileStorage = profileStorage
        self.authService = authService
    }

    func didTapRegister(fullName: String?, phone: String?, pin: String?, repeatPin: String?) {
        guard let name = fullName?.trimmingCharacters(in: .whitespaces), !name.isEmpty else {
            view?.showError(message: "Введите ваше имя и фамилию")
            return
        }

        guard let phone = phone?.trimmingCharacters(in: .whitespaces), phone.count >= 9 else {
            view?.showError(message: "Введите корректный номер телефона")
            return
        }

        guard let pin = pin, pin.count >= 4 else {
            view?.showError(message: "PIN-код должен содержать минимум 4 цифры")
            return
        }

        guard pin == repeatPin else {
            view?.showError(message: "PIN-коды не совпадают")
            return
        }

        view?.showLoading()

        let profile = UserProfile(fullName: name, phone: phone)
        profileStorage.saveUser(profile)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            self?.view?.hideLoading()
            self?.output?.didFinishRegistration()
        }
    }

    func didTapBackToLogin() {
        output?.didRequestLogin()
    }
}
