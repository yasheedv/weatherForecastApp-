//
//  HomeViewController.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 27/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class CurrentLocationViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()
    let viewModel = CurrentLocationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        setupTableView()
        addNavButtons()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestLocation()
    }
  
    private func addNavButtons() {
        let gpsButton = UIBarButtonItem(image: UIImage(named: "gps"), style: .plain, target: self, action: #selector(gpsButtonAction))
        navigationItem.rightBarButtonItem = gpsButton
        let donButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction))
        donButton.tintColor = UIColor(red: 135 / 255, green: 94 / 255, blue: 15 / 255, alpha: 1)
        navigationItem.leftBarButtonItem = donButton
    }
    private func setupTableView() {
        tableView.register(cellType: CurrentWeatherTableViewCell.self)
        tableView.backgroundColor = .clear
    }
    
    private func bindUI() {
        title = "Current Weather Forecast"
        viewModel.updateUI = { [weak self] in
            self?.tableView.reloadWithVerticalAnimation()
        }
        viewModel.showError = { [weak self] errorMessage in
            guard let self = self else {
                return
            }
            Utility.showAlert("Sorry", message: errorMessage, sender: self)
        }
    }
    
    // MARK: - Actions
    @objc func gpsButtonAction() {
        CommonLoader.showSpinner("Getting Location..")
        requestLocation()
    }
    @objc private func doneButtonAction() {
          dismiss(animated: true, completion: nil)
    }
}
// MARK: - Handling Location
extension CurrentLocationViewController {
    private func requestLocation() {
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            retrievCurrentLocation()
        }
    }
    // Show the popup to the user if he deined access
    private func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "In order to get weather forecast we need your location",
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (_) in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        alertController.addAction(openAction)
        
        present(alertController, animated: true, completion: nil)
    }
    private func retrievCurrentLocation() {
        let status = CLLocationManager.authorizationStatus()
        if status == .denied || status == .restricted {
            showLocationDisabledPopUp()
            return
        }
        locationManager.requestLocation()
    }
    private func stopLocationUpdating() {
        DispatchQueue.main.async {
            CommonLoader.hideSpinner()
        }
        locationManager.stopUpdatingLocation()
    }
}
// MARK: - CLLocationManagerDelegate
extension CurrentLocationViewController: CLLocationManagerDelegate {
    // Print out the location to the console
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        stopLocationUpdating()
        guard let location = locations.first else {
            return
        }
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        viewModel.userLocationRecieved(latitude, longitude: longitude)
        
        // Getting the city name
        CLGeocoder().reverseGeocodeLocation(location) { (placeMarks, error) in
            guard let placeMarks = placeMarks,
                let placeMark = placeMarks.first,
                let locality = placeMark.locality else {
                    return
            }
            self.title = "\(locality) Weather Forecast"
        }
    }
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        CommonLoader.showSpinner("Getting Location..")
        retrievCurrentLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        CommonLoader.hideSpinner()
        Utility.showAlert("sorry", message: error.localizedDescription, sender: self)
    }
}

// MARK: - UITableViewDataSource
extension CurrentLocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: CurrentWeatherTableViewCell.self, for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        let cellViewModel = viewModel.cellViewModel(for: indexPath)
        cell.updateUI(cellViewModel)
        return cell
    }
}
