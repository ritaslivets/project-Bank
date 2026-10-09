//
//  BAlanceCardView.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//

import UIKit
import SnapKit

final class BalanceCardView: UIView {
    private let titleLabel = UILabel()
    private let balanceLabel = UILabel()
    private let cardIcon = UIImageView()
    private let numberLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        backgroundColor = .label
        applyModernCardStyle(cornerRadius: 24)
        
        titleLabel.text = "Счет в BYN (Белкарт-Премиум)"
        titleLabel.textColor = .systemBackground.withAlphaComponent(0.7)
        titleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        
        balanceLabel.text = "5 480,50 BYN"
        balanceLabel.textColor = .systemBackground
        balanceLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        
        numberLabel.text = "•••• 9421"
        numberLabel.textColor = .systemBackground.withAlphaComponent(0.6)
        numberLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .medium)
        
        cardIcon.image = UIImage(systemName: "creditcard.fill")
        cardIcon.tintColor = .systemBackground
        
        [titleLabel, balanceLabel, numberLabel, cardIcon].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(22)
        }
        
        balanceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(22)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(22)
        }
        
        cardIcon.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(22)
            make.size.equalTo(CGSize(width: 28, height: 22))
        }
    }
}
