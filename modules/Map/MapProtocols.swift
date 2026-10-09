//
//  MapProtocols.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//

import Foundation
import CoreLocation

protocol MapViewProtocol: AnyObject {
    func displayPoints(_ points: [BankPoint])
    func centerMap(on coordinate: CLLocationCoordinate2D)
    func showPointDetails(_ point: BankPoint)
}

protocol MapPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectPoint(_ point: BankPoint)
}
