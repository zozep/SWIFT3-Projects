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
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        currentWeather = CurrentWeather()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    
    
    //MARK: Boilerplate code for tableView
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
    
    
    /* MARK: Authorization & Location check */
    func locationAuthStatus() {
        if CLLocationManager.locationServicesEnabled() == true {
            let CLAuthStatus = CLLocationManager.authorizationStatus()
            switch CLAuthStatus {
            case .restricted, .denied, .notDetermined:
                showAuthAlert()
                break
                
            case .authorizedWhenInUse, .authorizedAlways:
                currentLocation = locationManager.location
                Location.sharedInstance.latitude = currentLocation.coordinate.latitude
                Location.sharedInstance.longitude = currentLocation.coordinate.longitude
                currentWeather.downloadWeatherDetails {
                    self.downloadForecastData {
                        self.updateMainUI()
                    }
                }
                break
            }
        } else {
            locationManager.stopMonitoringSignificantLocationChanges()
            showLocationServicesEnabledAlert()
        }
    }
    
    
    //Mark: Custom Alert
    func showLocationServicesEnabledAlert() {
        let alertController = UIAlertController (title: "Please enable Location Services", message: "Settings -> Privacy -> Location Serivices", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Okay", style: .default) { (_) -> Void in
            guard let okURL = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(okURL) {
                UIApplication.shared.open(okURL, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showAuthAlert() {
        let authAlertController = UIAlertController (title: "Please give set the location access to 'While in use' or 'Always'", message: "Your location is needed to give you correct weather data", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .default) { (_) -> Void in
            guard let okURL = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(okURL) {
                UIApplication.shared.open(okURL, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        authAlertController.addAction(okayAction)
        present(authAlertController, animated: true, completion: nil)
    }
    
    
    //MARK: Forecast Data
    func downloadForecastData(completed: @escaping DownloadComplete) {
        //Downloading forecast weather data for TableView
        Alamofire.request(CURRENT_FORECAST_URL_F).validate().responseJSON { response in
            let resultFromForecastData = response.result
            
            switch resultFromForecastData {
            case .success:
                print("Validation for downloading forecast data was Successful")
                if let dict = resultFromForecastData.value as? Dictionary<String, AnyObject> {
                    if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                        for obj in list {
                            let forecast = Forecast(weatherDict: obj)
                            self.forecasts.append(forecast)
                        }
                        self.forecasts.remove(at: 0)
                        self.tableView.reloadData()
                    }
                    print("Successfully downloaded Forecast Data")
                }
            case .failure(let error):
                print(error)
            }
            completed()
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
