//
//  CommonLoader.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 27/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import UIKit

class CommonLoader: UIView {
    static var alertController = UIAlertController()
    
    class func showSpinner(_ message: String = "Please wait...") {
        alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()
        alertController.view.addSubview(loadingIndicator)
        if let topVC = UIApplication.topViewController(), !topVC.isKind(of: UIAlertController.self) {
            topVC.present(alertController, animated: true, completion: nil)
        }
    }
    class func hideSpinner() {
        alertController.dismiss(animated: true, completion: nil)
    }
}
