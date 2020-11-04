//
//  LoadSaveForcastService.swift
//  WeatherApp
//
//  Created by Richard Nemčovič on 03/11/2020.
//  Copyright © 2020 Michael Strand. All rights reserved.
//

import Foundation

func forecastArrayToJSON(Forecasts forecasts: Array<Forecast>) -> URL?{
    do {
        let jsonData = try JSONEncoder().encode(forecasts)
        //print(forecasts)
        let jsonString = String(data: jsonData, encoding: .utf8)!

        //let decodedForecasts = try JSONDecoder().decode([Forecast].self, from: jsonData)
        //print(decodedForecasts)
        do{
            let url : URL = try FileManager.default.url(
            for : FileManager.SearchPathDirectory.applicationSupportDirectory,
            in : .userDomainMask,
            appropriateFor: nil,
            create: true)
            
            let pathWithFileName = url.appendingPathComponent("myJsonString.json")
            do {
                try jsonString.write(to: pathWithFileName, atomically: true, encoding: .utf8)
                return pathWithFileName
            } catch { print(error) }
        } catch { print(error) }
    } catch { print(error) }
    return nil
}

func JSONToForecastArray(URL url: URL) -> [Forecast]?{
    do {
        let jsonData = try Data(contentsOf:url, options: [.alwaysMapped , .uncached ] )
        let decodedForecasts = try JSONDecoder().decode([Forecast].self, from: jsonData)
        //print(decodedForecasts)
        return (decodedForecasts)
    } catch { print(error) }
    return nil
}









/*
struct Sentence : Codable {
    let sentence : String
    let lang : String
}

let sentences = [Sentence(sentence: "Hello world", lang: "en"),
                 Sentence(sentence: "Hallo Welt", lang: "de")]

do {
    let jsonData = try JSONEncoder().encode(sentences)
    let jsonString = String(data: jsonData, encoding: .utf8)!
    print(jsonString) // [{"sentence":"Hello world","lang":"en"},{"sentence":"Hallo Welt","lang":"de"}]

    // and decode it back
    let decodedSentences = try JSONDecoder().decode([Sentence].self, from: jsonData)
    print(decodedSentences)
} catch { print(error) }
 */
