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
    
    @IBOutlet weak var DailyTempLabel: UILabel!
    @IBOutlet weak var DailySunsetLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeather()
        
        let weather01 = Weather(id: 1, main: "main", description: "description", icon: "icon")
        let currentForecast = CurrentForecast(dt: 1, sunrise: 1, sunset: 1, temp: 1, feels_like: 1, pressure: 1, humidity: 1, dew_point: 1, uvi: 1, clouds: 1, wind_speed: 1, wind_deg: 1, weather: [weather01])
        let hourlyForecast = HourlyForecast(dt: 1, temp: 1, feels_like: 1, pressure: 1, humidity: 1, dew_point: 1, clouds: 1, wind_speed: 1, wind_deg: 1, weather: [weather01])
        let temperature = Temperature(day: 1, min: 1, max: 1, night: 1, eve: 1, morn: 1)
        let feelsLike = FeelsLike(day: 1, night: 1, eve: 1, morn: 1)
        let dailyForecast = DailyForecast(dt: 1, sunrise: 1, sunset: 1, temp: temperature, feels_like: feelsLike, pressure: 1, humidity: 1, dew_point: 1, uvi: 1, clouds: 1, wind_speed: 1, wind_deg: 1, weather:[weather01])
        let forecast01 = Forecast(lat: 1, lon: 1, timezone: "timezone01", current: currentForecast, hourly: [hourlyForecast], daily: [dailyForecast])
        let forecast02 = Forecast(lat: 2, lon: 2, timezone: "timezone02", current: currentForecast, hourly: [hourlyForecast], daily: [dailyForecast])
        var forecasts : [Forecast]? = [forecast01, forecast02]

        if let url = forecastArrayToJSON(Forecasts: forecasts!){
            print(forecasts)
            print(" ")
            print(" ")
            print(" ")
            print(" ")
            forecasts = []
            forecasts = JSONToForecastArray(URL: url)
            print(forecasts)
        }
        
        
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
        
        self.DailyTempLabel.text = "\(weatherResult.daily[1].temp.day.rounded())°C"
        self.DailySunsetLabel.text = "\(weatherResult.daily[1].humidity)%"
    }


}

