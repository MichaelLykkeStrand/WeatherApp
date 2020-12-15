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
    
    @IBOutlet weak var CityNameLabel: UILabel!
    @IBOutlet weak var DailyTempLabel: UILabel!
    @IBOutlet weak var DailySymbolLabel: UILabel!
    @IBOutlet weak var DailyHumidityLabel: UILabel!
    @IBOutlet weak var HourOneTempLabel: UILabel!
    
    
    var weatherResult: Forecast?
    var location: LocationModel?
    var didAnimations = false
    
    let date = Date()
    let calendar = Calendar.current
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadAnimations()
        
        
    }
    
    func updateWeather(forecastmodel: LocationModel) {
        self.location = forecastmodel
        //ForecastService.shared.setLatitude(forecastmodel.lat!)
        //ForecastService.shared.setLongitude(forecastmodel.lon!)
        ForecastService.shared.getWeather(Latitude: String(forecastmodel.lat!), Longitude: String(forecastmodel.lon!), onSuccess: { (result) in
            //self.weatherResult = result
            self.location?.latestForecast = result
            self.updateWeatherView()
        }) { (errorMessage) in
            debugPrint("Error occured fetching new weather ->\(errorMessage)")
        }
    }
    
    func updateWeatherView() {
        guard let forecast = self.location else {
            return
        }
        self.CityNameLabel?.text = "\(forecast.name ?? "Name unavailable")"
        self.DailyTempLabel?.text = "\((forecast.latestForecast?.current.temp ?? -9999))°C"
        self.DailyHumidityLabel?.text = "\(forecast.latestForecast?.daily[0].humidity ?? -1)%"
        
        let hour = calendar.component(.hour, from: date)
        print("Hour: \(hour)")
        self.HourOneTempLabel?.text = "\(forecast.latestForecast?.hourly[3].temp ?? -9999)°C"
        
        if((forecast.latestForecast?.current.clouds) ?? 0 > 50){
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
        if !didAnimations {
            UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
                self.StackViewConstraint.constant += self.view.bounds.width
                self.view.layoutIfNeeded()
            },completion: { _ in
                self.didAnimations = true
            })
        }

    }

}

