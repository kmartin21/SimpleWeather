//
//  ViewController.swift
//  WeatherApp
//
//  Created by keith martin on 6/7/17.
//  Copyright © 2017 keithmartin. All rights reserved.
//

import UIKit

class WeatherLocationsViewController: UIViewController, CityWeatherDelegate {

    private let locationsLabel = UILabel(frame: .zero)
    private let addLocationButton = UIButton(frame: .zero)
    private var tableView: UITableView!
    fileprivate var citiesDataSource: [CityWeather] = []
    private let httpCityWeather: HttpCityWeather
    fileprivate var loadingAll: Bool = false
    
    init() {
        httpCityWeather = HttpCityWeather()
        super.init(nibName: nil, bundle: nil)
        httpCityWeather.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUI()
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
        addLocationButton.addTarget(self, action: #selector(addLocationButtonTapped), for: .touchUpInside)
        view.addSubview(addLocationButton)
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.clear
        self.view.addSubview(tableView)
        
        self.addConstraints()
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
    
    private var rotatedButton: Bool = false
    func addLocationButtonTapped() {
        let locationPickerVC = SearchLocationViewController()
        
        UIView.animate(withDuration: 0.5) { () -> Void in
            self.addLocationButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.addLocationButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2))
        }) { _ in
            DispatchQueue.main.async {
                self.present(locationPickerVC, animated: true, completion: nil)
            }
        }
        
        locationPickerVC.selectedCityCallback = { fullCity in
            let citySplitWord = fullCity.components(separatedBy: ",")
            let city = citySplitWord[0]
            self.citiesDataSource.append(CityWeather())
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
            self.httpCityWeather.getCityWeather(city: "\(city)")
        }
    }
    
    func cityWeatherDidLoad(cityWeather: CityWeather) {
        self.citiesDataSource[citiesDataSource.count-1] = cityWeather
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

//MARK: - TableView Methods

private let cellColors = [UIColor.flatRed(), UIColor.flatOrange(), UIColor.flatGreen(), UIColor.flatBlue()]

extension WeatherLocationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CityTableViewCell
        let cellColor = cellColors[indexPath.row % cellColors.count]
        let cityWeather = citiesDataSource[indexPath.row]
        
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CityTableViewCell
        let cellFrame = tableView.cellForRow(at: indexPath)!.frame
        let relativeY = cellFrame.origin.y - tableView.contentOffset.y
        let startRect = CGRect(x: cellFrame.origin.x, y: relativeY, width: cellFrame.width, height: cellFrame.height)
        let accentColor = cell.getCellColor()
        
        let detailWeatherViewController = DetailWeatherViewController(accentColor: accentColor, viewStartingPoint: startRect, cityWeather: citiesDataSource[indexPath.row], padding: tableView.frame.minY)
        DispatchQueue.main.async {
            self.present(detailWeatherViewController, animated: false, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width / 2.5
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        UIButton.appearance().setTitleColor(UIColor.red, for: UIControlState.normal)
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "✕") { (action, indexPath) in
            self.citiesDataSource.remove(at: indexPath.row)
            DispatchQueue.main.async(execute: {
                tableView.deleteRows(at: [indexPath], with: .fade)
            })
        }

        deleteAction.backgroundColor = UIColor.white
        return [deleteAction]
    }
}

