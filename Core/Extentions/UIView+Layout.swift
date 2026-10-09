//
//  UIView+Layout.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//
import UIKit
import SnapKit

extension UIView {
    func applyModernCardStyle(cornerRadius: CGFloat = 20) {
        layer.cornerRadius = cornerRadius
        layer.cornerCurve = .continuous
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.06
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowRadius = 14
    }
}
