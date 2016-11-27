//
//  City.swift
//  Weather
//
//  Created by ts on 2016/11/26.
//  Copyright © 2016年 ts. All rights reserved.
//
import Foundation
import UIKit

class City: NSObject {
//    var locationImage: UIImage?
    var cityName: String
    var tempratureImage: UIImage?
    var temprature: String?
    
    //initialization
    init?(cityName: String, tempratureImage: UIImage?, temprature: String?){//问号代表可选
        if cityName.isEmpty {
            return nil
        }
        
        self.cityName = cityName
        self.tempratureImage = tempratureImage
        self.temprature = temprature
        
        super.init()
    }
    convenience init?(_ name: String,_ temprature: String?){//问号代表可失败
        self.init(cityName: name, tempratureImage:nil, temprature:temprature)
    }
}

