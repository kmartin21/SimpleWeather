//
//  HttpCityWeather.swift
//  WeatherApp
//
//  Created by keith martin on 6/13/17.
//  Copyright © 2017 keithmartin. All rights reserved.
//

import Foundation

protocol CityWeatherDelegate: class {
    func cityWeatherDidLoad(cityWeather: CityWeather)
    func allCityWeatherDidLoad(allCityWeather: [CityWeather])
}

class HttpCityWeather {
    
    weak var delegate: CityWeatherDelegate?
    let client: RestClient
    
    init() {
        client = RestClient()
    }
    
    func getCityWeather(city: String){
        let cityURLString: String = city.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        client.makeGetRequest(url: URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(cityURLString)&appid=86ee331c449a48684b8b1f13698ddc04")) { (json) in
            let cityWeather = CityWeather(data: json)
            self.delegate?.cityWeatherDidLoad(cityWeather: cityWeather)
        }
    }
    
    func getAllCityWeather(cities: [String]) {
        let cityURLs: [URL] = cities.map { (city) -> URL in
            let cityURLString: String = city.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            return URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(cityURLString)&appid=86ee331c449a48684b8b1f13698ddc04")!
        }
        client.loadAll(urls: cityURLs) { (jsonResults) in
            let allCityWeather = jsonResults.map({ (jsonResult) -> CityWeather in
                return CityWeather(data: jsonResult)
            })
            self.delegate?.allCityWeatherDidLoad(allCityWeather: allCityWeather)
        }
    }
}
