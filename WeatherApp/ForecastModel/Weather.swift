//
//  Weather.swift
//  WeatherApp
//
//  Created by Richard Nemčovič on 18/12/2020.
//  Copyright © 2020 Michael Strand. All rights reserved.
//

import Foundation

struct Weather: Codable, Equatable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
