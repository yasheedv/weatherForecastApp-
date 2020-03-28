//
//  CurrentLocationViewModel.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 27/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import Foundation

class CurrentLocationViewModel {
    // MARK: - Properties
    var dataSource: [WeatherModel] = [] {
        didSet {
            updateUI?()
        }
    }
    // Closures to update UI
    var updateUI: (EmptyCompletionBlock)?
    var showError: (CompletionBlockWithText)?
    
    /// Passing the proper WeatherCellViewModel to tableView
    func cellViewModel(for indexPath: IndexPath) -> WeatherCellViewModel {
        let currentWeather = dataSource[indexPath.row]
        let cellViewModel = WeatherCellViewModel(currentWeather)
        return cellViewModel
    }
}
// MARK: - Network Call
extension CurrentLocationViewModel {
    func userLocationRecieved(_ latitude: String, longitude: String) {
        let currentLocationParam = CurrentLocationWeatherParam(latitude: latitude,
                                                               longitude: longitude)
        let networkCall = NetworkCalls()
        networkCall.getWeatherForCurrentLocation(currentLocationParam) { [weak self] (response) in
            switch response {
            case .success(let parser as NetworkParser):
                if parser.weatherDatas.isEmpty {
                    self?.showError?("Unable to find any data")
                } else {
                    self?.dataSource = parser.weatherDatas
                }
            case .failure(let error):
                self?.showError?(error.description)
            default:
                break
            }
        }
    }
}
