//
//  MapViewController.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//
import UIKit
import MapKit
import SnapKit

final class MapViewController: UIViewController, MapViewProtocol {
    var presenter: MapPresenterProtocol!
    private var points: [BankPoint] = []

    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        return map
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 250, height: 110)
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.register(PointHorizontalCell.self, forCellWithReuseIdentifier: PointHorizontalCell.reuseId)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        title = "Карта"
        view.addSubview(mapView)
        view.addSubview(collectionView)
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(120)
        }
    }

    func displayPoints(_ points: [BankPoint]) {
        self.points = points
        mapView.removeAnnotations(mapView.annotations)
        let anns = points.map { BankPointAnnotation(point: $0) }
        mapView.addAnnotations(anns)
        collectionView.reloadData()
    }

    func centerMap(on coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 3000, longitudinalMeters: 3000)
        mapView.setRegion(region, animated: true)
    }

    func showPointDetails(_ point: BankPoint) {
        let detailsVC = PointDetailsViewController(point: point)
        if let sheet = detailsVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(detailsVC, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let ann = view.annotation as? BankPointAnnotation else { return }
        if let index = points.firstIndex(where: { $0.id == ann.point.id }) {
            collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}

extension MapViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        points.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PointHorizontalCell.reuseId,
            for: indexPath
        ) as? PointHorizontalCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: points[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectPoint(points[indexPath.item])
    }
}
