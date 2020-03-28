//
//  CurrentWeatherTableViewCell.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 27/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import UIKit
import AlamofireImage

class CurrentWeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempMinMax: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var dayDate: UILabel!
    @IBOutlet weak var dayName: UILabel!
    @IBOutlet weak var wind: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI(_ viewModel: WeatherCellViewModel) {
        temp.text = viewModel.temp()
        descriptionLabel.text = viewModel.description()
        tempMinMax.text = viewModel.miniMaxTemp()
        if let  url = viewModel.getURL() {
            weatherIcon.af.setImage(withURL: url)
        }
        if let timeDateDay = viewModel.getTimeDateDay() {
            time.text = timeDateDay.time
            dayDate.text = timeDateDay.date
            dayName.text = timeDateDay.day
        }
        wind.text = viewModel.wind()
    }
}
