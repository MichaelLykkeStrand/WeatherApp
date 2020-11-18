//
//  ForecastStorageModel.swift
//  WeatherApp
//
//  Created by Peder Andreas Hundebøl on 18/11/2020.
//  Copyright © 2020 Michael Strand. All rights reserved.
//

import Foundation

struct ForecastStorageModel: Codable, Equatable {
    let name: String
    let lat: Double
    let lon: Double
    let latestForecast: Forecast?
}
