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
    let weatherVC = WeatherVC()
    let currentLocation = Location()
    
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
        var ShouldContinue: Int = 1
        
        //Alamofire download
        if ShouldContinue == 1 {
            
            Alamofire.request(CURRENT_WEATHER_URL_F).validate().responseJSON { response in
                let resultFromWeatherDetails = response.result
                
                switch resultFromWeatherDetails {
                    
                case .success:
                    if (self.weatherVC.currentLocation != nil) && (self.weatherVC.count > 1) {
                        break
                    } else {
                        print("Validation on Weather Details data: Success")
                        let weatherDetailDict = resultFromWeatherDetails.value as! Dictionary<String, AnyObject>
                        let name = weatherDetailDict["name"] as! String
                        self._cityName = name.capitalized
                        
                        let weather = weatherDetailDict["weather"] as! [Dictionary<String, AnyObject>]
                        //very first part of array dictionary
                        let mainWeatherType = weather[0]["main"] as! String
                        self._weatherType = mainWeatherType.capitalized
                        
                        let currentTempWrittenAsMaininAPI = weatherDetailDict["main"] as! Dictionary<String, AnyObject>
                        let currentTemperature = currentTempWrittenAsMaininAPI["temp"] as! Double
                        
                        let roundedCurrentTemp = round(10.0 * currentTemperature) / 10.0
                        self._currentTemp = "\(roundedCurrentTemp)°"
                        print("WeatherDeatails API data bound: Complete")
                        break
                    }
                case .failure(let error):
                    print(error)
                }
                ShouldContinue += 1
                completed()
                print("Downloadweatherdetails: Complete \n")
            }
        } else {
            print("locaion more than once...")
            return
        }
    }

}
