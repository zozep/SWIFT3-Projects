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
    let weatherVC = WeatherVC()
    
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
    
    var forecast: Forecast!
    static var forecasts = [Forecast]()
    
    
    func parseData(from weatherDict: Dictionary<String, AnyObject>) {
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
    
    func downloadForecastData(completed: @escaping DownloadComplete) {
        var shouldContinue: Int = 1
        if shouldContinue == 1 {
            //Downloading forecast weather data for TableView
            print("Now entering DownloadForecastdata()")
            Alamofire.request(CURRENT_FORECAST_URL_F).validate().responseJSON { response in
                let resultFromForecastData = response.result
                
                switch resultFromForecastData {
                    
                case .success:
                    print("Validation on Forecast Data: Success")
                    let forecastDataDict = resultFromForecastData.value as! Dictionary<String, AnyObject>
                    let forecastDataDictLists = forecastDataDict["list"] as! [Dictionary<String, AnyObject>]
                        for dictList in forecastDataDictLists {
                            let forecast = Forecast()
                            forecast.parseData(from: dictList)
                            Forecast.forecasts.append(forecast)
                        }
                        //Forecast.forecasts.remove(at: 0)
                        print("Forecast API data bound: Complete")
                    break
                        
                case .failure(let error):
                    print(error)
                }
                shouldContinue += 1
                completed()
                print("DownloadForecastData: Complete \n")
            }
        } else {
            print("waiting......")
            return
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
