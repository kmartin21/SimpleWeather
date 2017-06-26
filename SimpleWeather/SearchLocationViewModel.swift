//
//  SearchLocationViewModel.swift
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

struct SearchLocationViewModel {
    
    lazy var cityNames: Driver<[String]> = self.fetchCityNames()
    private var cityName: Observable<String>
    private let queue = ConcurrentDispatchQueueScheduler(qos: .background)
    
    init(observableCityName: Observable<String>) {
        self.cityName = observableCityName
    }
    
    private func fetchCityNames() -> Driver<[String]> {
        return cityName
            .observeOn(queue)
            .flatMapLatest { cityName -> Observable<(HTTPURLResponse, Any)> in
                let cityNameEncoded = cityName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                return RxAlamofire
                    .requestJSON(.get, "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(cityNameEncoded)&types=(cities)&language=en&key=AIzaSyDHSl4JCpz1YOQCoSAzy-MKj1F74s0ST6g")
                    .debug()
                    .catchError { _ in
                        return Observable.never()
                }
            }
            .observeOn(queue)
            .map { (response, json) -> [String] in
                let jsonObject = JSON(json)
                let cities = jsonObject["predictions"].arrayValue
                return cities.flatMap({ (prediction) -> String in
                    let description = prediction.dictionaryValue
                    return description["description"]!.stringValue
                })
            }
            .asDriver(onErrorJustReturn: [])
    }
}
