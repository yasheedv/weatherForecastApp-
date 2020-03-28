//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 26/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import Foundation

typealias EmptyCompletionBlock = () -> Void
typealias CompletionBlockWithText = (String) -> Void

class WeatherViewModel {
    // MARK: - Properties
    var dataSource: [WeatherModel] = [] {
        didSet {
            updateUI?()
        }
    }
    private var userSelectedCityNames: [CityName] = []
    private var indexToUpdate: Int?
    var cityNameViewModel: CityNameViewModel?
    
    // Closures to update UI
    var updateUI: (EmptyCompletionBlock)?
    var addToken: (CompletionBlockWithText)?
    var showError: (CompletionBlockWithText)?
    var showCitySelectionScreen: (EmptyCompletionBlock)?
    
    /// Passing the proper WeatherCellViewModel to tableView
    func cellViewModel(for indexPath: IndexPath) -> WeatherCellViewModel {
        let currentWeather = dataSource[indexPath.row]
        let cellViewModel = WeatherCellViewModel(currentWeather)
        return cellViewModel
    }
    
}

// MARK: - Handle Search bar
extension WeatherViewModel {
    /// Checks user typed comma
    func updateSearchResults(_ text: String?) {
        if let text = text, text.count > 1 {
            if text.contains(",") {
                let commaSeperated = text.components(separatedBy: ",")
                guard let userTypedCityName = commaSeperated.first else {
                    return
                }
                addToken?(userTypedCityName)
            }
        }
    }
    /// Checks the last text when pressing search button
    func checkForLastText(_ text: String?) {
        if let text = text, text.count > 1 {
            addToken?(text)
        }
    }
    
    /// Validating the cities
    func searchBarSearchButtonClicked(with cityNames: [String]) {
        if cityNames.count < 3 {
            showError?("You should add atleast 3 City Names")
        } else if cityNames.count > 7 {
            showError?("You can only add maximum 7 City names")
        } else {
            
            userSelectedCityNames = cityNames.map( { CityName(id: 0, name: $0, country: "", coord: Coord(lon: 0, lat: 0)) })
            checkCityNames()
        }
    }
    
    private func checkCityNames() {
        let cityNamesCopy = userSelectedCityNames
        var allValidCityNames = true
        for (index, cityName) in cityNamesCopy.enumerated() {
            if cityName.id == 0 {
                let cityModels = DataContainerSingleTon.shared.cityNames.filter({$0.contains(query: cityName.name )})
                if cityModels.isEmpty {
                    /// Couldnt find a city name in openweathermap
                    allValidCityNames = false
                    showError?("Unable to find a city named \(cityName.name)")
                    break
                } else if cityModels.count > 1 {
                    
                    /// More city names available for the given keyword
                    
                    indexToUpdate = index
                    allValidCityNames = false
                    let searchViewModel = CityNameViewModel(Array(cityModels), cityName.name)
                    cityNameViewModel = searchViewModel
                    showCitySelectionScreen?()
                    break
                } else if let firstModel = cityModels.first {
                    userSelectedCityNames[index] = firstModel
                }
            }
        }
        if allValidCityNames {
            getWeatherData()
        }
    }
}

// MARK: - CityNameSelectionViewControllerDelegate
extension WeatherViewModel: CityNameSelectionViewControllerDelegate {
    func cityNameSelected(_ cityName: CityName) {
        guard let index = indexToUpdate else {
            return
        }
        userSelectedCityNames[index] = cityName
        checkCityNames()
    }
}

// MARK: - Webserive call
extension WeatherViewModel {
    func getWeatherData() {
        let networkCall = NetworkCalls()
        let multipleCityParam = MultipleCityParam(cityNames: userSelectedCityNames)
        networkCall.getWeatherForMultipleCities(multipleCityParam) { [weak self] (response) in
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
