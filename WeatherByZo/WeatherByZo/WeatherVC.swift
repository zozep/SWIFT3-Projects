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
    
    //MARK: variables and constants
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var currentWeather: CurrentWeather!
    let locationManager = CLLocationManager()
    var forecast: Forecast!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        locationManager.startUpdatingLocation()

        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        forecast = Forecast()

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        currentWeather = CurrentWeather()
    }

    
    
    //MARK: Boilerplate code for tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //returns the number of cells returned from API
        return Forecast.forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell {
            let forecast = Forecast.forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            return cell
        } else {
            return WeatherCell()
        }
    }
    
    
    
    /* MARK: Authorization & Location check */
    
//    func locationAuthStatus() {
//        
//        if CLLocationManager.locationServicesEnabled() && locationManager.{
//            locationManager.requestWhenInUseAuthorization()
//        }
//            let CLAuthStatus = CLLocationManager.authorizationStatus()
//            
//            switch CLAuthStatus {
//                
//            case .notDetermined:
//                print("No access: notDetermined")
//                locationManager.requestWhenInUseAuthorization()
//                break
//                
//            case .restricted, .denied:
//                print("No access given")
//                locationManager.stopMonitoringSignificantLocationChanges()
//                break
//                
//            case .authorizedWhenInUse, .authorizedAlways:
//                locationManager.startMonitoringSignificantLocationChanges()
//                print("access when in use or authorized always")
//                
//        } else {
//        locationManager.stopUpdatingLocation()
//        showAuthAlert()
//
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
           let currentLocation: CLLocation!

            currentLocation = locationManager.location
            if currentLocation != nil {
                locationManager.stopUpdatingLocation()
                locationManager.stopMonitoringSignificantLocationChanges()
            }
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude as Double
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude as Double
            print("Lat :=: \(currentLocation.coordinate.latitude), Long :=: \(currentLocation.coordinate.longitude)")
            

//        } else {
//            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError: Error) {
        print(didFailWithError.localizedDescription)
    }

    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
////        let CLAuthStatus = CLLocationManager.authorizationStatus()
//        switch(status) {
//        case .restricted, .denied:
//            print("No access: either denied", status.rawValue)
//            locationManager.stopUpdatingLocation()
//            break
//            
//        case .authorizedWhenInUse, .authorizedAlways:
//            print("access when in use or authorized always")
//            locationManager.requestLocation()
//            break
//        case .notDetermined:
//            print("Not determined")
//            locationManager.requestWhenInUseAuthorization()
//        }
//    }
//
//        print("about to fail")
//        Location.sharedInstance.latitude = currentLocation.coordinate.latitude
//        Location.sharedInstance.longitude = currentLocation.coordinate.longitude
//        print("lat & long can be found")
//        
//        currentWeather.downloadWeatherDetails {
//            print("entering downloadweatherdetails")
//            self.downloadForecastData {
//                self.updateMainUI()
//                print("finished updateUI")
//            }
//        }


//    }
//
//    //Mark: Custom Alert
//    func showAuthAlert() {
//        let authAlertController = UIAlertController (title: "1. Please turn Location Services ON", message: "Settings -> Privacy -> Location Serivices", preferredStyle: .alert)
//        let settingsAction = UIAlertAction(title: "Okay", style: .default) { (_) -> Void in
//            guard let okURL = URL(string: UIApplicationOpenSettingsURLString) else {
//                return
//            }
//            if UIApplication.shared.canOpenURL(okURL) {
//                UIApplication.shared.open(okURL, completionHandler: { (success) in
//                    print("Settings opened from AuthAlert(): \(success)")
//                    
//                })
//                //self.locationAuthStatus()
//            }
//        }
//        authAlertController.addAction(settingsAction)
//        present(authAlertController, animated: true, completion: nil)
//    }
//    
//    
//    func downloadForecastData(completed: @escaping DownloadComplete) {
//        //Downloading forecast weather data for TableView
//        Alamofire.request(CURRENT_FORECAST_URL_F).validate().responseJSON { response in
//            let resultFromForecastData = response.result
//            
//            switch resultFromForecastData {
//                
//            case .success:
//                print("Validation for downloading forecast data was Successful")
//                if let dict = resultFromForecastData.value as? Dictionary<String, AnyObject> {
//                    if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
//                        for obj in list {
//                            let forecast = Forecast(weatherDict: obj)
//                            self.forecasts.append(forecast)
//                        }
//                        self.forecasts.remove(at: 0)
//                        self.tableView.reloadData()
//                    }
//                    print("Successfully downloaded Forecast Data")
//                }
//            case .failure(let error):
//                print(error)
//            }
//            completed()
//        }
//    }
    
    //MARK: UI UPDATE
    func updateMainUI() {
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)"
        currentWeatherTypeLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }
}

