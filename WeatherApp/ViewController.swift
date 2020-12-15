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
    var forecast: LocationModel?
    
    let date = Date()
    let calendar = Calendar.current
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadAnimations()
        //ForecastService.shared.getCurrentLocation()
        updateWeatherView()
        
        
    }
    
    func updateWeather(forecastmodel: LocationModel) {
        self.forecast = forecastmodel
        ForecastService.shared.setLatitude(forecastmodel.lat!)
        ForecastService.shared.setLongitude(forecastmodel.lon!)
        ForecastService.shared.getWeather(onSuccess: { (result) in
            //self.weatherResult = result
            self.forecast?.latestForecast = result
            
        }) { (errorMessage) in
            debugPrint("Error occured fetching new weather ->\(errorMessage)")
        }
    }
    
    func updateWeatherView() {
        guard let forecast = forecast else {
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
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
            self.StackViewConstraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        },completion: nil)
    }

}

