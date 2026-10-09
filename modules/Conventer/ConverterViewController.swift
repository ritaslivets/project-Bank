//
//  ConverterViewController.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//

import UIKit
import SnapKit

final class ConverterViewController: UIViewController, ConverterViewProtocol {
    var presenter: ConverterPresenterProtocol!
    
    private var currencyCodes: [String] = []
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    
    private let sourceCard = UIView()
    private let sourceTitleLabel = UILabel()
    private let sourceBtn = UIButton(type: .system)
    private let amountField = UITextField()
    
    private let swapButton = UIButton(type: .system)
    
    private let targetCard = UIView()
    private let targetTitleLabel = UILabel()
    private let targetBtn = UIButton(type: .system)
    private let resultLabel = UILabel()
    
    private let rateInfoBadge = UIView()
    private let rateInfoLabel = UILabel()
    
    private let quickAmountsStack = UIStackView()
    private let quickAmounts = [100, 500, 1000, 5000]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        title = "Конвертер валют"
        view.backgroundColor = .systemGroupedBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .onDrag
        
        contentStack.axis = .vertical
        contentStack.spacing = 16
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 16, left: 16, bottom: 32, right: 16))
            make.width.equalTo(scrollView.snp.width).offset(-32)
        }
        
        setupCards()
        setupSwapButton()
        setupQuickAmounts()
    }

    private func setupCards() {
        sourceCard.backgroundColor = .secondarySystemGroupedBackground
        sourceCard.applyModernCardStyle(cornerRadius: 22)
        
        sourceTitleLabel.text = "Вы отдаете"
        sourceTitleLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        sourceTitleLabel.textColor = .secondaryLabel
        
        amountField.font = .systemFont(ofSize: 34, weight: .bold)
        amountField.text = "100"
        amountField.keyboardType = .decimalPad
        amountField.borderStyle = .none
        amountField.textColor = .label
        amountField.addTarget(self, action: #selector(amountChanged), for: .editingChanged)
        
        styleCurrencyButton(sourceBtn)
        
        sourceCard.addSubview(sourceTitleLabel)
        sourceCard.addSubview(amountField)
        sourceCard.addSubview(sourceBtn)
        
        sourceTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(18)
        }
        
        amountField.snp.makeConstraints { make in
            make.top.equalTo(sourceTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(18)
            make.trailing.equalTo(sourceBtn.snp.leading).offset(-12)
            make.bottom.equalToSuperview().inset(18)
        }
        
        sourceBtn.snp.makeConstraints { make in
            make.centerY.equalTo(amountField)
            make.trailing.equalToSuperview().inset(18)
            make.width.greaterThanOrEqualTo(100)
            make.height.equalTo(44)
        }
        
        targetCard.backgroundColor = .secondarySystemGroupedBackground
        targetCard.applyModernCardStyle(cornerRadius: 22)
        
        targetTitleLabel.text = "Вы получаете"
        targetTitleLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        targetTitleLabel.textColor = .secondaryLabel
        
        resultLabel.font = .systemFont(ofSize: 34, weight: .bold)
        resultLabel.textColor = .systemBlue
        resultLabel.text = "0.00"
        resultLabel.adjustsFontSizeToFitWidth = true
        resultLabel.minimumScaleFactor = 0.6
        
        styleCurrencyButton(targetBtn)
        
        targetCard.addSubview(targetTitleLabel)
        targetCard.addSubview(resultLabel)
        targetCard.addSubview(targetBtn)
        
        targetTitleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(18)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(targetTitleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(18)
            make.trailing.equalTo(targetBtn.snp.leading).offset(-12)
            make.bottom.equalToSuperview().inset(18)
        }
        
        targetBtn.snp.makeConstraints { make in
            make.centerY.equalTo(resultLabel)
            make.trailing.equalToSuperview().inset(18)
            make.width.greaterThanOrEqualTo(100)
            make.height.equalTo(44)
        }
        
        contentStack.addArrangedSubview(sourceCard)
        contentStack.addArrangedSubview(targetCard)
    }

    private func setupSwapButton() {
        var swapConfig = UIButton.Configuration.filled()
        swapConfig.image = UIImage(systemName: "arrow.up.arrow.down")
        swapConfig.baseBackgroundColor = .systemBlue
        swapConfig.baseForegroundColor = .white
        swapConfig.cornerStyle = .capsule
        swapButton.configuration = swapConfig
        swapButton.addTarget(self, action: #selector(swapTapped), for: .touchUpInside)
        
        view.addSubview(swapButton)
        swapButton.snp.makeConstraints { make in
            make.centerY.equalTo(sourceCard.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.size.equalTo(46)
        }
    }

    private func setupQuickAmounts() {
        let label = UILabel()
        label.text = "Быстрый выбор суммы:"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .secondaryLabel
        contentStack.addArrangedSubview(label)
        
        quickAmountsStack.axis = .horizontal
        quickAmountsStack.spacing = 10
        quickAmountsStack.distribution = .fillEqually
        
        for amount in quickAmounts {
            var btnConfig = UIButton.Configuration.filled()
            btnConfig.title = "\(amount)"
            btnConfig.baseBackgroundColor = .tertiarySystemGroupedBackground
            btnConfig.baseForegroundColor = .label
            btnConfig.cornerStyle = .medium
            
            let btn = UIButton(configuration: btnConfig)
            btn.tag = amount
            btn.addTarget(self, action: #selector(quickAmountTapped(_:)), for: .touchUpInside)
            quickAmountsStack.addArrangedSubview(btn)
        }
        
        contentStack.addArrangedSubview(quickAmountsStack)
        quickAmountsStack.snp.makeConstraints { make in
            make.height.equalTo(42)
        }
    }

    private func styleCurrencyButton(_ button: UIButton) {
        var config = UIButton.Configuration.tinted()
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .systemBlue
        config.cornerStyle = .medium
        config.image = UIImage(systemName: "chevron.down")
        config.imagePlacement = .trailing
        config.imagePadding = 6
        button.configuration = config
    }

    // MARK: - Actions & Protocol Implementation
    @objc private func quickAmountTapped(_ sender: UIButton) {
        feedbackGenerator.impactOccurred()
        amountField.text = "\(sender.tag)"
        presenter.didChangeAmount(Double(sender.tag))
    }

    @objc private func amountChanged() {
        let text = amountField.text?.replacingOccurrences(of: ",", with: ".") ?? "0"
        presenter.didChangeAmount(Double(text) ?? 0)
    }

    @objc private func swapTapped() {
        feedbackGenerator.impactOccurred()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.swapButton.transform = self.swapButton.transform.rotated(by: .pi)
        }) { _ in
            self.swapButton.transform = .identity
        }
        
        presenter.didTapSwap()
    }

    func setupCurrencies(list: [String]) {
        self.currencyCodes = list
        updateMenus()
    }

    private func updateMenus() {
        sourceBtn.menu = UIMenu(children: currencyCodes.map { code in
            UIAction(title: code) { [weak self] _ in
                self?.feedbackGenerator.impactOccurred()
                self?.presenter.didSelectSourceCurrency(code)
            }
        })
        sourceBtn.showsMenuAsPrimaryAction = true
        
        targetBtn.menu = UIMenu(children: currencyCodes.map { code in
            UIAction(title: code) { [weak self] _ in
                self?.feedbackGenerator.impactOccurred()
                self?.presenter.didSelectTargetCurrency(code)
            }
        })
        targetBtn.showsMenuAsPrimaryAction = true
    }

    func updateResult(text: String) {
        resultLabel.text = text
    }
    
    func setSourceTitle(_ title: String) {
        sourceBtn.configuration?.title = title
    }
    
    func setTargetTitle(_ title: String) {
        targetBtn.configuration?.title = title
    }
}
