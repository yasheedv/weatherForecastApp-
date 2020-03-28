//
//  Protocols.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 25/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import Foundation

protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}

//MARK: - SearchResultControllerDelegate
/// Used to pass data from SearchResultUpdationViewController to WeatherForecastViewController
protocol CityNameSelectionViewControllerDelegate {
    func cityNameSelected(_ cityName: CityName)
}
