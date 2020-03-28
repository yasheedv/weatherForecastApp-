//
//  Parser.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 25/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import Alamofire

/*
 protocol Parser is used to send the json value to the Classes for parsing the json
 */

protocol Parser {
    static func parse(_ json: Parameters) -> ResponseState
}
