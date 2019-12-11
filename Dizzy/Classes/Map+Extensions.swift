//
//  Map+Extensions.swift
//  Dizzy
//
//  Created by ジャティン on 2019/11/15.
//  Copyright © 2019 Me. All rights reserved.
//

import UIKit
import MapKit

public extension UIImageView {

    func showMapImage(with latitude: Double, with longitude: Double, bounds: CGRect) {

        let snapshot = MKMapSnapshotter.Options()

        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
        /// Annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        snapshot.region = region
        snapshot.scale = UIScreen.main.scale
        snapshot.size = CGSize(width: 380, height: 140)
        snapshot.showsBuildings = true

        let snapshotter = MKMapSnapshotter(options: snapshot)
        snapshotter.start { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let image = UIGraphicsImageRenderer(size: bounds.size).image { _ in
                    snapshot?.image.draw(at: .zero)
                    let annotation = MKPinAnnotationView(annotation: nil, reuseIdentifier: nil)
                    let image = annotation.image

                    if var points = snapshot?.point(for: coordinate), bounds.contains(points) {
                        points.x -= annotation.bounds.width / 2
                        points.y -= annotation.bounds.height / 2
                        points.x += annotation.centerOffset.x
                        points.y += annotation.centerOffset.y
                        image?.draw(at: points)
                    }
                }
                self.image = image
            }
        }
    }
}
