//
//  CityNameTableViewCell.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 26/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import UIKit

class CityNameTableViewCell: UITableViewCell {

    @IBOutlet weak var cityName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(_ viewModel: CityNameCellViewModel) {
        cityName.text = viewModel.name()
    }
}
