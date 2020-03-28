//
//  DetailTableViewCell.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 25/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import UIKit
import AlamofireImage

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func updateUI(_ viewModel: DetailCellViewModel) {
        descriptionLabel.text = viewModel.description()
        weatherImage.isHidden = viewModel.showImage()
        if let url = viewModel.getURL() {
            weatherImage.af.setImage(withURL: url)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
