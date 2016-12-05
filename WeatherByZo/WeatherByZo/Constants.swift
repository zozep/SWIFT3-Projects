//
//  Constants.swift
//  WeatherByZo
//
//  Created by Joseph Park on 11/29/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import Foundation


let API_KEY = "2d6d755c69dd06037b5c93acf91777ba"

typealias DownloadComplete = () -> ()

let CURRENT_WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&appid=2d6d755c69dd06037b5c93acf91777ba"

let CURRENT_FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&cnt=10&mode=json&appid=2d6d755c69dd06037b5c93acf91777ba"
