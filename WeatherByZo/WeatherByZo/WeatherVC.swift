//
//  WeatherVC.swift
//  WeatherByZo
//
//  Created by Joseph Park on 11/29/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class WeatherVC: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var currentWeather: CurrentWeather!
    var forecast: Forecast!
    var forecasts = [Forecast]()

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()                        /* request location updates */

        currentWeather = CurrentWeather()
        
    }

    //implementing delegate func for location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            
            if currentLocation != nil {
                locationManager.stopUpdatingLocation()
            }
            Location.sharedInstance.latitude = currentLocation?.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation?.coordinate.longitude
            downloadWeatherDetails {
                //Setup the UI to load the downloaded data
                self.downloadForecastData() {
                self.updateMainUI()
                }
            }
        }
        else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    //CurrentWeather
    func downloadWeatherDetails(completed: @escaping DownloadComplete) {
        //Alamofire download
        Alamofire.request(CURRENT_WEATHER_URL).validate().responseJSON { response in
            let resultFromWeatherDetails = response.result
            
            switch resultFromWeatherDetails {
            case .success:
                print("Validation for downloading weather details Successful")
                if let dict = resultFromWeatherDetails.value as? Dictionary<String, AnyObject> {
                    
                    if let name = dict["name"] as? String {
                        self.currentWeather._cityName = name.capitalized
                        //print(self._cityName)
                    }
                    
                    if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                        //very first part of array dictionary
                        if let main = weather[0]["main"] as? String {
                            self.currentWeather._weatherType = main.capitalized
                            //print(self._weatherType)
                            
                        }
                    }
                    
                    if let main = dict["main"] as? Dictionary<String, AnyObject> {
                        
                        if let currentTemperature = main["temp"] as? Double {
                            //convert temp Kelvin -> F/C
                            let tempInFarenheitPreDivision = (currentTemperature * (9/5) - 459.67)
                            let tempInFarenheit = Double(round(10 * tempInFarenheitPreDivision/10))
                            self.currentWeather._currentTemp = tempInFarenheit
                            //print(self._currentTemp)
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
            completed()
        }
    }

    //Forecast
    func downloadForecastData(completed: @escaping DownloadComplete) {
        //Downloading forecast weather data for TableView
        Alamofire.request(CURRENT_FORECAST_URL).validate().responseJSON { response in
            let resultFromForecastData = response.result
            
            switch resultFromForecastData {
            case .success:
                print("Validation for downloading forecast data was Successful")
                if let dict = resultFromForecastData.value as? Dictionary<String, AnyObject> {
                    if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                        for obj in list {
                            let forecast = Forecast(weatherDict: obj)
                            self.forecasts.append(forecast)
                            print("line 124 on weatherVC: \(obj)")
                        }
                        self.forecasts.remove(at: 0)
                        self.tableView.reloadData()
                    }
                }
            case .failure(let error):
                print(error)
            }
            completed()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //returns the number of cells returned from API
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell {
        let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            return cell
        } else {
            return WeatherCell()
        }
    
    }
    
    func updateMainUI() {
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)"
        currentWeatherTypeLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }
}

