//
//  MapPresenter.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//

import Foundation

final class MapPresenter: MapPresenterProtocol {
    private weak var view: MapViewProtocol?
    private let pointsService: BankPointsServiceProtocol

    init(view: MapViewProtocol, pointsService: BankPointsServiceProtocol) {
        self.view = view
        self.pointsService = pointsService
    }

    func viewDidLoad() {
        let points = pointsService.fetchPoints()
        view?.displayPoints(points)
        if let first = points.first {
            view?.centerMap(on: first.coordinate)
        }
    }

    func didSelectPoint(_ point: BankPoint) {
        view?.centerMap(on: point.coordinate)
        view?.showPointDetails(point)
    }
}
