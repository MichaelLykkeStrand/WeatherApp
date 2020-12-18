//
//  FeelsLike.swift
//  WeatherApp
//
//  Created by Richard Nemčovič on 18/12/2020.
//  Copyright © 2020 Michael Strand. All rights reserved.
//

import Foundation

struct FeelsLike: Codable, Equatable {
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
}
