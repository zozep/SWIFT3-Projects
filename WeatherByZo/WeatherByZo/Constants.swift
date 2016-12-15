//
//  Constants.swift
//  WeatherByZo
//
//  Created by Joseph Park on 11/29/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import Foundation


let API_KEY = "6a2b5edafbed2ab3e911c384d25a8e78"

typealias DownloadComplete = () -> ()

let CURRENT_WEATHER_URL_F = "http://api.openweathermap.org/data/2.5/weather?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&units=imperial&appid=6a2b5edafbed2ab3e911c384d25a8e78"

let CURRENT_FORECAST_URL_F = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&units=imperial&cnt=10&mode=json&appid=6a2b5edafbed2ab3e911c384d25a8e78"
