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
    @IBOutlet weak var HourTwoTempLabel: UILabel!
    @IBOutlet weak var HourThreeTempLabel: UILabel!
    @IBOutlet weak var TimeOneLabel: UILabel!
    @IBOutlet weak var TimeTwoLabel: UILabel!
    @IBOutlet weak var TimeThreeLabel: UILabel!
    @IBOutlet weak var DailyFeelsLikeLabel: UILabel!
    
    var weatherResult: Forecast?
    var location: LocationModel?
    var didAnimations = false

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
            //Create alert if unable to load data
            let alert = UIAlertController(title: "Weather servers unavailable", message: "Using cached data from \(self.location!.latestForecast?.current.dt ?? 0)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func updateWeatherView() {
        guard let forecast = self.location else {
            return
        }
        self.CityNameLabel?.text = "\(forecast.name ?? "Name unavailable")"
        self.DailyTempLabel?.text = "\((forecast.latestForecast?.current.temp ?? -9999))°C"
        self.DailyHumidityLabel?.text = "\(forecast.latestForecast?.daily[0].humidity ?? -1)%"
        
        self.DailyFeelsLikeLabel?.text = "Feels like \(forecast.latestForecast?.current.feels_like ?? -9999)°C"
        
        var date = Date()
        
        date = calendar.date(byAdding: .hour, value: 3, to: date)!
        let hour = calendar.component(.hour, from: date)
        TimeOneLabel.text = "\(hour):00"
        date = calendar.date(byAdding: .hour, value: 3, to: date)!
        let hour2 = calendar.component(.hour, from: date)
        TimeTwoLabel.text = "\(hour2):00"
        date = calendar.date(byAdding: .hour, value: 3, to: date)!
        let hour3 = calendar.component(.hour, from: date)
        TimeThreeLabel.text = "\(hour3):00"
        
        print("Hour: \(hour)")
        self.HourOneTempLabel?.text = "\(forecast.latestForecast?.hourly[3].temp ?? -9999)°C"
        self.HourTwoTempLabel?.text = "\(forecast.latestForecast?.hourly[6].temp ?? -9999)°C"
        self.HourThreeTempLabel?.text = "\(forecast.latestForecast?.hourly[9].temp ?? -9999)°C"
        
        if((forecast.latestForecast?.current.clouds) ?? 0 > 50){
            self.DailySymbolLabel?.text = "☁"
        } else {
            self.DailySymbolLabel?.text = "☀"
        }
    }
    
    @IBOutlet weak var StackViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var ContentViewConstraint: NSLayoutConstraint!
    func viewDidLoadAnimations(){
        self.StackViewConstraint.constant -= self.view.bounds.width*2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !didAnimations {
            UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
                self.StackViewConstraint.constant += self.view.bounds.width*2
                self.view.layoutIfNeeded()
            },completion: { _ in
                self.didAnimations = true
            })
        }

    }

}

