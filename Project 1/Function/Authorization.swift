//
//  ToSetting.swift
//  Project 1
//
//  Created by SchoolDroid on 12/15/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class Authorization {
    
    static func toSetting (sender : UIViewController ,title : String , message : String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Setting", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Batalkan", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        sender.present(alertController, animated: true, completion: nil)
    }

}
