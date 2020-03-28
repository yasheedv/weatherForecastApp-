//
//  DetailCellViewModel.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 26/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import Foundation

class DetailCellViewModel {
    // MARK: Properpties
    var detailsListModel: DetailsListModel
    
    init(_ model: DetailsListModel) {
        detailsListModel = model
    }
    
    func showImage() -> Bool {
        return detailsListModel.image == nil
    }
    func description() -> String {
        return detailsListModel.title
    }
    func getURL() -> URL? {
        if let imageName = detailsListModel.image {
            let urlString = "http://openweathermap.org/img/wn/\(imageName)@2x.png"
            if let url = URL(string: urlString) {
                return url
            }
        }
        return nil
    }
}
