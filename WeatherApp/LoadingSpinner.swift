//
//  LoadingSpinner.swift
//  WeatherApp
//
//  Created by keith martin on 6/13/17.
//  Copyright © 2017 keithmartin. All rights reserved.
//

import UIKit

class LoadingSpinner: UIImageView {
    
    let initialImage: UIImage
    
    override init(frame: CGRect) {
        initialImage = UIImage(named: "spinner1")!
        super.init(frame: frame)
        self.image = initialImage
        self.animationImages = [UIImage(named: "spinner1")!, UIImage(named: "spinner2")!, UIImage(named: "spinner3")!, UIImage(named: "spinner4")!, UIImage(named: "spinner5")!, UIImage(named: "spinner6")!, UIImage(named: "spinner7")!, UIImage(named: "spinner8")!]
        self.animationDuration = 0.8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
