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
    let currentWeather = CurrentWeather()
    let currentLocation = CLLocation()
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
        print("Now entering downloadWeatherDetails()")
        
        //Alamofire download
        Alamofire.request(CURRENT_WEATHER_URL_F).validate().responseJSON { response in
            let resultFromWeatherDetails = response.result
            
            switch resultFromWeatherDetails {
                
            case .success:
                if currentWeather.currentLocation != nil {
                    break
                } else {
                    print("Validation on Weather Details data: Success")
                    let dict = resultFromWeatherDetails.value as! Dictionary<String, AnyObject>
                    let name = dict["name"] as! String
                    self._cityName = name.capitalized
                        
                    
                    let weather = dict["weather"] as! [Dictionary<String, AnyObject>]
                    //very first part of array dictionary
                    let mainWeatherType = weather[0]["main"] as! String
                    self._weatherType = mainWeatherType.capitalized
                    
                    let currentTempWrittenAsMaininAPI = dict["main"] as! Dictionary<String, AnyObject>
                    let currentTemperature = currentTempWrittenAsMaininAPI["temp"] as! Double
                    
                    let roundedCurrentTemp = round(10.0 * currentTemperature) / 10.0
                    self._currentTemp = "\(roundedCurrentTemp)°"
                    print("weatherDeatails API data bound: Complete")
                }
            case .failure(let error):
                print(error)
            }
            completed()
            print("Downloadweatherdetails: Complete \n")
        }
    }

}
