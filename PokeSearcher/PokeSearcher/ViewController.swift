//
//  ViewController.swift
//  PokeSearcher
//
//  Created by Joseph Park on 12/31/16.
//  Copyright © 2016 Joseph Park. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var geoFire: GeoFire!
    var geoFireRef: FIRDatabaseReference!
    
    let locationManager = CLLocationManager()
    var mapHasCenteredOnce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        //reference to general database
        geoFireRef = FIRDatabase.database().reference()
        geoFire = GeoFire(firebaseRef: geoFireRef)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        mapView.setRegion(coordinateRegion, animated: true)
    
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let loc = userLocation.location {
            if !mapHasCenteredOnce {
                centerMapOnLocation(location: loc)
                mapHasCenteredOnce  = true
            }
        }
    }

    //1. IF YOU SPOT A RANDOM POKEMON, app's going to createSighting -> which sets geoFire.setLocation @ line 97
    @IBAction func spotRandomPokemon(_ sender: Any) {
        let mvCenterlocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        let random = arc4random_uniform(151) + 1
        
        createSighting(forLocation: mvCenterlocation, withPokemon: Int(random))
    }

    
    //2. when location is set the callback .keyEntered wil automatically be entered
    func createSighting(forLocation location: CLLocation, withPokemon pokeId: Int) {
        
        //3.when the app first loads this is going to be called and cycle through for every single Pokemon on the map in a specific geographical location
        geoFire.setLocation(location, forKey: "\(pokeId)")
    }
    
    func showSightingsOnMap(location: CLLocation) {
        //geofire documentation
        let circleQuery = geoFire!.query(at: location, withRadius: 5)
        
        _ = circleQuery?.observe(GFEventType.keyEntered, with: { (key, location) in
            //observe whenever it finds a sighting i.e: if 50 pokemon, this gets called 50 times
            if let key = key, let location = location {
                
                //create an annotation using custom annotation, passing in the locaiton of the very specific pokemon, then pass in the pokemonNumber -> gets saved on the map and this will drop the pindrop on the map
                let annotation = PokeAnnotation(coordinate: location.coordinate, pokemonNumber: Int(key)!)
                self.mapView.addAnnotation(annotation)
            }
        })
    }

    //4. called after showSighntingsOnMap
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView?
        let annotationIdentifier = "Pokemon"
        
        //if USER, use ASH
        if annotation.isKind(of: MKUserLocation.self) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            annotationView?.image = UIImage(named: "ash")
            
            //create identifier pokemon
        } else if let dequeAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeAnnotation
            annotationView?.annotation = annotation
            
            //create default
        } else {
            let annotView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = annotView
        }
        
        //in any of the cases, it's customized
        if let annotationView = annotationView, let anno = annotation as? PokeAnnotation {
            
            //by givin git the image itself on the annotation itself - giving it a pokemon, then want to call the canShowCallout when user taps
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "\(anno.pokemonNumber)")
            
            //set the btn that users gonna tap on
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn.setImage(UIImage(named: "map"), for: .normal)
            annotationView.rightCalloutAccessoryView = btn
            
            
        }
        
        //result shows on the map
        return annotationView
    }

}

