//
//  ForecastStorageModel.swift
//  WeatherApp
//
//  Created by Peder Andreas Hundebøl on 14/12/2020.
//  Copyright © 2020 Michael Strand. All rights reserved.
//

import Foundation

struct ForecastStorageModel: Codable, Equatable {
    var name: String?
    var lat: Double?
    var lon: Double?
    var latestForecast: Forecast?
}
