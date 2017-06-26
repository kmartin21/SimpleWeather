//
//  WeatherLocationsViewModel.swift
//  SimpleWeather
//
//  Created by keith martin on 6/25/17.
//  Copyright © 2017 keithmartin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire
import SwiftyJSON

struct WeatherLocationsViewModel {
    
    lazy var latestCityWeather: Driver<CityWeather> = self.fetchCityWeather()
    lazy var allCityWeather: Driver<[CityWeather]> = self.fetchAllCityWeather()
    private var observableLatestCityName: Observable<String>?
    private var observableAllCities: Observable<[String]>?
    
    init(observableLatestCityName: Observable<String>?, observableAllCities: Observable<[String]>?) {
        self.observableLatestCityName = observableLatestCityName
        self.observableAllCities = observableAllCities
    }
    
    private func fetchCityWeather() -> Driver<CityWeather> {
        return observableLatestCityName!
            .flatMapLatest { cityName -> Observable<(HTTPURLResponse, Any)> in
                let cityNameEncoded = cityName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                return RxAlamofire
                    .requestJSON(.get, "http://api.openweathermap.org/data/2.5/weather?q=\(cityNameEncoded)&appid=86ee331c449a48684b8b1f13698ddc04")
                    .debug()
                    .catchError { _ in
                        return Observable.never()
                }  
            }
            .map { (response, json) in
                if let jsonDict = json as? [String: Any] {
                    return CityWeather(data: jsonDict)
                } else {
                    return CityWeather()
                }
            }
            .asDriver(onErrorJustReturn: CityWeather())
    }
    
    private func fetchAllCityWeather() -> Driver<[CityWeather]> {
        return observableAllCities!
            .flatMapLatest { cities -> Observable<(HTTPURLResponse, Any)> in
                let cityNameEncoded = cityName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                return RxAlamofire
                    .requestJSON(.get, "http://api.openweathermap.org/data/2.5/weather?q=\(cityNameEncoded)&appid=86ee331c449a48684b8b1f13698ddc04")
                    .debug()
                    .catchError { _ in
                        return Observable.never()
                }
            }
            .map { (response, json) in
                if let jsonDict = json as? [String: Any] {
                    return CityWeather(data: jsonDict)
                } else {
                    return CityWeather()
                }
            }
            .asDriver(onErrorJustReturn: CityWeather())
    }
}
