//
//  NetworkConstants.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 25/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//


enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case acceptType = "Accept"
}

enum ContentType: String {
    case json        = "application/json"
}

enum NetworkError: Error {
    case invalidResponse
    case otherError(error: String)
    case emptyResponse
    
    var description: String {
        switch self {
        case .invalidResponse:
            return "Invalid Response"
        case .otherError(let error):
            return error
        case .emptyResponse:
            return "Could'nt find any data"
        }
    }
}
