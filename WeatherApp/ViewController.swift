//
//  ViewController.swift
//  WeatherApp
//
//  Created by Michael Strand on 23/10/2020.
//  Copyright © 2020 Michael Strand. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class ViewController: UIViewController{

    var weatherResult: Forecast?
    
    
    @IBOutlet weak var CityNameLabel: UILabel!
    @IBOutlet weak var DailyTempLabel: UILabel!
    @IBOutlet weak var DailySymbolLabel: UILabel!
    @IBOutlet weak var DailyHumidityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewDidLoadAnimations()

        //ForecastService.shared.getCurrentLocation()
        updateWeatherView()
    }
    
    func updateWeather(name: String, lat: Double, lon: Double) {
        ForecastService.shared.setLatitude(lat)
        ForecastService.shared.setLongitude(lon)
        ForecastService.shared.getWeather(onSuccess: { (result) in
            self.weatherResult = result
            self.updateWeatherView()
            
        }) { (errorMessage) in
            debugPrint(errorMessage)
        }
    }
    
    func updateWeatherView() {
        guard let weatherResult = weatherResult else {
            return
        }
        self.CityNameLabel?.text =
        self.DailyTempLabel?.text = "\(weatherResult.current.temp)°C"
        self.DailyHumidityLabel?.text = "\(weatherResult.daily[1].humidity)%"
        
        print(weatherResult.current.clouds)
        if(weatherResult.current.clouds > 50){
            self.DailySymbolLabel?.text = "☁"
        } else {
            self.DailySymbolLabel?.text = "☀"
        }
    }
    
    @IBOutlet weak var StackViewConstraint: NSLayoutConstraint!
    
    func viewDidLoadAnimations(){
        self.StackViewConstraint.constant -= self.view.bounds.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
            self.StackViewConstraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        },completion: nil)
    }

}

