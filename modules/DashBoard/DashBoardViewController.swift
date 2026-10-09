//
//  DashBoardViewController.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//

import UIKit
import SnapKit

final class DashboardViewController: UIViewController, DashboardViewProtocol {
    var presenter: DashboardPresenterProtocol!

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    
    // MARK: - Header Profile Elements
    private let headerContainer = UIView()
    private let avatarImageView = UIImageView()
    private let greetingLabel = UILabel()
    private let userNameLabel = UILabel()
    private let notificationButton = UIButton(type: .system)
    
    // MARK: - Cards
    private let balanceCard = BalanceCardView()
    private let quickConverterCard = QuickConverterCardView()
    private let ratesPreviewStack = UIStackView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        setupHeader()
        
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        
        contentStack.axis = .vertical
        contentStack.spacing = 20
        
        ratesPreviewStack.axis = .vertical
        ratesPreviewStack.spacing = 12
        ratesPreviewStack.backgroundColor = .secondarySystemGroupedBackground
        ratesPreviewStack.applyModernCardStyle(cornerRadius: 20)
        ratesPreviewStack.isLayoutMarginsRelativeArrangement = true
        ratesPreviewStack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        view.addSubview(headerContainer)
        view.addSubview(scrollView)
        view.addSubview(activityIndicator)
        scrollView.addSubview(contentStack)
        
        contentStack.addArrangedSubview(balanceCard)
        contentStack.addArrangedSubview(quickConverterCard)
        contentStack.addArrangedSubview(ratesPreviewStack)

        headerContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headerContainer.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 24, right: 16))
            make.width.equalTo(scrollView.snp.width).offset(-32)
        }
        
        balanceCard.snp.makeConstraints { make in
            make.height.equalTo(170)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        quickConverterCard.onAmountChanged = { [weak self] amount in
            self?.presenter.didChangeQuickAmount(amount)
        }
    }

    private func setupHeader() {
        // Аватарка
        avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
        avatarImageView.tintColor = .systemBlue
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 22
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.borderWidth = 2
        avatarImageView.layer.borderColor = UIColor.systemBlue.withAlphaComponent(0.2).cgColor
        let savedProfile = ProfileStorage().getUser()
        userNameLabel.text = savedProfile?.fullName ?? "Маргарита С."
        
        greetingLabel.text = "С возвращением "
        greetingLabel.font = .systemFont(ofSize: 13, weight: .medium)
        greetingLabel.textColor = .secondaryLabel
        
        userNameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        userNameLabel.textColor = .label
        
        let textStack = UIStackView(arrangedSubviews: [greetingLabel, userNameLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        
        // Кнопка уведомлений
        var notifConfig = UIButton.Configuration.filled()
        notifConfig.image = UIImage(systemName: "bell.badge.fill")
        notifConfig.baseBackgroundColor = .secondarySystemGroupedBackground
        notifConfig.baseForegroundColor = .label
        notifConfig.cornerStyle = .capsule
        notificationButton.configuration = notifConfig
        
        headerContainer.addSubview(avatarImageView)
        headerContainer.addSubview(textStack)
        headerContainer.addSubview(notificationButton)
        
        avatarImageView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.size.equalTo(44)
        }
        
        textStack.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        
        notificationButton.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.size.equalTo(44)
        }
    }

    func updateRatesPreview(_ rates: [ExchangeRateItem]) {
        ratesPreviewStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let titleHeader = UILabel()
        titleHeader.text = "Курсы НБРБ сегодня"
        titleHeader.font = .systemFont(ofSize: 14, weight: .bold)
        titleHeader.textColor = .secondaryLabel
        ratesPreviewStack.addArrangedSubview(titleHeader)
        
        for rate in rates {
            let row = UIStackView()
            row.axis = .horizontal
            row.distribution = .equalSpacing
            row.alignment = .center
            
            let name = UILabel()
            name.text = "\(rate.scale) \(rate.code) • \(rate.name)"
            name.font = .systemFont(ofSize: 15, weight: .medium)
            
            let val = UILabel()
            val.text = rate.rate.asCurrencyString(decimals: 4, symbol: "BYN")
            val.font = .systemFont(ofSize: 15, weight: .bold)
            
            row.addArrangedSubview(name)
            row.addArrangedSubview(val)
            ratesPreviewStack.addArrangedSubview(row)
        }
    }

    func updateQuickConverterResult(_ text: String) {
        quickConverterCard.setResultText(text)
    }

    func showLoading() { activityIndicator.startAnimating() }
    func hideLoading() { activityIndicator.stopAnimating() }
}
