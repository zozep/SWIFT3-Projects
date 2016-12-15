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
    var currentLocation: CLLocation!
    var locationStatus : NSString = "Not Started"

    var forecast: Forecast!
    var forecasts = [Forecast]()
    
    
    
    //MARK: ViewDidLoad & ViewDidAppear
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        currentWeather = CurrentWeather()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0


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
            showLocationServicesEnabledAlert()
        }
    }
    
    
    //Mark: Custom Alert
    func showLocationServicesEnabledAlert() {
        let alertController = UIAlertController (title: "Please enable Location Services, and allow location access", message: "Settings -> Privacy -> Location Serivices", preferredStyle: .alert)
        
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
    
    
    //MARK: UI UPDATE
    func updateMainUI() {
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)"
        currentWeatherTypeLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }
}

