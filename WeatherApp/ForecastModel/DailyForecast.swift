//
//  DailyForecast.swift
//  WeatherApp
//
//  Created by Richard Nemčovič on 18/12/2020.
//  Copyright © 2020 Michael Strand. All rights reserved.
//

import Foundation

struct DailyForecast: Codable, Equatable {
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
