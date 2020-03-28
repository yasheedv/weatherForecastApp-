//
//  CityNameCellViewModel.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 26/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import Foundation

class CityNameCellViewModel {
    
    var weatherModel: WeatherModel
    
    init(_ weatherModel: WeatherModel) {
        self.weatherModel = weatherModel
    }
    
    func name() -> String? {
        return weatherModel.name
    }
}
