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
}

class HttpCityWeather: RestClientDelegate {
    
    weak var delegate: CityWeatherDelegate?
    let client: RestClient
    
    init() {
        client = RestClient()
        client.delegate = self
    }
    
    func getCityWeather(city: String){
        let cityURLString: String = city.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        client.makeGetRequest(url: URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(cityURLString)&appid=86ee331c449a48684b8b1f13698ddc04"))
    }
    
    func dataDidLoad(json: [String: Any]) {
        let cityWeather = CityWeather(data: json)
        delegate?.cityWeatherDidLoad(cityWeather: cityWeather)
    }
}
