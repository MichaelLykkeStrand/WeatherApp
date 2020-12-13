//
//  ForecastService.swift
//  WeatherApp
//
//  Created by Peder Andreas Hundebøl on 26/10/2020.
//  Copyright © 2020 Michael Strand. All rights reserved.
//

import Foundation
import GooglePlaces

class ForecastService {
    static let shared = ForecastService()
    let locationManager : CLLocationManager? = CLLocationManager()

    var URL_LATITUDE = "10"
    var URL_LONGITUDE = "10"
    let URL_API_KEY = "dfac6d41feb1c2880980e5dd7ac7e159"
    var URL_PARAMATER_LIST = ""
    let URL_BASE = "https://api.openweathermap.org/data/2.5/onecall?"
    var URL_WHOLE = ""
    let session = URLSession(configuration: .default)
    
    func buildURL() -> String {
        URL_PARAMATER_LIST = "lat=" + URL_LATITUDE + "&lon=" + URL_LONGITUDE + "&units=metric" + "&appid=" + URL_API_KEY
        return URL_BASE + URL_PARAMATER_LIST
    }
    
    func buildURL(latitude lat : String, longtitude lon : String) -> String {
        self.URL_LATITUDE = lat
        self.URL_LONGITUDE = lon
        self.URL_PARAMATER_LIST = "lat=" + self.URL_LATITUDE + "&lon=" + self.URL_LONGITUDE + "&units=metric" + "&appid=" + self.URL_API_KEY
        self.URL_WHOLE = self.URL_BASE + self.URL_PARAMATER_LIST
        return URL_WHOLE
    }
    
    //TODO - Possibly redo this
    func getWeather(onSuccess: @escaping (Forecast) -> Void, onError: @escaping (String) -> Void) {
        
        guard let url = URL(string: buildURL()) else {
            onError("Error building URL")
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            DispatchQueue.main.async {
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse else {
                    onError("Invalid data or response")
                    return
                }
                
                do {
                    if response.statusCode == 200 {
                        let items = try JSONDecoder().decode(Forecast.self, from: data)
                        onSuccess(items)
                    } else {
                        onError("Response wasn't 200. It was: " + "\n\(response.statusCode)")
                    }
                } catch {
                    onError(error.localizedDescription)
                }
            }
            
        }
        task.resume()
    }
    
    func setLatitude(_ latitude: String) {
        URL_LATITUDE = latitude
    }
    
    func setLatitude(_ latitude: Double) {
        setLatitude(String(latitude))
    }
    
    func setLongitude(_ longitude: String) {
        URL_LONGITUDE = longitude
    }
    
    func setLongitude(_ longitude: Double) {
        setLongitude(String(longitude))
    }
}
