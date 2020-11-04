//
//  ForecastModel.swift
//  WeatherApp
//
//  Created by Peder Andreas Hundebøl on 24/10/2020.
//  Copyright © 2020 Michael Strand. All rights reserved.
//

import Foundation

struct Forecast: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let current: CurrentForecast
    var hourly: [HourlyForecast]
    var daily: [DailyForecast]
}

struct Weather: Codable{
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct CurrentForecast: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
    let dew_point: Double
    let uvi: Double
    let clouds: Int
    let wind_speed: Double
    let wind_deg: Int
    let weather: [Weather]
}

struct HourlyForecast: Codable {
    let dt: Int
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
    let dew_point: Double
    let clouds: Int
    let wind_speed: Double
    let wind_deg: Int
    let weather: [Weather]
}

struct DailyForecast: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Temperature
    let feels_like: FeelsLike
    let pressure: Int
    let humidity: Int
    let dew_point: Double
    let uvi: Double
    let clouds: Int
    let wind_speed: Double
    let wind_deg: Int
    let weather: [Weather]
}

struct Temperature: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}

struct FeelsLike: Codable {
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
}

struct ForecastByCity: Codable {
    let coord: Coordinates
}

struct Coordinates: Codable {
    let lat: Double
    let lon: Double
}


