//
//  QuickConverterCardView.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//
import UIKit
import SnapKit

final class QuickConverterCardView: UIView {
    var onAmountChanged: ((Double) -> Void)?
    
    private let titleLabel = UILabel()
    private let inputField = UITextField()
    private let resultLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        backgroundColor = .secondarySystemGroupedBackground
        applyModernCardStyle(cornerRadius: 20)
        
        titleLabel.text = "Быстрый обмен (USD → RUB)"
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .secondaryLabel
        
        inputField.text = "100"
        inputField.keyboardType = .decimalPad
        inputField.font = .systemFont(ofSize: 22, weight: .bold)
        inputField.borderStyle = .none
        inputField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        
        let prefix = UILabel()
        prefix.text = "$ "
        prefix.font = .systemFont(ofSize: 22, weight: .bold)
        prefix.textColor = .label
        inputField.leftView = prefix
        inputField.leftViewMode = .always
        
        resultLabel.text = "= 0 ₽"
        resultLabel.font = .systemFont(ofSize: 20, weight: .bold)
        resultLabel.textColor = .systemGreen
        resultLabel.textAlignment = .right

        [titleLabel, inputField, resultLabel].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(18)
        }
        
        inputField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(18)
            make.width.equalTo(120)
            make.bottom.equalToSuperview().inset(16)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.centerY.equalTo(inputField)
            make.leading.equalTo(inputField.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(18)
        }
    }

    @objc private func textChanged() {
        let text = inputField.text?.replacingOccurrences(of: ",", with: ".") ?? "0"
        let val = Double(text) ?? 0.0
        onAmountChanged?(val)
    }

    func setResultText(_ text: String) {
        resultLabel.text = text
    }
}
