//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by keith martin on 6/8/17.
//  Copyright © 2017 keithmartin. All rights reserved.
//

import UIKit

class DetailWeatherViewController: UIViewController {

    private let accentColorView: UIView
    private let viewStartingPoint: CGRect
    private let padding: CGFloat
    private let detailWeatherView: DetailWeatherView
    private let cityWeather: CityWeather
    
    init(accentColor: UIColor, viewStartingPoint: CGRect, cityWeather: CityWeather, padding: CGFloat) {
        accentColorView = UIView(frame: .zero)
        detailWeatherView = DetailWeatherView(frame: .zero)
        self.viewStartingPoint = viewStartingPoint
        self.cityWeather = cityWeather
        self.padding = padding
        super.init(nibName: nil, bundle: nil)
        accentColorView.backgroundColor = accentColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        createAnimatedViewUI()
        createDetailWeatherViewUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateAccentColorView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private var accentWidthConstraint: NSLayoutConstraint!
    private var accentHeightConstraint: NSLayoutConstraint!
    private var accentTopConstraint: NSLayoutConstraint!
    private var accentCenterXConstraint: NSLayoutConstraint!
    
    func createAnimatedViewUI() {
        accentColorView.layer.cornerRadius = 5
        self.view.addSubview(accentColorView)
        self.addAnimatedViewConstraints()
    }
    
    func addAnimatedViewConstraints() {
        accentColorView.translatesAutoresizingMaskIntoConstraints = false
        accentWidthConstraint = accentColorView.widthAnchor.constraint(equalToConstant: viewStartingPoint.width - 20)
        accentHeightConstraint = accentColorView.heightAnchor.constraint(equalToConstant: viewStartingPoint.height - 20)
        accentTopConstraint = accentColorView.topAnchor.constraint(equalTo: view.topAnchor, constant: viewStartingPoint.origin.y + padding)
        accentCenterXConstraint = accentColorView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        NSLayoutConstraint.activate([accentWidthConstraint, accentHeightConstraint, accentTopConstraint, accentCenterXConstraint])
    }
    
    func createDetailWeatherViewUI() {
        self.view.addSubview(detailWeatherView)
        detailWeatherView.getCloseButton().addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        detailWeatherView.setCityLabel(text: cityWeather.getCity())
        detailWeatherView.setWindSpeedLabel(text: cityWeather.getWindSpeed())
        detailWeatherView.setDescriptionLabel(text: cityWeather.getDescription())
        detailWeatherView.setTemperatureLabel(text: cityWeather.getTemp())
        self.addDetailWeatherViewConstraints()
    }
    
    private var detailWeatherLeftConstraint: NSLayoutConstraint!

    func addDetailWeatherViewConstraints() {
        detailWeatherView.translatesAutoresizingMaskIntoConstraints = false
        detailWeatherView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        detailWeatherView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        detailWeatherLeftConstraint = detailWeatherView.leftAnchor.constraint(equalTo: view.rightAnchor)
        NSLayoutConstraint.activate([detailWeatherLeftConstraint])
    }
    
    
    func animateAccentColorView() {
        accentHeightConstraint.constant += (view.frame.height - (viewStartingPoint.height - 20))
        accentTopConstraint.constant -= viewStartingPoint.origin.y + padding
        accentWidthConstraint.constant -= (viewStartingPoint.width - 30)
        accentCenterXConstraint.constant -= view.frame.width/2
        detailWeatherLeftConstraint.constant -= view.frame.width - 5
        accentColorView.layer.cornerRadius = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .allowAnimatedContent, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
