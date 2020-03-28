//
//  Constants.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 25/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import Foundation

enum URLDetails: String {
    case baseUrl = "https://api.openweathermap.org/"
}

enum Keys: String {
    case mapAppID = "0291b96aca2ba85e74dfd878e81ba44c"
}

enum Section {
    case weather, search
}

enum DateFormats: String {
    case ee = "EE"
    case h_mm_a = "h:mm a"
    case dd = "dd"
}

enum SegueIdentifier: String {
    case cityNameSelectionViewController = "CityNameSelectionViewController"
}
