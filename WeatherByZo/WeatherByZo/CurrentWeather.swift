//
//  CurrentWeather.swift
//  WeatherByZo
//
//  Created by Joseph Park on 11/29/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit
import Alamofire

class CurrentWeather {
    var _cityName: String!
    var _date: String!
    var _weatherType: String!
    var _currentTemp: String!
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    var date: String {
        if _date == nil {
            _date = ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        let currentDate = dateFormatter.string(from: Date())
        self._date = "\(currentDate)"
        return _date
    }
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    var currentTemp: String {
        if _currentTemp == nil {
            _currentTemp = ""
        }
        return _currentTemp
    }
    
    //CurrentWeather
    func downloadWeatherDetails(completed: @escaping DownloadComplete) {
        
        //Alamofire download
        Alamofire.request(CURRENT_WEATHER_URL_F).validate().responseJSON { response in
            let resultFromWeatherDetails = response.result
            
            switch resultFromWeatherDetails {
                
            case .success:
                print("Validation for downloading weather details Successful")
                if let dict = resultFromWeatherDetails.value as? Dictionary<String, AnyObject> {
                    if let name = dict["name"] as? String {
                        self._cityName = name.capitalized
                    }
                    
                    if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                        //very first part of array dictionary
                        if let main = weather[0]["main"] as? String {
                           self._weatherType = main.capitalized
                        }
                    }
                    
                    if let main = dict["main"] as? Dictionary<String, AnyObject> {
                        if let currentTemperature = main["temp"] as? Double {
                            let roundedCurrentTemp = round(10.0 * currentTemperature) / 10.0
                            self._currentTemp = "\(roundedCurrentTemp)°"
                        }
                    }
                    print("Succesfully downloaded Weather detail")
                }
            case .failure(let error):
                print(error)
            }
            print("completed downloadweatherdetails")
            completed()
        }
    }

}
