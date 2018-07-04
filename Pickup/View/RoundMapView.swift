//
//  RoundMapView.swift
//  Pickup
//
//  Created by Robert Puryear on 6/25/18.
//  Copyright © 2018 Robert Puryear. All rights reserved.
//

import UIKit
import MapKit

class RoundMapView: MKMapView {
    
    override func awakeFromNib() {
        setupView()
    }

    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 10.0
    }

}
