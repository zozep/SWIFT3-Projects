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
    var currentWeather: CurrentWeather!

    let locationManager = CLLocationManager()
    var shouldIAllow: Bool = false

    var locationStatus : NSString = "Location Not Started"
    var currentLocation: CLLocation!
    
    var forecast: Forecast!
    var forecasts = [Forecast]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentWeather = CurrentWeather()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        
        DispatchQueue.main.async(execute: {
            self.checkLocationServices()
        })
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
    
    
    //MARK: Authorization & Location check

    
    func checkLocationServices() {
        
        if CLLocationManager.locationServicesEnabled() == false {
            let alertCtrl = UIAlertController(title: "Location Services needed", message: "Turn Location Services 'ON' in \n \n Settings -> Privacy -> Location Services", preferredStyle: UIAlertControllerStyle.alert)
            
            alertCtrl.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (alertCtrl) in
                UIApplication.shared.open(URL(string:"prefs:root=Privacy")! as URL)
            }))
            show(alertCtrl, sender: self)

        }
        
        locationManager.requestWhenInUseAuthorization()
            let CLAuthStatus = CLLocationManager.authorizationStatus()
            switch CLAuthStatus {
            
            case .restricted, .denied, .notDetermined:
                locationStatus = "Restricted/denied/not determined access to location"

                let alertController = UIAlertController(title: "Authorization needed", message: "Your authorization is needed to show you accurate weather information.", preferredStyle: .alert)
                
                
                let okAction = UIAlertAction(title: "Settings", style: UIAlertActionStyle.default, handler: { (alertController) in
                    UIApplication.shared.open(URL(string: "prefs:root=LOCATION_SERVICES")! as URL)
                    self.locationStatus = "allowed access to location"
                    self.checkLocationServices()
                })
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                break
                
            case .authorizedWhenInUse, .authorizedAlways:
                locationStatus = "Access to location granted"

                currentLocation = locationManager.location
                Location.sharedInstance.latitude = currentLocation.coordinate.latitude
                Location.sharedInstance.longitude = currentLocation.coordinate.longitude
                shouldIAllow = true
            
            default:
                locationStatus = "Did not allow access to location"
                shouldIAllow = false
        }
    
    }

//
//    func locationManager(manager: CLLocationManager, didFailWithError error: Error) {
//        print("Error finding location: \(error.localizedDescription)")
//    }

    //MARK: Forecast Data
    
    func updateMainUI() {
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)"
        currentWeatherTypeLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }
}

