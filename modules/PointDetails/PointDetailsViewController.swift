//
//  PointDetailsViewController.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//
import UIKit
import MapKit
import SnapKit

final class PointDetailsViewController: UIViewController {
    private let point: BankPoint

    init(point: BankPoint) {
        self.point = point
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        let titleLabel = UILabel()
        titleLabel.text = point.title
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        
        let addressLabel = UILabel()
        addressLabel.text = point.address
        addressLabel.font = .systemFont(ofSize: 15, weight: .regular)
        addressLabel.textColor = .secondaryLabel
        
        let hoursLabel = UILabel()
        hoursLabel.text = "\(point.workingHours)"
        hoursLabel.font = .systemFont(ofSize: 15, weight: .medium)
        
        let servicesTitle = UILabel()
        servicesTitle.text = "Доступные услуги:"
        servicesTitle.font = .systemFont(ofSize: 16, weight: .semibold)
        
        let servicesLabel = UILabel()
        servicesLabel.text = point.services.map { "• \($0)" }.joined(separator: "\n")
        servicesLabel.numberOfLines = 0
        servicesLabel.textColor = .secondaryLabel
        servicesLabel.font = .systemFont(ofSize: 14)
        
        let routeButton = UIButton(type: .system)
        routeButton.setTitle("Построить маршрут", for: .normal)
        routeButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        routeButton.backgroundColor = .systemBlue
        routeButton.tintColor = .white
        routeButton.layer.cornerRadius = 14
        routeButton.layer.cornerCurve = .continuous
        routeButton.addTarget(self, action: #selector(openRoute), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            addressLabel,
            hoursLabel,
            servicesTitle,
            servicesLabel,
            UIView(),
            routeButton
        ])
        stack.axis = .vertical
        stack.spacing = 14

        view.addSubview(stack)
        
        routeButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        stack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(28)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }

    @objc private func openRoute() {
        let placemark = MKPlacemark(coordinate: point.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = point.title
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}
