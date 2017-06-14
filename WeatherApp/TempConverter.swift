//
//  TempConverter.swift
//  WeatherApp
//
//  Created by keith martin on 6/13/17.
//  Copyright © 2017 keithmartin. All rights reserved.
//

import Foundation

func convertKelvinToFahrenheit(kelvin: String) -> String {
    
    let kelvinFloat = Float(kelvin)
    let fahrenheitFloat: Float = (kelvinFloat! - 273.15) * 9/5 + 32
    let roundedUpFahrenheitInt: Int = Int(ceilf(fahrenheitFloat))
    
    return String(roundedUpFahrenheitInt)
}

func convertMSToMPH(ms: Int) -> Int {
    return Int(Double(ms) * 2.236936284)
}
