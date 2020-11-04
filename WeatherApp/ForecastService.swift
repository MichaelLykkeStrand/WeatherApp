//
//  ForecastService.swift
//  WeatherApp
//
//  Created by Peder Andreas Hundebøl on 26/10/2020.
//  Copyright © 2020 Michael Strand. All rights reserved.
//

import Foundation

class ForecastService {
    static let shared = ForecastService()
    
    let URL_API_KEY = "dfac6d41feb1c2880980e5dd7ac7e159"
    var URL_LATITUDE = "-53.11"
    var URL_LONGITUDE = "73.53"
    var URL_PARAMATER_LIST = ""
    let URL_BASE = "https://api.openweathermap.org/data/2.5/onecall?"
    let session = URLSession(configuration: .default)
    
    func buildURL() -> String {
        URL_PARAMATER_LIST = "lat=" + URL_LATITUDE + "&lon=" + URL_LONGITUDE + "&units=metric" + "&appid=" + URL_API_KEY
        return URL_BASE + URL_PARAMATER_LIST
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
    
    func setLatLonFromCity(city: String) {
        guard let url = URL(string: "api.openweathermap.org/data/2.5/weather?q=London&appid=dfac6d41feb1c2880980e5dd7ac7e159") else {
            debugPrint("Failed to build LatLonUrl")
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
        
            DispatchQueue.main.async {
                
                guard let data = data, let response = response as? HTTPURLResponse else {
                    debugPrint("Invalid data or response")
                    return
                }
                
                do {
                    if response.statusCode == 200 {
                        let items = try JSONDecoder().decode(ForecastByCity.self, from: data)
                        let newLat = items.coord.lat
                        let newLon = items.coord.lon
                        self.setLatitude(newLat)
                        self.setLongitude(newLon)
                    } else {
                        debugPrint("Response wasn't 200. It was: " + "\n\(response.statusCode)")
                    }
                } catch {
                    debugPrint(error.localizedDescription)
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
