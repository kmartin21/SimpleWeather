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

        tableView.delegate = nil
        tableView.dataSource = nil
        
        setupBindings()
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
    
    func setupBindings() {
        
        tableView.rx.modelSelected(String.self)
            .subscribe(onNext: { [weak self] cityName in
                guard let strongSelf = self else { return }
                strongSelf.selectedCity.onNext(cityName)
            }).addDisposableTo(disposeBag)

        let searchBarText = resultSearchController.searchBar
            .rx.text
            .orEmpty
            .debounce(0.2, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
        
        var searchLocationViewModel = SearchLocationViewModel(observableCityName: searchBarText)
        searchLocationViewModel
            .cityNames
            .drive(tableView.rx.items) { (tableView, row, city) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: IndexPath(row: row, section: 0))
                cell.textLabel?.text = city
                
                return cell
            }.addDisposableTo(disposeBag)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
