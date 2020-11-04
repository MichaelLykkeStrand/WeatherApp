//
//  ViewController.swift
//  WeatherApp
//
//  Created by Michael Strand on 23/10/2020.
//  Copyright © 2020 Michael Strand. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var weatherResult: Forecast?
    
    @IBOutlet weak var DailySymbolLabel: UILabel!
    @IBOutlet weak var DailyTempLabel: UILabel!
    @IBOutlet weak var DailySunsetLabel: UILabel!
    @IBOutlet weak var DailyCityLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeather()
    }
    
    func getWeather() {
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
        
        self.DailyTempLabel.text = "\(weatherResult.current.temp)°C"
        self.DailySunsetLabel.text = "\(weatherResult.daily[1].humidity)%"
        
        print(weatherResult.current.clouds)
        if(weatherResult.current.clouds > 50){
            self.DailySymbolLabel.text = "☁"
        } else {
            self.DailySymbolLabel.text = "☀"
        }
    }


}

