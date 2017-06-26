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

struct WeatherLocationsViewModel {
    
    lazy var latestCityWeather: Observable<CityWeather> = self.fetchCityWeather()
    lazy var allCityWeather: Observable<[CityWeather]> = self.fetchAllCityWeather()
    private var observableLatestCityName: Observable<String>?
    private var observableAllCities: Observable<[String]>?
    
    init(observableLatestCityName: Observable<String>?, observableAllCities: Observable<[String]>?) {
        self.observableLatestCityName = observableLatestCityName
        self.observableAllCities = observableAllCities
    }
    
    private func fetchCityWeather() -> Observable<CityWeather> {
        let queue = SerialDispatchQueueScheduler(qos: .background)
        
        return observableLatestCityName!
            .observeOn(queue)
            .flatMapLatest { cityName -> Observable<(HTTPURLResponse, Any)> in
                let cityNameEncoded = cityName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                return RxAlamofire
                    .requestJSON(.get, "http://api.openweathermap.org/data/2.5/weather?q=\(cityNameEncoded)&appid=86ee331c449a48684b8b1f13698ddc04")
                    .catchError { _ in
                        return Observable.never()
                }  
            }
            .map { (_, json) in
                if let jsonDict = json as? [String: Any] {
                    return CityWeather(data: jsonDict)
                } else {
                    return CityWeather()
                }
            }
    }
    
    private func fetchAllCityWeather() -> Observable<[CityWeather]>{
        let queue = SerialDispatchQueueScheduler(qos: .background)

        return observableAllCities!
            .observeOn(queue)
            .flatMapLatest { (cities: [String]) -> Observable<[CityWeather]> in
                return Observable.from(cities).asObservable().flatMap { city -> Observable<CityWeather> in
                    let cityNameEncoded = city.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                    return RxAlamofire
                        .requestJSON(.get, "http://api.openweathermap.org/data/2.5/weather?q=\(cityNameEncoded)&appid=86ee331c449a48684b8b1f13698ddc04")
                        .catchError { _ in
                            return Observable.never()
                        }
                    .map { (_, json) -> CityWeather in
                        if let jsonDict = json as? [String: Any] {
                            return CityWeather(data: jsonDict)
                        } else {
                            return CityWeather()
                        }
                    }
                }.toArray()
            }
    }
}
