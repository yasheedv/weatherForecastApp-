//
//  URLBuildable.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 25/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import Alamofire

protocol URLBuildable: URLRequestConvertible {
    // HTTPMethod default is post
    var httpMethod: HTTPMethod {get}
    //API path for the request
    var path: String? {get}
    //Parameters
    var parameters: Parameters? {get}
    //Accept type in header
    var acceptType: ContentType {get}
}

extension URLBuildable {
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        var urlCopy = URLDetails.baseUrl.rawValue
        if let pathCopy = path {
            urlCopy += pathCopy
        }
        let url = try urlCopy.asURL()
        var urlRequest = URLRequest(url: url)
        // HTTP Method
        urlRequest.httpMethod = httpMethod.rawValue
        // Common Headers
        urlRequest.addValue(acceptType.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.addValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        if let params = parameters {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        }
        return urlRequest
    }
}
