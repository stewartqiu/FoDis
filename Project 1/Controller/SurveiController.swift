//
//  SurveiController.swift
//  INFO DISDIK
//
//  Created by SchoolDroid on 1/15/18.
//  Copyright © 2018 SchoolDroid. All rights reserved.
//

import UIKit
import DLRadioButton

class SurveiController: UIViewController {

    var selected = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func radioBtn(_ sender: DLRadioButton) {
        if sender.tag == 1 {
            selected = "Berbayar"
        } else {
            selected = "Gratis"
        }
    }
    
    

    @IBAction func kirimBtn(_ sender: Any) {
        
        if selected == "" {
            let alert = UIAlertController(title: nil, message: "Mohon pilih salah satu cara penggunaan server", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
        } else {
            let _ = SettingLite().insertData(keyfile: SettingKey.caraPayment, value: selected)
            let _ = SettingLite().insertData(keyfile: SettingKey.tanggalPayment, value: Transformator.getNow(format: "dd-MM-yyyy HH:mm:ss"))
            
            
            if SettingLite().getFiltered(keyfile: SettingKey.isTest) == "0" && SettingLite().getFiltered(keyfile: SettingKey.id) != nil && SettingLite().getFiltered(keyfile: SettingKey.id) != "" {
                SimpanNet().payment(negara: SettingLite().getFiltered(keyfile: SettingKey.negara)! , prov: SettingLite().getFiltered(keyfile: SettingKey.provinsi)!, kota: SettingLite().getFiltered(keyfile: SettingKey.kota)!, noHp: SettingLite().getFiltered(keyfile: SettingKey.noHp)!, cara: selected, tanggal: Transformator.getNow(format: "dd-MM-yyyy HH:mm:ss"))
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    

}
