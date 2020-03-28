//
//  SearchResultUpdationViewController.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 26/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import UIKit

class CityNameSelectionViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!

    var viewModel: CityNameViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        title = "Select City"
        view.backgroundColor = UIColor(red: 15 / 255,
                                       green: 56 / 255,
                                       blue: 135 / 255,
                                       alpha: 1)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Utility.showAlert( "Please choose your desired city ", message: "Multiple city names available for \(viewModel.userTypedName)", sender: self)

    }
    private func setupTableView() {
        tableView.register(cellType: CityNameTableViewCell.self)
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
    }
}
// MARK: - UITableViewDataSource
extension CityNameSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cityNames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: CityNameTableViewCell.self, for: indexPath)
        cell.cityName.text = viewModel.cityName(for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CityNameSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.popViewController(animated: true)
        viewModel.cityNameSelected(for: indexPath)
    }
}
