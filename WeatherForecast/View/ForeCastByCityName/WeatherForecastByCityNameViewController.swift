//
//  WeatherForecastViewController.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 25/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import UIKit

class WeatherForecastByCityNameViewController: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    private let  viewModel = WeatherViewModel()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.placeholder = "Enter city name"
        searchController.searchBar.delegate = self
        searchController.showsSearchResultsController = true
        return searchController
    }()
   

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindUI()
        setupSearchController()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           bottomView.addCurvedCorners(for: [.topLeft, .topRight], radius: 30)
    }
    
    // MARK: - Binding UI
    private func bindUI() {
        viewModel.updateUI = { [weak self] in
            self?.tableView.reloadWithVerticalAnimation()
        }
        viewModel.addToken = { [weak self] tokenName in
            self?.addSearchToken(tokenName)
        }
        viewModel.showError = { [weak self] errorMessage in
            guard let self = self else {
                return
            }
            Utility.showAlert("Sorry", message: errorMessage, sender: self)
        }
        viewModel.showCitySelectionScreen = { [weak self] in
            guard let self = self else {
                return
            }
            self.performSegue(withIdentifier: SegueIdentifier.cityNameSelectionViewController.rawValue, sender: self)
        }
    }
    // MARK: - TableView initial setup
    private func setupTableView() {
        tableView.register(cellType: WeatherTableViewCell.self)
        tableView.estimatedRowHeight = 280
        tableView.rowHeight = UITableView.automaticDimension
    }
    // MARK: - Search controller initialisation
    private func setupSearchController() {
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        title = "Search By City Name"
    }
    
    // MARK: - Navigaiton
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CityNameSelectionViewController {
            destination.viewModel = viewModel.cityNameViewModel
            destination.viewModel.delegate = viewModel
        }
    }
    // MARK: - Actions
    
    @IBAction func currentCityButtonAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let currentCityNav = storyBoard.instantiateViewController(identifier: "CurrentCityNavigationController")
        present(currentCityNav, animated: true, completion: nil)
    }
}
// MARK: - UITableViewDataSource
extension WeatherForecastByCityNameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: WeatherTableViewCell.self, for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        let cellViewModel = viewModel.cellViewModel(for: indexPath)
        cell.updateUI(cellViewModel)
        return cell
    }
}

//MARK: - Adding UISearchToken
extension WeatherForecastByCityNameViewController {
    private func addSearchToken(_ name: String) {
        searchController.searchBar.searchTextField.text = nil
        let searchToken = UISearchToken(icon: UIImage(systemName: "location.circle.fill"), text: name)
        searchController.searchBar.searchTextField.tokens.append(searchToken)
    }
}



// MARK: - UISearchResultsUpdating
extension WeatherForecastByCityNameViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.updateSearchResults(searchController.searchBar.text)
    }
}
// MARK: - UISearchBarDelegate
extension WeatherForecastByCityNameViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.dismiss(animated: true) {
            self.viewModel.checkForLastText(searchBar.text)
            let tokens = searchBar.searchTextField.tokens
            let cityNames = tokens.map( {$0.value(forKey: "text") as? String }).compactMap({$0})
            self.viewModel.searchBarSearchButtonClicked(with: cityNames)
        }
    }
}
