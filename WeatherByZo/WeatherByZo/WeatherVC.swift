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
    currentWeather = CurrentWeather()

    var locationStatus : NSString = "Location Not Started"
    var currentLocation: CLLocation!
    
    var currentWeather: CurrentWeather!
    var forecast: Forecast!
    var forecasts = [Forecast]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            showLocationAlert()
            locationManager.requestWhenInUseAuthorization()
        }
        else {
            
            let CLAuthStatus = CLLocationManager.authorizationStatus()
            switch CLAuthStatus {
            
            case .restricted, .denied, .notDetermined:
                locationStatus = "Restricted/denied/not determined access to location"

                let alertController = UIAlertController(title: "Authorization needed", message: "Your current location is needed to show you accurate weather information.", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
                    print("User pressed cancel")
                    //maybe throw in a 404 page
                    

                }
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    print("User pressed okay")
                    //need to show app settings
                    
                }
                
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
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
            
            default:
                locationStatus = "Allowed access to location"
                shouldIAllow = true
            }
        }
        }
    }

    func showLocationAlert() {
        let alertCtrl = UIAlertController(title: "Location Services needed", message: "Turn Location Services 'ON' in \n \n Settings -> Privacy -> Location Services", preferredStyle: UIAlertControllerStyle.alert)
        
        alertCtrl.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (alertCtrl) in
            UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!) "prefs:root=LOCATION_SERVICES")! as URL)
            self.showRefreshAlert()
        }))
        show(showAlertCtrl, sender: self)
    }


    func showRefeshAlert() {
        let alert = UIAlertController(title: "Refresh Location", message: "Please check your Location Service Settings", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertControllerStyle.default, handler: { (alert) in
            self.checkLocationServices()
        }))
        showViewController(alert, sender: self)
    }

    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var shouldIAllow = false
        

        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LabelHasbeenUpdated"), object: nil)
        if (shouldIAllow == true) {
            NSLog("Location set to allowed")
            locationManager.startUpdatingLocation()
        } else {
            NSLog("Denied access: \(locationStatus)")
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error finding location: \(error.localizedDescription)")
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
