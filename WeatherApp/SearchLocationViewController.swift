//
//  SearchLocationViewController.swift
//  WeatherApp
//
//  Created by keith martin on 6/12/17.
//  Copyright © 2017 keithmartin. All rights reserved.
//

import UIKit

class SearchLocationViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    let tableData = [String]()
    var filteredTableData = [String]()
    var resultSearchController = UISearchController(searchResultsController: nil)
    var selectedCityCallback: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultSearchController.searchResultsUpdater = self
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.placeholder = "Search by city"
        resultSearchController.searchBar.delegate = self

        resultSearchController.searchBar.barTintColor = UIColor(r: 236, g: 240, b: 241)
        resultSearchController.searchBar.tintColor = UIColor(r: 102, g: 102, b: 102)
        resultSearchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = resultSearchController.searchBar
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.reloadData()
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTableData.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView.numberOfRows(inSection: 0) > 0 else {
            return
        }
        selectedCityCallback?(filteredTableData[indexPath.row])
        self.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
        cell.textLabel?.text = filteredTableData[indexPath.row]
            
        return cell
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        let city = searchController.searchBar.text!
        guard !city.isEmpty else {
            filteredTableData.removeAll()
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
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
    }
    
    func parseJSON(dict : NSDictionary) {
        let cityPredictions: [[String: Any]] = dict.object(forKey: "predictions") as! [[String: Any]]
        
        if (cityPredictions.count > 0) {
            let cities = cityPredictions.map { (prediction: [String: Any]) -> String in
                return prediction["description"]! as! String
            }
            
            filteredTableData = cities
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
