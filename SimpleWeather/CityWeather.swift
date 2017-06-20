//
//  CityWeather.swift
//  WeatherApp
//
//  Created by keith martin on 6/13/17.
//  Copyright © 2017 keithmartin. All rights reserved.
//

import Foundation

enum Condition {
    case thunderstorm
    case rain
    case snow
    case atmosphere
    case clear
    case clouds
}

class CityWeather {
      private var temperature = "--ºF"
      private var city = "--"
      private var condition = Condition.atmosphere
      private var description = "--"
      private var windSpeed = "-- mph"
      private var loading: Bool = true
    
    init() {}
    
    init(data: [String: Any]) {
        self.temperature = parseTemp(data: data)
        self.city = parseCity(data: data)
        self.condition = parseCondition(data: data)
        self.description = parseDescription(data: data)
        self.windSpeed = parseWindspeed(data: data)
        loading = false
    }
    
    func parseTemp(data: [String: Any]) -> String {
        guard let tempData = data["main"] as? [String: Any],
            let temp = tempData["temp"] as? Int else {
                return self.temperature
        }
        let convertedTemp = convertKelvinToFahrenheit(kelvin: "\(temp)")
        return "\(convertedTemp)ºF"
    }
    
    func parseCity(data: [String: Any]) -> String {
        guard let city = data["name"] as? String else {
                return self.city
        }
        return city
    }
    
    func parseCondition(data: [String: Any]) -> Condition {
        guard let weatherData = data["weather"] as? [[String: Any]],
        let condID = weatherData[0]["id"] as? Int else {
                return self.condition
        }
        switch condID {
        case 200..<300:
            return .thunderstorm
        case 300..<600:
            return .rain
        case 600..<700:
            return .snow
        case 700..<800:
            return .atmosphere
        case 800:
            return .clear
        case 801..<900:
            return .clouds
        default:
            return .atmosphere
        }
    }
    
    func parseDescription(data: [String: Any]) -> String {
        guard let weatherData = data["weather"] as? [[String: Any]],
            let description = weatherData[0]["description"] as? String else {
                return self.description
        }
        return description
    }
    
    func parseWindspeed(data: [String: Any]) -> String {
        guard let windData = data["wind"] as? [String: Any],
            let windSpeed = windData["speed"] as? Int else {
                return self.windSpeed
        }
        return "\(convertMSToMPH(ms: windSpeed)) mph"
    }
    
    func getTemp() -> String {
        return temperature
    }
    
    func getCity() -> String {
        return city
    }
    
    func getCondition() -> Condition {
        return condition
    }
    
    func getDescription() -> String {
        return description
    }
    
    func getWindSpeed() -> String {
        return windSpeed
    }
    
    func isLoading() -> Bool {
        return loading
    }
    
}
