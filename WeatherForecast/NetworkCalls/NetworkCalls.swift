//
//  NetworkCalls.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 25/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import Foundation

class NetworkCalls: NetworkEngine {
    
     func getWeatherForMultipleCities(_ param: MultipleCityParam, completion: @escaping CompletionWithSuccessOrFailure) {
           if DataContainerSingleTon.shared.useStubData{
               guard let localDetails = Utility.getLocalData(of: "WEATHER_FOR_MULTIPLE_CITIES", type: "json").dictionary else { return }
               let parsingStauts = NetworkParser.parse(localDetails)
               switch parsingStauts {
               case .success(let value):
                   completion(.success(value))
               case .failure(let error):
                   completion(.failure(error))
               }
           }else{
               fetch(param, NetworkParser.self, completion)
           }
       }
       
       func getWeatherForCurrentLocation(_ param: CurrentLocationWeatherParam, completion: @escaping CompletionWithSuccessOrFailure) {
           if DataContainerSingleTon.shared.useStubData{
               guard let localDetails = Utility.getLocalData(of: "WEATHER_FOR_CURRENT_LOCATION", type: "json").dictionary else { return }

               let parsingStauts = NetworkParser.parse(localDetails)
               switch parsingStauts {
               case .success(let value):
                   completion(.success(value))
               case .failure(let error):
                   completion(.failure(error))
               }
           }else{
               fetch(param, NetworkParser.self, completion)
           }
       }
}
