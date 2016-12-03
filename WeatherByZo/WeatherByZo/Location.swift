//
//  Location.swift
//  WeatherByZo
//
//  Created by Joseph Park on 12/2/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
   
}
