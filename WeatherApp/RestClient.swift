//
//  RestClient.swift
//  WeatherApp
//
//  Created by keith martin on 6/13/17.
//  Copyright © 2017 keithmartin. All rights reserved.
//

import Foundation

protocol RestClientDelegate: class {
    func dataDidLoad(json: [String: Any])
}

class RestClient {
    
    weak var delegate: RestClientDelegate?
    
    func makeGetRequest(url: URL?){
        guard let url = url else { return }
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                    self.delegate?.dataDidLoad(json: jsonResult)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        })        
        task.resume()
    }
}
