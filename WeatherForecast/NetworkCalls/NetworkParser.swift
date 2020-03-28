//
//  NetworkParser.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 25/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import Foundation
import Alamofire

class NetworkParser: NSObject {
    
    var weatherDatas = [WeatherModel]()
    
    init(_ json: Parameters ) throws {
        
        if let list = json["list"] as? [Parameters] {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: list, options: [])
                if let resultModel = try? JSONDecoder().decode([WeatherModel].self, from: jsonData) {
                    self.weatherDatas = resultModel
                }
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        } else {
            throw NetworkError.emptyResponse
        }
    }
}
extension NetworkParser: Parser {
    static func parse(_ json: Parameters) -> ResponseState {
        do {
            return .success(try NetworkParser(json))
        } catch let error {
            return .failure(.otherError(error: error.localizedDescription))
        }
    }
}
