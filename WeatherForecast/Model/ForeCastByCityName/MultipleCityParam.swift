//
//  MultipleCityParam.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 25/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import Foundation
import Alamofire

struct MultipleCityParam {
    var cityNames: [CityName]
}

// MARK: - URLBuildable
extension MultipleCityParam: URLBuildable {
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var path: String? {
        return preparePath()
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    var acceptType: ContentType {
        return .json
    }
    
    private func preparePath() -> String {
        return "/data/2.5/group?id=\(getCityIDs())&units=metric&appid=\(Keys.mapAppID.rawValue)"
    }
    
    private func getCityIDs() -> String {
        var cityIds = ""
        cityNames.forEach { (cityName) in
            cityIds += "\(cityName.id),"
        }
        cityIds.removeLast()
        return cityIds
    }
    
}
