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
import GoogleMaps

protocol GpsDelegate {
    func getLocation(latitude : String? , longitude : String? , negara : String? , provinsi : String? , kota : String? , kec : String? , kel : String? , namaJalan : String? , kodePos : String?)
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

            print("long = \(lon) , lat = \(lat)")
            
            GMSGeocoder().reverseGeocodeCoordinate(CLLocationCoordinate2D.init(latitude: lat, longitude: lon), completionHandler: { (result, error) in
                if let error = error {
                    print("Error \(error)")
                } else {
                    if let res = result!.firstResult(){
                        var kota : String?
                        if let lines = res.lines {
                            //print(lines)
                            let line2 = lines[1]
                            let pisah = line2.split(separator: ",")
                            if pisah.count >= 2 {
                                kota = pisah[pisah.count-2].replacingOccurrences(of: "Kabupaten", with: "Kab").trimmingCharacters(in: .whitespacesAndNewlines)
                            }
                        }
                        
                        //let kota = posisi.locality?.replacingOccurrences(of: "Kabupaten", with: "Kab")
                        self.delegate?.getLocation(latitude: String(lat), longitude: String(lon), negara: res.country, provinsi: res.administrativeArea, kota: kota, kec: res.locality, kel: res.subLocality, namaJalan: res.thoroughfare, kodePos: res.postalCode)
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
