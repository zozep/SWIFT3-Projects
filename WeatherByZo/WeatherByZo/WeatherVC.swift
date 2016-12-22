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
    
    let locationManager = CLLocationManager()
    var currentWeather: CurrentWeather!
    var forecast: Forecast!
    var currentLocation: CLLocation!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        tableView.delegate = self
        tableView.dataSource = self
        forecast = Forecast()
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            print("Lat :=: \(currentLocation.coordinate.latitude),Long :=: \(currentLocation.coordinate.longitude)")
            self.currentWeather.downloadWeatherDetails {
                self.forecast.downloadForecastData {
                    print("finished downloading forecast data")
                    self.updateMainUI()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError: Error) {
        let err = didFailWithError.localizedDescription
        print(err)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            locationManager.requestLocation()
            break
        default:
            print("Default: ", status.rawValue)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("ERROR: ", error.localizedDescription)
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

