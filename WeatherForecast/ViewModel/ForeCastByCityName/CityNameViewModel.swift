//
//  SearchViewModel.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 26/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import Foundation

class CityNameViewModel {
    // MARK: - Properties
    var cityNames = [CityName]()
    var delegate: CityNameSelectionViewControllerDelegate?
    var userTypedName: String
    
    init(_ cityNames: [CityName], _ userTypedName: String) {
        self.cityNames = cityNames
        self.userTypedName = userTypedName
    }
    
    func cityName(for indexPath: IndexPath) -> String {
        let model = cityNames[indexPath.row]
        return "\(model.name) \nCountry: \(model.country) \nGeo coords [\(model.coord.lon), \(model.coord.lat)]"
    }
    func cityNameSelected(for indexPath: IndexPath) {
        let model = cityNames[indexPath.row]
        delegate?.cityNameSelected(model)
    }
}
