//
//  BankPointAnnotation.swift
//  project_Bank
//
//  Created by Slivets Margarita on 9.10.26.
//
import MapKit

final class BankPointAnnotation: MKPointAnnotation {
    let point: BankPoint
    
    init(point: BankPoint) {
        self.point = point
        super.init()
        self.coordinate = point.coordinate
        self.title = point.title
        self.subtitle = point.address
    }
}
