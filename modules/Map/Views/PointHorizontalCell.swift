//
//  PointHorizontalCell.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//
import UIKit
import SnapKit

final class PointHorizontalCell: UICollectionViewCell {
    static let reuseId = "PointHorizontalCell"
    
    private let titleLabel = UILabel()
    private let addressLabel = UILabel()
    private let typeBadge = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        contentView.backgroundColor = .secondarySystemGroupedBackground
        contentView.applyModernCardStyle(cornerRadius: 18)
        
        titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
        addressLabel.font = .systemFont(ofSize: 13, weight: .regular)
        addressLabel.textColor = .secondaryLabel
        
        typeBadge.font = .systemFont(ofSize: 11, weight: .bold)
        typeBadge.layer.cornerRadius = 6
        typeBadge.layer.masksToBounds = true

        [typeBadge, titleLabel, addressLabel].forEach { contentView.addSubview($0) }
        
        typeBadge.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(14)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(typeBadge.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(14)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(14)
        }
    }

    func configure(with point: BankPoint) {
        titleLabel.text = point.title
        addressLabel.text = point.address
        typeBadge.text = " \(point.type.rawValue.uppercased()) "
        
        if point.type == .branch {
            typeBadge.backgroundColor = .systemBlue.withAlphaComponent(0.15)
            typeBadge.textColor = .systemBlue
        } else {
            typeBadge.backgroundColor = .systemPurple.withAlphaComponent(0.15)
            typeBadge.textColor = .systemPurple
        }
    }
}
