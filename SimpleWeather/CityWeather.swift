//
//  CityWeather.swift
//  WeatherApp
//
//  Created by keith martin on 6/13/17.
//  Copyright © 2017 keithmartin. All rights reserved.
//

import Foundation

enum Condition: String {
    case thunderstorm
    case rain
    case snow
    case atmosphere
    case clear
    case clouds
}

class CityWeather: NSObject, NSCoding {
      private var temperature = "--ºF"
      private var city = "--"
      private var condition = Condition.atmosphere
      private var detailDescription = "--"
      private var windSpeed = "-- mph"
      private var loading: Bool = true
    
    override init() {}
    
    init(data: [String: Any]) {
        super.init()
        self.temperature = parseTemp(data: data)
        self.city = parseCity(data: data)
        self.condition = parseCondition(data: data)
        self.detailDescription = parseDetailDescription(data: data)
        self.windSpeed = parseWindspeed(data: data)
        loading = false
    }
    
    init(temperature: String, city: String, condition: String, detailDescription: String, windSpeed: String) {
        self.temperature = temperature
        self.city = city
        self.condition = Condition(rawValue: condition)!
        self.detailDescription = detailDescription
        self.windSpeed = windSpeed
        loading = false
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard let temperature = aDecoder.decodeObject(forKey: "temperature") as? String,
            let city = aDecoder.decodeObject(forKey: "city") as? String,
            let condition = aDecoder.decodeObject(forKey: "condition") as? Condition.RawValue,
            let detailDescription = aDecoder.decodeObject(forKey: "detailDescription") as? String,
            let windSpeed = aDecoder.decodeObject(forKey: "windSpeed") as? String
            else { return nil }
        
        self.init(
            temperature: temperature,
            city: city,
            condition: condition,
            detailDescription: detailDescription,
            windSpeed: windSpeed
        )
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(temperature, forKey: "temperature")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(condition.rawValue, forKey: "condition")
        aCoder.encode(detailDescription, forKey: "detailDescription")
        aCoder.encode(windSpeed, forKey: "windSpeed")
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
    
    func parseDetailDescription(data: [String: Any]) -> String {
        guard let weatherData = data["weather"] as? [[String: Any]],
            let detailDescription = weatherData[0]["description"] as? String else {
                return self.detailDescription
        }
        return detailDescription
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
    
    func getDetailDescription() -> String {
        return detailDescription
    }
    
    func getWindSpeed() -> String {
        return windSpeed
    }
    
    func isLoading() -> Bool {
        return loading
    }
    
    func setLoading(_ loading: Bool) {
        self.loading = loading
    }
    
}
