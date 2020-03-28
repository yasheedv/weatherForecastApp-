//
//  Weather.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 25/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import Foundation

struct WeatherModel: Codable {
    
    var weather: [Weather]
    var main: Main
    var wind: Wind
    var name: String?
    var unixDate: Int?
    
    private enum CodingKeys: String, CodingKey {
        case unixDate = "dt"
        case weather, main, wind, name
    }
    
}

struct Main: Codable {
    var tempMin: Double
    var tempMax: Double
    var temp: Double
    private enum CodingKeys: String, CodingKey {
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case temp
    }
}

struct Weather: Codable {
    var description, icon: String
}

struct Wind: Codable {
    var speed: Double
}
