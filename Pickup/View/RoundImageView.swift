//
//  RoundImageView.swift
//  Pickup
//
//  Created by Robert Puryear on 6/25/18.
//  Copyright © 2018 Robert Puryear. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {
    
    override func awakeFromNib() {
        setupView()
    }

    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }

}
