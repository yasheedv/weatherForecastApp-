//
//  UIViewExtension.swift
//  WeatherForecast
//
//  Created by Yasheed Muhammed on 27/03/2020.
//  Copyright © 2020 yasheed. All rights reserved.
//

import UIKit

extension UIView {
    
    func addCurvedCorners(for corners: UIRectCorner, radius: Double = 20){
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds,
                                      byRoundingCorners: corners,
                                      cornerRadii: CGSize(width: radius, height: radius)).cgPath
        self.layer.mask = rectShape
    }
}
