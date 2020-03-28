//
//  WeatherCellViewModel.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 26/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import Foundation

class WeatherCellViewModel {
    // MARK: - Properties
    var weatherModel: WeatherModel!
    var internalDataSoruce: [DetailsListModel] = []
    
    init(_ model: WeatherModel) {
        weatherModel = model
        let wind = "Wind Speed: \(model.wind.speed) meter/sec"
        internalDataSoruce.append(DetailsListModel(title: wind, image: nil))
        let weather = model.weather.map({ DetailsListModel(title: $0.description , image: $0.icon) })
        internalDataSoruce.append(contentsOf: weather)
    }
    
    func viewModel(for indexPath: IndexPath) -> DetailCellViewModel {
        let model = internalDataSoruce[indexPath.row]
        let viewModel = DetailCellViewModel(model)
        return viewModel
    }
}
// MARK: - Value making for display
extension WeatherCellViewModel {
    func tempMax() -> String {
        return "Temp Max: \(weatherModel.main.tempMax)"
    }
    func tempMin() -> String {
        return "Temp Min: \(weatherModel.main.tempMin)"
    }
    func temp() -> String {
        return "\(weatherModel.main.temp)°C"
    }
    func name() -> String? {
        return weatherModel.name
    }
    func description() -> String? {
        guard let firstWeather = weatherModel.weather.first else {
            return nil
        }
        return firstWeather.description.capitalized
    }
    func miniMaxTemp() -> String {
        return "Min: \(weatherModel.main.tempMin)° Max: \(weatherModel.main.tempMax)°"
    }
    func getURL() -> URL? {
        guard let firstWeather = weatherModel.weather.first else {
            return nil
        }
        let urlString = "http://openweathermap.org/img/wn/\(firstWeather.icon)@2x.png"
        if let url = URL(string: urlString) {
            return url
        }
        return nil
    }
    func getTimeDateDay() -> (time: String, date: String, day: String)? {
        guard let unixDate = weatherModel.unixDate else {
            return nil
        }
        let utcTimeZone = TimeZone(secondsFromGMT: 0)
        let time = Utility.getDateStringFromUnix(Double(unixDate), outFormat: .h_mm_a, timeZone: utcTimeZone)
        let day = Utility.getDateStringFromUnix(Double(unixDate), outFormat: .ee, timeZone: utcTimeZone).uppercased()
        let date = Utility.getDateStringFromUnix(Double(unixDate), outFormat: .dd, timeZone: utcTimeZone)
        return(time, date, day)
    }
    func wind() -> String {
        return "Wind \(weatherModel.wind.speed) m/s"
    }
}
