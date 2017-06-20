//
//  DetailWeatherView.swift
//  WeatherApp
//
//  Created by keith martin on 6/10/17.
//  Copyright © 2017 keithmartin. All rights reserved.
//

import Foundation
import UIKit

class DetailWeatherView: UIView {
    
    private let closeButton: UIButton
    private let cityLabel: UILabel
    private let windSpeedIconImageView: UIImageView
    private let windSpeedLabel: UILabel
    private let descriptionLabel: UILabel
    private let weatherImageView: UIImageView
    private let temperatureLabel: UILabel
    
    override init(frame: CGRect) {
        closeButton = UIButton(frame: .zero)
        cityLabel = UILabel(frame: .zero)
        windSpeedIconImageView = UIImageView(frame: .zero)
        windSpeedLabel = UILabel(frame: .zero)
        descriptionLabel = UILabel(frame: .zero)
        weatherImageView = UIImageView(frame: .zero)
        temperatureLabel = UILabel(frame: .zero)
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.addSubview(closeButton)
        self.addSubview(cityLabel)
        self.addSubview(windSpeedIconImageView)
        self.addSubview(windSpeedLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(weatherImageView)
        self.addSubview(temperatureLabel)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func createUI() {
        closeButton.backgroundColor = UIColor.clear
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        
        cityLabel.backgroundColor = UIColor.clear
        cityLabel.font = UIFont.boldSystemFont(ofSize: 30)
        cityLabel.textColor = UIColor.titleColor()
        cityLabel.text = "--"
        
        windSpeedIconImageView.image = UIImage(named: "wind_black")
        
        windSpeedLabel.backgroundColor = UIColor.clear
        windSpeedLabel.font = UIFont.boldSystemFont(ofSize: 18)
        windSpeedLabel.textColor = UIColor.titleColor()
        windSpeedLabel.text = "--mph"
        
        descriptionLabel.backgroundColor = UIColor.clear
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 18)
        descriptionLabel.textColor = UIColor.titleColor()
        descriptionLabel.text = "--"
        
        temperatureLabel.backgroundColor = UIColor.clear
        temperatureLabel.font = UIFont.boldSystemFont(ofSize: 140)
        temperatureLabel.adjustsFontSizeToFitWidth = true
        temperatureLabel.numberOfLines = 0
        temperatureLabel.textColor = UIColor.titleColor()
        temperatureLabel.text = "--ºF"
        
        self.addConstraints()
    }
    
    func addConstraints() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        closeButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 2).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        cityLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        windSpeedIconImageView.translatesAutoresizingMaskIntoConstraints = false
        windSpeedIconImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        windSpeedIconImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        windSpeedIconImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        windSpeedIconImageView.topAnchor.constraint(equalTo: cityLabel.topAnchor, constant: 50).isActive = true
        
        windSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        windSpeedLabel.leftAnchor.constraint(equalTo: windSpeedIconImageView.rightAnchor, constant: 2).isActive = true
        windSpeedLabel.centerYAnchor.constraint(equalTo: windSpeedIconImageView.centerYAnchor).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        descriptionLabel.centerYAnchor.constraint(equalTo: windSpeedLabel.centerYAnchor).isActive = true
        
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        weatherImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        weatherImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        weatherImageView.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor).isActive = true
        
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        temperatureLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func getCloseButton() -> UIButton {
        return closeButton
    }
    
    func setCityLabel(text: String) {
        cityLabel.text = text
    }
    
    func setWindSpeedLabel(text: String) {
        windSpeedLabel.text = text
    }
    
    func setDescriptionLabel(text: String) {
        descriptionLabel.text = text
    }
    
    func setTemperatureLabel(text: String) {
        temperatureLabel.text = text
    }
    
}
