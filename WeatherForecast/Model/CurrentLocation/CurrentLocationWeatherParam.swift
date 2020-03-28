//
//  CurrentLocationWeatherParam.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 27/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import Foundation
import Alamofire

struct CurrentLocationWeatherParam {
    var latitude: String
    var longitude: String
}

// MARK: - URLBuildable
extension CurrentLocationWeatherParam: URLBuildable {
    
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
        return "/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(Keys.mapAppID.rawValue)"
    }
}
