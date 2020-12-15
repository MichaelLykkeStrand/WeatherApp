//
//  LoadSaveForcastService.swift
//  WeatherApp
//
//  Created by Richard Nemčovič on 03/11/2020.
//  Copyright © 2020 Michael Strand. All rights reserved.
//

import Foundation

class StorageService {
    static let json = StorageService()
    var storageurl = URL(string: "")
    
    init() {
        do{
            let url : URL = try FileManager.default.url(
            for : FileManager.SearchPathDirectory.applicationSupportDirectory,
            in : .userDomainMask,
            appropriateFor: nil,
            create: true)
            storageurl = url
        } catch {
            print(error)
        }
    }
    
    
    func forecastArrayToJSON(Forecasts forecasts: Array<LocationModel>, Filename filename: String) -> Void{
        do {
            let jsonData = try JSONEncoder().encode(forecasts)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            guard let url = storageurl else {
                return
            }
            do{
                let pathWithFileName = url.appendingPathComponent(filename)
                do {
                    try jsonString.write(to: pathWithFileName, atomically: true, encoding: .utf8)
                    return
                } catch { print(error) }
            } catch { print(error) }
        } catch { print(error) }
        return
    }

    func JSONToForecastArray(Filename filename: String) -> [LocationModel]?{
        do {
            guard let pathWithFileName = self.storageurl?.appendingPathComponent(filename) else { return nil }
            let jsonData = try Data(contentsOf:pathWithFileName, options: [.alwaysMapped , .uncached ] )
            let decodedForecasts = try JSONDecoder().decode([LocationModel].self, from: jsonData)
            //print(decodedForecasts)
            return (decodedForecasts)
        } catch { print(error) }
        return nil
    }

}

