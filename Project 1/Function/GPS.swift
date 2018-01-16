//
//  GPS.swift
//  INFO DISDIK
//
//  Created by SchoolDroid on 12/20/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import CoreLocation
import UIKit
import Foundation

protocol GpsDelegate {
    func getLocation(latitude : String? , longitude : String? , negara : String? , provinsi : String? , kota : String? , namaJalan : String? , kodePos : String?)
}

class GPS: NSObject, CLLocationManagerDelegate  {
    let locationManager = CLLocationManager()
    
    var delegate : GpsDelegate?
    
    init(viewController : UIViewController) {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.startUpdatingLocation()
                break
            case .restricted , .denied:
                Authorization.toSetting(sender: viewController, title: "Akses Lokasi", message: "Untuk kebutuhan pendaftaran, kami membutuhkan informasi mengenai Negara dan Kota anda. Mohon berikan akses")
                //self.locationManager.startUpdatingLocation()
                break
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                break
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        if location.horizontalAccuracy > 0 {
            
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude

            print("long = \(lat) , lat = \(lon)")
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemark, error) in
                if error != nil {
                    print("Error Location")
                }
                else {
                    if let posisi = placemark?.last {
                        self.delegate?.getLocation(latitude: String(lat), longitude: String(lon), negara: posisi.country, provinsi: posisi.administrativeArea, kota: posisi.locality, namaJalan: posisi.name, kodePos: posisi.postalCode)
                    }
                }
            })
        }
            
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func stop (){
        self.locationManager.stopUpdatingLocation()
        self.locationManager.delegate = nil
    }
    
        
}
