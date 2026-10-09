//
//  RateDetailedCell.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//
import UIKit
import SnapKit

final class RateDetailedCell: UITableViewCell {
    static let reuseId = "RateDetailedCell"
    var onFavoriteTap: (() -> Void)?
    
    private let container = UIView()
    private let codeLabel = UILabel()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let changeLabel = UILabel()
    private let favButton = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        container.backgroundColor = .secondarySystemGroupedBackground
        container.applyModernCardStyle(cornerRadius: 16)
        
        codeLabel.font = .systemFont(ofSize: 17, weight: .bold)
        nameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        nameLabel.textColor = .secondaryLabel
        
        priceLabel.font = .systemFont(ofSize: 17, weight: .bold)
        priceLabel.textAlignment = .right
        
        changeLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        changeLabel.textAlignment = .right
        
        favButton.addTarget(self, action: #selector(favTapped), for: .touchUpInside)

        contentView.addSubview(container)
        [favButton, codeLabel, nameLabel, priceLabel, changeLabel].forEach { container.addSubview($0) }
        
        container.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        favButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.centerY.equalToSuperview()
            make.size.equalTo(32)
        }
        
        codeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalTo(favButton.snp.trailing).offset(10)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(codeLabel.snp.bottom).offset(2)
            make.leading.equalTo(codeLabel)
            make.trailing.lessThanOrEqualTo(changeLabel.snp.leading).offset(-8)
            make.bottom.equalToSuperview().offset(-14)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        changeLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(2)
            make.trailing.equalTo(priceLabel)
        }
    }

    @objc private func favTapped() {
        onFavoriteTap?()
    }
    func configure(with item: ExchangeRateItem) {
        codeLabel.text = "\(item.scale) \(item.code)"
        nameLabel.text = item.name
        priceLabel.text = item.rate.asCurrencyString(decimals: 4, symbol: "BYN")
        changeLabel.text = item.unitRate.asCurrencyString(decimals: 4, symbol: "BYN за 1 шт.")
        changeLabel.textColor = .secondaryLabel
        
        let imageName = item.isFavorite ? "star.fill" : "star"
        favButton.setImage(UIImage(systemName: imageName), for: .normal)
        favButton.tintColor = item.isFavorite ? .systemYellow : .systemGray3
    }
}
