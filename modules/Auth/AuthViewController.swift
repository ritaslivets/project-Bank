//
//  AuthViewController.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//

import UIKit
import SnapKit

final class AuthViewController: UIViewController, AuthViewProtocol {
    var presenter: AuthPresenterProtocol!

    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let toRegisterButton = UIButton(type: .system)

    private let containerCard = UIView()
    private let phoneTextField = UITextField()
    private let pinTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let biometricsButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground

        logoImageView.image = UIImage(systemName: "building.columns.circle.fill")
        logoImageView.tintColor = .systemBlue
        logoImageView.contentMode = .scaleAspectFit

        titleLabel.text = "БелБанк"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center

        subtitleLabel.text = "Войдите в личный кабинет"
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.textAlignment = .center

        containerCard.backgroundColor = .secondarySystemGroupedBackground
        containerCard.applyModernCardStyle(cornerRadius: 24)

        phoneTextField.placeholder = "+375 (29) 123-45-67"
        phoneTextField.text = "+375 (29) 123-45-67"
        phoneTextField.keyboardType = .phonePad
        phoneTextField.font = .systemFont(ofSize: 17, weight: .medium)
        phoneTextField.borderStyle = .roundedRect

        pinTextField.placeholder = "PIN-код (тест: 1234)"
        pinTextField.text = "1234"
        pinTextField.isSecureTextEntry = true
        pinTextField.keyboardType = .numberPad
        pinTextField.font = .systemFont(ofSize: 17, weight: .medium)
        pinTextField.borderStyle = .roundedRect

        var loginConfig = UIButton.Configuration.filled()
        loginConfig.title = "Войти"
        loginConfig.baseBackgroundColor = .systemBlue
        loginConfig.baseForegroundColor = .white
        loginConfig.cornerStyle = .medium
        loginButton.configuration = loginConfig
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)

        biometricsButton.setImage(UIImage(systemName: "faceid"), for: .normal)
        biometricsButton.tintColor = .systemBlue
        biometricsButton.backgroundColor = .tertiarySystemGroupedBackground
        biometricsButton.layer.cornerRadius = 16
        biometricsButton.layer.cornerCurve = .continuous
        biometricsButton.addTarget(self, action: #selector(biometricsTapped), for: .touchUpInside)

        toRegisterButton.setTitle("Нет аккаунта? Зарегистрироваться", for: .normal)
        toRegisterButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        toRegisterButton.addTarget(self, action: #selector(toRegisterTapped), for: .touchUpInside)

        activityIndicator.hidesWhenStopped = true

        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(containerCard)
        view.addSubview(toRegisterButton)

        [phoneTextField, pinTextField, loginButton, biometricsButton, activityIndicator].forEach {
            containerCard.addSubview($0)
        }

        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.centerX.equalToSuperview()
            make.size.equalTo(72)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        containerCard.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        phoneTextField.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }

        pinTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(pinTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(biometricsButton.snp.leading).offset(-12)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().inset(20)
        }

        biometricsButton.snp.makeConstraints { make in
            make.centerY.equalTo(loginButton)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(52)
        }

        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(loginButton)
        }

        toRegisterButton.snp.makeConstraints { make in
            make.top.equalTo(containerCard.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func toRegisterTapped() {
        presenter.didTapRegister()
    }

    @objc private func loginTapped() {
        presenter.didTapLogin(phone: phoneTextField.text, pin: pinTextField.text)
    }

    @objc private func biometricsTapped() {
        presenter.didTapBiometrics()
    }

    func showLoading() {
        loginButton.isEnabled = false
        loginButton.configuration?.title = ""
        activityIndicator.startAnimating()
    }

    func hideLoading() {
        loginButton.isEnabled = true
        loginButton.configuration?.title = "Войти"
        activityIndicator.stopAnimating()
    }

    func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка входа", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Понятно", style: .default))
        present(alert, animated: true)
    }

    func updateBiometricButton(iconName: String) {
        biometricsButton.setImage(UIImage(systemName: iconName), for: .normal)
    }
}
