//
//  DataContainerSingleTon.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 25/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import Foundation
typealias CompletionHandler =  ( (Bool) -> ())

class DataContainerSingleTon {
    
    // MARK: - Properties
    var cityNames = Set<CityName>()
    var useStubData = false

    static let shared = DataContainerSingleTon()
    
    private  init() { }
    
    func loadLocalCityNames(completion: @escaping CompletionHandler) {
        guard let localData = Utility.getLocalData(of: "CityList", type: "json").data else { return }
        DispatchQueue.global().async {
            if let cityNamesArray = try? JSONDecoder().decode([CityName].self, from: localData) {
                self.cityNames = Set(cityNamesArray)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
}
