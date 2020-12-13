//
//  ViewController.swift
//  WeatherApp
//
//  Created by Michael Strand on 23/10/2020.
//  Copyright © 2020 Michael Strand. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    var weatherResult: Forecast?
    let locationManager = ForecastService.shared.locationManager
    
    @IBOutlet weak var CityNameLabel: UILabel!
    @IBOutlet weak var DailyTempLabel: UILabel!
    @IBOutlet weak var DailySymbolLabel: UILabel!
    @IBOutlet weak var DailyHumidityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidLoadAnimations()
        
        //getWeather()
        let weather01 = Weather(id: 1, main: "main", description: "description", icon: "icon")
        let currentForecast = CurrentForecast(dt: 1, sunrise: 1, sunset: 1, temp: 1, feels_like: 1, pressure: 1, humidity: 1, dew_point: 1, uvi: 1, clouds: 1, wind_speed: 1, wind_deg: 1, weather: [weather01])
        let hourlyForecast = HourlyForecast(dt: 1, temp: 1, feels_like: 1, pressure: 1, humidity: 1, dew_point: 1, clouds: 1, wind_speed: 1, wind_deg: 1, weather: [weather01])
        let temperature = Temperature(day: 1, min: 1, max: 1, night: 1, eve: 1, morn: 1)
        let feelsLike = FeelsLike(day: 1, night: 1, eve: 1, morn: 1)
        let dailyForecast = DailyForecast(dt: 1, sunrise: 1, sunset: 1, temp: temperature, feels_like: feelsLike, pressure: 1, humidity: 1, dew_point: 1, uvi: 1, clouds: 1, wind_speed: 1, wind_deg: 1, weather:[weather01])
        let forecast01 = Forecast(lat: 1, lon: 1, timezone: "timezone01", current: currentForecast, hourly: [hourlyForecast], daily: [dailyForecast])
        let forecast02 = Forecast(lat: 2, lon: 2, timezone: "timezone02", current: currentForecast, hourly: [hourlyForecast], daily: [dailyForecast])
        let forecasts : [Forecast]? = [forecast01, forecast02]

        if let url = forecastArrayToJSON(Forecasts: forecasts!){
            print(" ")
            print(" ")
            print(" ")
            print(" ")
            let forecasts01 = JSONToForecastArray(URL: url)
            print(forecasts01 == forecasts!)
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
        
        self.DailyTempLabel.text = "\(weatherResult.current.temp)°C"
        self.DailyHumidityLabel.text = "\(weatherResult.daily[1].humidity)%"
        
        print(weatherResult.current.clouds)
        if(weatherResult.current.clouds > 50){
            self.DailySymbolLabel.text = "☁"
        } else {
            self.DailySymbolLabel.text = "☀"
        }
    }
    
    @IBOutlet weak var StackViewConstraint: NSLayoutConstraint!
    
    func viewDidLoadAnimations(){
        self.StackViewConstraint.constant -= self.view.bounds.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        askForLocationPermission()
        if CLLocationManager.locationServicesEnabled() {
            if (CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse){
                getCurrentLocation()
            }
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
            self.StackViewConstraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        },completion: nil)
    }
    
    func askForLocationPermission(){
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation(){
        locationManager?.delegate = self
        locationManager?.requestLocation()
        _ = locationManager?.location
        print("locations = \(String(describing: locationManager?.location?.coordinate.latitude)) \(String(describing: locationManager?.location?.coordinate.longitude))")
        //print(location!)
        //ForecastService.shared.buildURL(latitude: <#T##String#>, longtitude: <#T##String#>)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager?.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
            break
        case .authorizedAlways:
            locationManager?.startUpdatingLocation()
            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }
    }
}

