//
//  CityCollectionViewCell.swift
//  WeatherApp
//
//  Created by keith martin on 6/8/17.
//  Copyright © 2017 keithmartin. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    private let titleLabel: UILabel
    private let temperatureLabel: UILabel
    private let weatherImage: UIImageView
    private let cellView: UIView
    private let loadingSpinner: LoadingSpinner
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        titleLabel = UILabel(frame: .zero)
        temperatureLabel = UILabel(frame: .zero)
        weatherImage = UIImageView(frame: .zero)
        cellView = UIView(frame: .zero)
        loadingSpinner = LoadingSpinner(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(cellView)
        cellView.addSubview(titleLabel)
        cellView.addSubview(temperatureLabel)
        cellView.addSubview(weatherImage)
        cellView.addSubview(loadingSpinner)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createUI() {
        cellView.layer.cornerRadius = 5
        cellView.backgroundColor = UIColor.clear

        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.textColor = UIColor.white
        titleLabel.text = "--"
        
        temperatureLabel.backgroundColor = UIColor.clear
        temperatureLabel.font = UIFont.boldSystemFont(ofSize: 40)
        temperatureLabel.textColor = UIColor.white
        temperatureLabel.text = "70ºF"
        
        loadingSpinner.isHidden = true
        
        self.addConstraints()
    }
    
    func addConstraints() {
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -20).isActive = true
        cellView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20).isActive = true
        cellView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        cellView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -20).isActive = true
        
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true
        temperatureLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 20).isActive = true
        
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        weatherImage.heightAnchor.constraint(equalTo: cellView.heightAnchor, constant: -20).isActive = true
        weatherImage.widthAnchor.constraint(equalToConstant: contentView.frame.width/3).isActive = true
        weatherImage.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -10).isActive = true
        weatherImage.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        loadingSpinner.heightAnchor.constraint(equalToConstant: contentView.frame.height/3).isActive = true
        loadingSpinner.widthAnchor.constraint(equalToConstant: contentView.frame.height/3).isActive = true
        loadingSpinner.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -10).isActive = true
        loadingSpinner.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 10).isActive = true
    }
    
    func setTitleLabel(title: String) {
        titleLabel.text = title
    }
    
    func setTemperatureLabel(temp: String) {
        temperatureLabel.text = temp
    }
    
    func setWeatherImage(condition: Condition) {
        switch condition {
        case .thunderstorm:
            weatherImage.image = UIImage(named: "bolt")
        case .rain:
            weatherImage.image = UIImage(named: "rain")
        case .snow:
            weatherImage.image = UIImage(named: "snow")
        case .atmosphere:
            weatherImage.image = UIImage(named: "wind")
        case .clear:
            weatherImage.image = UIImage(named: "sun")
        case .clouds:
            weatherImage.image = UIImage(named: "cloud")
        }
    }
    
    func getCellColor() -> UIColor {
        return cellView.backgroundColor!
    }
    
    func startLoadingSpinner() {
        loadingSpinner.isHidden = false
        loadingSpinner.startAnimating()
    }
    
    func stopLoadingSpinner() {
        loadingSpinner.stopAnimating()
        loadingSpinner.isHidden = true
    }
    
    func setBackgroundColor(color: UIColor) {
        cellView.backgroundColor = color
    }
    
}
