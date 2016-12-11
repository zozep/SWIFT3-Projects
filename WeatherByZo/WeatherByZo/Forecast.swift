//
//  Forecast.swift
//  WeatherByZo
//
//  Created by Joseph Park on 12/1/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit
import Alamofire

class Forecast {
    
    var _date: String!
    var _weatherType: String!
    var _highTemp: String!
    var _lowTemp: String!
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var highTemp: String {
        if _highTemp == nil {
            _highTemp = ""
        }
        return _highTemp
    }
    
    var lowTemp: String {
        if _lowTemp == nil {
            _lowTemp = ""
        }
        return _lowTemp
    }
    
    
    init (weatherDict: Dictionary<String, AnyObject>) {
        //temp
        if let temp = weatherDict["temp"] as? Dictionary<String, AnyObject> {
            //lowTemp
            if let minTemp = temp["min"] as? Double {
                let roundedMinTemp = round(10.0 * minTemp) / 10.0
                self._lowTemp = "\(roundedMinTemp)°"
            }
            //highTemp
            if let maxTemp = temp["max"] as? Double {
                let roundedMaxTemp = round(10.0 * maxTemp) / 10.0
                self._highTemp = "\(roundedMaxTemp)°"
            }
        }
        //weatherType
        if let weather = weatherDict["weather"] as? [Dictionary<String, AnyObject>] {
            if let mainWeatherType = weather[0]["main"] as? String {
                self._weatherType = mainWeatherType
            }
        }
        
        //date
        if let date = weatherDict["dt"] as? Double {
            let unixConvertedDate = Date(timeIntervalSince1970: date)
            self._date = unixConvertedDate.dayOfTheWeek()
        }
    }
}

extension Date {
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
