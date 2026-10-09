//
//  RegisterViewController.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//

import UIKit
import SnapKit

final class RegisterViewController: UIViewController, RegisterViewProtocol {
    var presenter: RegisterPresenterProtocol!

    private let scrollView = UIScrollView()
    private let containerCard = UIView()
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    private let nameField = UITextField()
    private let phoneField = UITextField()
    private let pinField = UITextField()
    private let repeatPinField = UITextField()

    private let registerButton = UIButton(type: .system)
    private let toLoginButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground

        titleLabel.text = "Создать аккаунт"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)

        subtitleLabel.text = "Станьте клиентом БелБанка за пару минут"
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel

        containerCard.backgroundColor = .secondarySystemGroupedBackground
        containerCard.applyModernCardStyle(cornerRadius: 24)

        configureTextField(nameField, placeholder: "Имя и Фамилия", icon: "person")
        nameField.text = "Маргарита С."

        configureTextField(phoneField, placeholder: "+375 (29) 000-00-00", icon: "phone")
        phoneField.text = "+375 29 "
        phoneField.keyboardType = .phonePad

        configureTextField(pinField, placeholder: "Придумайте PIN (4 цифры)", icon: "lock")
        pinField.isSecureTextEntry = true
        pinField.keyboardType = .numberPad

        configureTextField(repeatPinField, placeholder: "Повторите PIN-код", icon: "lock.shield")
        repeatPinField.isSecureTextEntry = true
        repeatPinField.keyboardType = .numberPad

        var regConfig = UIButton.Configuration.filled()
        regConfig.title = "Зарегистрироваться"
        regConfig.baseBackgroundColor = .systemBlue
        regConfig.baseForegroundColor = .white
        regConfig.cornerStyle = .medium
        registerButton.configuration = regConfig
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)

        toLoginButton.setTitle("Уже есть аккаунт? Войти", for: .normal)
        toLoginButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        toLoginButton.addTarget(self, action: #selector(toLoginTapped), for: .touchUpInside)

        activityIndicator.hidesWhenStopped = true

        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(subtitleLabel)
        scrollView.addSubview(containerCard)
        scrollView.addSubview(toLoginButton)

        [nameField, phoneField, pinField, repeatPinField, registerButton, activityIndicator].forEach {
            containerCard.addSubview($0)
        }

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        containerCard.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.width.equalTo(scrollView.snp.width).offset(-32)
        }

        nameField.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(18)
            make.height.equalTo(48)
        }

        phoneField.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(18)
            make.height.equalTo(48)
        }

        pinField.snp.makeConstraints { make in
            make.top.equalTo(phoneField.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(18)
            make.height.equalTo(48)
        }

        repeatPinField.snp.makeConstraints { make in
            make.top.equalTo(pinField.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(18)
            make.height.equalTo(48)
        }

        registerButton.snp.makeConstraints { make in
            make.top.equalTo(repeatPinField.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview().inset(18)
            make.height.equalTo(52)
        }

        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(registerButton)
        }

        toLoginButton.snp.makeConstraints { make in
            make.top.equalTo(containerCard.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24)
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    private func configureTextField(_ tf: UITextField, placeholder: String, icon: String) {
        tf.placeholder = placeholder
        tf.backgroundColor = .tertiarySystemGroupedBackground
        tf.layer.cornerRadius = 12
        tf.layer.cornerCurve = .continuous
        tf.font = .systemFont(ofSize: 16)
        
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .secondaryLabel
        iconView.contentMode = .center
        iconView.frame = CGRect(x: 0, y: 0, width: 40, height: 48)
        tf.leftView = iconView
        tf.leftViewMode = .always
    }

    @objc private func dismissKeyboard() { view.endEditing(true) }

    @objc private func registerTapped() {
        presenter.didTapRegister(
            fullName: nameField.text,
            phone: phoneField.text,
            pin: pinField.text,
            repeatPin: repeatPinField.text
        )
    }

    @objc private func toLoginTapped() {
        presenter.didTapBackToLogin()
    }

    func showLoading() {
        registerButton.isEnabled = false
        registerButton.configuration?.title = ""
        activityIndicator.startAnimating()
    }

    func hideLoading() {
        registerButton.isEnabled = true
        registerButton.configuration?.title = "Зарегистрироваться"
        activityIndicator.stopAnimating()
    }

    func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
