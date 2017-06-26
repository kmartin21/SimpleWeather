//
//  ViewController.swift
//  WeatherApp
//
//  Created by keith martin on 6/7/17.
//  Copyright © 2017 keithmartin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherLocationsViewController: UIViewController, UITableViewDelegate {

    private let locationsLabel = UILabel(frame: .zero)
    private let addLocationButton = UIButton(frame: .zero)
    private var tableView: UITableView!
    private var citiesDataSource: Variable<[CityWeather]> = Variable([])
    private let disposeBag = DisposeBag()
    fileprivate var loadingAll: Bool = false
    private var filePath : String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        return url.appendingPathComponent("cityWeatherData")!.path
    }
    private let cellColors = [UIColor.flatRed(), UIColor.flatOrange(), UIColor.flatGreen(), UIColor.flatBlue()]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createUI()
        setupBindings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createUI() {
        view.backgroundColor = UIColor.white
        
        locationsLabel.backgroundColor = UIColor.clear
        locationsLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        locationsLabel.textColor = UIColor.titleColor()
        locationsLabel.text = "My weather locations"
        view.addSubview(locationsLabel)
        
        addLocationButton.backgroundColor = UIColor.clear
        addLocationButton.setImage(UIImage(named: "plus"), for: .normal)
        view.addSubview(addLocationButton)
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.clear
        self.view.addSubview(tableView)
        self.addConstraints()
    }
    
    func setupBindings() {
        tableView.rx.setDelegate(self)
            .addDisposableTo(disposeBag)
        
        citiesDataSource.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: CityTableViewCell.self)) { [weak self] (row, cityWeather, cell) in
                
                guard let strongSelf = self else { return }
                
                let cellColor = strongSelf.cellColors[row % strongSelf.cellColors.count]
                
                cell.selectionStyle = .none
                cell.setBackgroundColor(color: cellColor)
                cell.setTitleLabel(title: cityWeather.getCity())
                cell.setTemperatureLabel(temp: cityWeather.getTemp())
                cell.setWeatherImage(condition: cityWeather.getCondition())
                
                if cityWeather.isLoading() {
                    cell.startLoadingSpinner()
                } else {
                    cell.stopLoadingSpinner()
                }
            }.addDisposableTo(disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let strongSelf = self else { return }
                
                let cell = strongSelf.tableView.cellForRow(at: indexPath) as! CityTableViewCell
                let cellFrame = strongSelf.tableView.cellForRow(at: indexPath)!.frame
                let relativeY = cellFrame.origin.y - strongSelf.tableView.contentOffset.y
                let startRect = CGRect(x: cellFrame.origin.x, y: relativeY, width: cellFrame.width, height: cellFrame.height)
                let accentColor = cell.getCellColor()
                
                let detailWeatherViewController = DetailWeatherViewController(accentColor: accentColor, viewStartingPoint: startRect, cityWeather: strongSelf.citiesDataSource.value[indexPath.row], padding: strongSelf.tableView.frame.minY)
                DispatchQueue.main.async {
                    strongSelf.present(detailWeatherViewController, animated: false, completion: nil)
                }
            }).addDisposableTo(disposeBag)
        
        tableView.rx.itemDeleted
            .subscribe()
            .addDisposableTo(disposeBag)
        
        addLocationButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let strongSelf = self else { return }
            
            let locationPickerVC = SearchLocationViewController()
            
            locationPickerVC.selectedCity.subscribe(onNext: { fullCity in
                let citySplitWord = fullCity.components(separatedBy: ",")
                let city = citySplitWord[0]
                strongSelf.citiesDataSource.value.append(CityWeather())
                locationPickerVC.dismiss(animated: true, completion: nil)
                locationPickerVC.dismiss(animated: true, completion: nil)
                
                var weatherLocationsViewModel = WeatherLocationsViewModel(observableLatestCityName: Observable.just(city), observableAllCities: nil)
                weatherLocationsViewModel.latestCityWeather
                    .subscribe(onNext: { (cityWeather) in
                        strongSelf.citiesDataSource.value[strongSelf.citiesDataSource.value.count - 1] = cityWeather
                    }).addDisposableTo(strongSelf.disposeBag)
                
            }).addDisposableTo(strongSelf.disposeBag)
            
            UIView.animate(withDuration: 0.5) { () -> Void in
                strongSelf.addLocationButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }
            UIView.animate(withDuration: 0.5, animations: {
                strongSelf.addLocationButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2))
            }) { _ in
                DispatchQueue.main.async {
                    strongSelf.present(locationPickerVC, animated: true, completion: nil)
                }
            }
        }).addDisposableTo(disposeBag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width / 2.5
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        UIButton.appearance().setTitleColor(UIColor.red, for: UIControlState.normal)
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "✕") { (action, indexPath) in
            self.citiesDataSource.value.remove(at: indexPath.row)
        }
        
        deleteAction.backgroundColor = UIColor.white
        return [deleteAction]
    }

    
    func addConstraints() {
        locationsLabel.translatesAutoresizingMaskIntoConstraints = false
        locationsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        locationsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        
        addLocationButton.translatesAutoresizingMaskIntoConstraints = false
        addLocationButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addLocationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addLocationButton.centerYAnchor.constraint(equalTo: locationsLabel.centerYAnchor).isActive = true
        addLocationButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: addLocationButton.bottomAnchor).isActive = true
    }
    
    func saveData() {
        NSKeyedArchiver.archiveRootObject(citiesDataSource.value, toFile: self.filePath)
    }
    
    func loadData() {
        if let cityWeatherData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [CityWeather] {
            self.citiesDataSource.value = cityWeatherData
        }
        refreshData()
    }
    
    func refreshData() {
        var cities: [String] = []
        for cityWeather in citiesDataSource.value {
            cityWeather.setLoading(true)
            cities.append(cityWeather.getCity())
        }
        
        var weatherLocationsViewModel = WeatherLocationsViewModel(observableLatestCityName: nil, observableAllCities: Observable.just(cities))
        
        weatherLocationsViewModel.allCityWeather
            .subscribe(onNext: { [weak self] (allCityWeather) in
                guard let strongSelf = self else { return }
                
                strongSelf.citiesDataSource.value = allCityWeather
            }).addDisposableTo(disposeBag)
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
