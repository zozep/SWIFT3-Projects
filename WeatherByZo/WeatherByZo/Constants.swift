//
//  Constants.swift
//  WeatherByZo
//
//  Created by Joseph Park on 11/29/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import Foundation

let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let API_KEY = "63a98bf76b688064835c85ed9d42d012"

let CURRENT_WEATHER_URL = "\(BASE_URL)\(LATITUDE)47.6\(LONGITUDE)-122.3\(APP_ID)\(API_KEY)"

typealias DownloadComplete = () -> ()

let FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?id=524901&appid=63a98bf76b688064835c85ed9d42d012"
