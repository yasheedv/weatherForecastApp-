//
//  Utility.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 25/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import UIKit

class Utility {
    
    class func getLocalData(of fileName: String, type: String) -> (data: Data? , dictionary: [String: Any]?) {
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: type) else { return (nil, nil) }
        let pathURL = URL(fileURLWithPath: path)
        do {
            
            let jsonData = try Data(contentsOf: pathURL, options: .mappedIfSafe)
            
            let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any]
            
            return (jsonData, jsonResult)
            
        } catch let error {
            print(error.localizedDescription)
            return (nil, nil)
        }
    }
    class func showAlert(_ tite: String, message: String, sender: UIViewController){
        let alertController = UIAlertController(title: tite, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alertController.addAction(dismissAction)
        sender.present(alertController, animated: true, completion: nil)
    }
    
    class func getDateStringFromUnix(_ unix: Double, outFormat: DateFormats, timeZone: TimeZone? = .current) -> String {
        let date = Date(timeIntervalSince1970: unix)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Calendar.current
        dateFormatter.dateFormat = outFormat.rawValue
        let stringFromDate = dateFormatter.string(from: date)
        return stringFromDate
    }
}
