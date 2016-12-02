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
    
    private var _date: String!
    private var _weatherType: String!
    private var _highTemp: String!
    private var _lowTemp: String!
    
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
        if let temp = weatherDict["temp"] as? Dictionary<String, AnyObject> {
            
            //lowtemp
            if let min = temp["min"] as? Double {
                //convert temp Kelvin -> F/C
                let tempInFarenheitPreDivision = (min * (9/5) - 459.67)
                let tempInFarenheit = Double(round(10 * tempInFarenheitPreDivision/10))
                self._lowTemp = "\(tempInFarenheit)"
            }
            
            //hightemp
            if let max = temp["max"] as? Double {
                    //convert temp Kelvin -> F/C
                    let tempInFarenheitPreDivision = (max * (9/5) - 459.67)
                    let tempInFarenheit = Double(round(10 * tempInFarenheitPreDivision/10))
                    self._highTemp = "\(tempInFarenheit)"
            }
        }
        //weather
        if let weather = weatherDict["weather"] as? [Dictionary<String, AnyObject>] {
            if let main = weather[0]["main"] as? String {
                self._weatherType = main
            }
        }
        
        //date
        if let date = weatherDict["dt"] as? Double {
            let unixConvertedDate = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.dateFormat = "EEEE"
            dateFormatter.timeStyle = .none
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
