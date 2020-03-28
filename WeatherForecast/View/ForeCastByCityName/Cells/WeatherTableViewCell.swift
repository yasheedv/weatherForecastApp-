//
//  HeaderTableViewCell.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 25/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var tempMax: UILabel!
    @IBOutlet weak var tempMin: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var viewModel: WeatherCellViewModel!
    
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
        // Initialization code
    }
    private func setupTableView() {
        tableView.register(cellType: DetailTableViewCell.self)
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func updateUI(_ viewModel: WeatherCellViewModel) {
        self.viewModel = viewModel
        tempMax.text = viewModel.tempMax()
        tempMin.text = viewModel.tempMin()
        temp.text = viewModel.temp()
        cityName.text = viewModel.name()
        tableView.reloadData()
        heightConst.constant = tableView.contentSize.height + 30
    }
}

extension WeatherTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.internalDataSoruce.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: DetailTableViewCell.self, for: indexPath)
        cell.selectionStyle = .none
        let cellViewModel = viewModel.viewModel(for: indexPath)
        cell.updateUI(cellViewModel)
        cell.backgroundColor = .clear
        return cell
    }
}
