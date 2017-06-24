//
//  SearchLocationViewController.swift
//  WeatherApp
//
//  Created by keith martin on 6/12/17.
//  Copyright © 2017 keithmartin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchLocationViewController: UITableViewController, UISearchBarDelegate {
    private var searchDataSource = Variable<[String]>([])
    private var resultSearchController = UISearchController(searchResultsController: nil)
    private var selectedCityCallback: ((String) -> Void)?
    private let disposeBag = DisposeBag()
    let selectedCity = PublishSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.placeholder = "Search by city"
        resultSearchController.searchBar.delegate = self

        resultSearchController.searchBar.barTintColor = UIColor(r: 236, g: 240, b: 241)
        resultSearchController.searchBar.tintColor = UIColor(r: 102, g: 102, b: 102)
        resultSearchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = resultSearchController.searchBar
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //self.tableView.reloadData()
        tableView.delegate = nil
        tableView.dataSource = nil
        searchDataSource.asObservable()
            .bind(to: self.tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { (row, _, cell) in
                cell.textLabel?.text = self.searchDataSource.value[row]
            }
            .addDisposableTo(disposeBag)
        
        tableView.rx.modelSelected(String.self)
        .subscribe(onNext: { cityName in
            self.selectedCity.onNext(cityName)
        }).addDisposableTo(disposeBag)
        
        
        
        let searchBar = resultSearchController.searchBar
        searchBar
            .rx.text
            .orEmpty
            .debounce(0.2, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { city in
                guard !city.isEmpty else {
                    self.searchDataSource.value.removeAll()
                    return
                }
                
                let cityURLString: String = city.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                
                let cityURL: String = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(cityURLString)&types=(cities)&language=en&key=AIzaSyDHSl4JCpz1YOQCoSAzy-MKj1F74s0ST6g"
                
                let url = URL(string: cityURL)
                let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            self.parseJSON(dict: json)
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                })
                
                task.resume()
            }).addDisposableTo(disposeBag)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.resultSearchController.searchBar.becomeFirstResponder()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard tableView.numberOfRows(inSection: 0) > 0 else {
//            return
//        }
//        selectedCityCallback?(searchDataSource[indexPath.row])
//        self.dismiss(animated: true, completion: nil)
//        self.dismiss(animated: true, completion: nil)
//    }
    
    func parseJSON(dict : NSDictionary) {
        let cityPredictions: [[String: Any]] = dict.object(forKey: "predictions") as! [[String: Any]]
        
        if (cityPredictions.count > 0) {
            let cities = cityPredictions.map { (prediction: [String: Any]) -> String in
                return prediction["description"]! as! String
            }
            
            searchDataSource.value = cities
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
