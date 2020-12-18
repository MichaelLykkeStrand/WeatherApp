 //
//  ForecastModel.swift
//  WeatherApp
//
//  Created by Peder Andreas Hundebøl on 24/10/2020.
//  Copyright © 2020 Michael Strand. All rights reserved.
//

import Foundation

struct Forecast: Codable, Equatable {
    let lat: Double
    let lon: Double
    let timezone: String
    let current: CurrentForecast
    var hourly: [HourlyForecast]
    var daily: [DailyForecast]
}
