//
//  CityName.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 25/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import Foundation


struct CityName: Codable, Hashable {
    var id: Int
    var name, country: String
    var coord: Coord
    func contains(query: String) -> Bool {
        let lowerCasedTrimmedQuery = query.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let lowerCasedTrimmedName = name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        return lowerCasedTrimmedName.contains(lowerCasedTrimmedQuery)
    }
}

struct Coord: Codable, Hashable {
    var lon, lat: Double
}
