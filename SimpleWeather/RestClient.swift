//
//  RestClient.swift
//  WeatherApp
//
//  Created by keith martin on 6/13/17.
//  Copyright © 2017 keithmartin. All rights reserved.
//

import Foundation

class RestClient {
        
    func makeGetRequest(url: URL?, completion: @escaping (([String: Any]) -> ())){
        guard let url = url else { return }
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                    completion(jsonResult)
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        })        
        task.resume()
    }
    
    func loadAll(urls: [URL], completion: @escaping ([[String: Any]]) -> ()) {
        let session = URLSession(configuration: .default)
        var allData = [[String: Any]]()
        let sessionQueue = DispatchQueue(label: "sessionQueue")
        let semaphore = DispatchSemaphore(value: 1)

        for url in urls {
            sessionQueue.async {
                semaphore.wait()
                session.dataTask(with: url) { (data, _, _) in
                    defer {
                        completion(allData)
                    }
                    guard let data = data else { return }
                    
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            allData.append(jsonResult)
                            semaphore.signal()
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        semaphore.signal()
                    }
                }.resume()
            }
        }
    }
}
