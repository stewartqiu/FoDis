//
//  Daftar1Controller.swift
//  Project 1
//
//  Created by SchoolDroid on 12/4/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import UIKit
import SVProgressHUD

class Daftar1Controller: UIViewController , UITextFieldDelegate , GpsDelegate {
   
    @IBOutlet weak var tungguSmsImage: UIImageView!
    @IBOutlet weak var masukkanKodeImage: UIImageView!
    @IBOutlet weak var nomorHpTextField: UITextField!
   
    var lat = String()
    var long = String()
    var negara = String()
    var prov = String()
    var kota = String()
    var alamat = String()
    var kodePos = String()
    var path = String()
    var noHp = String()
    var adaDataPenduduk = false
    
    var gps : GPS?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SVProgressHUD.show(withStatus: "Memuat halaman")
        //SVProgressHUD.setDefaultMaskType(.black)
        
        gps = GPS(viewController: self)
        gps!.delegate = self
    }
    
    //MARK:- OVERRIDE
    func getLocation(latitude: String?, longitude: String?, negara: String?, provinsi: String?, kota: String?, namaJalan: String?, kodePos: String?) {
        //SVProgressHUD.dismiss()
        
        if latitude != nil { self.lat = latitude!}
        if longitude != nil { self.long = longitude!}
        if negara != nil { self.negara = negara!}
        if provinsi != nil { self.prov = provinsi!}
        if kota != nil {self.kota = kota!}
        if namaJalan != nil {self.alamat = namaJalan!}
        if kodePos != nil { self.kodePos = kodePos!}
        
        print("Needitnow")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfil" {
            let destination = segue.destination as! UINavigationController
            let target = destination.topViewController as! ProfileController
            if !adaDataPenduduk{
                target.lat = self.lat
                target.long = self.long
                target.negara = self.negara
                target.prov = self.prov
                target.kota = self.kota
                target.alamat = self.alamat
                target.kodePos = self.kodePos
                target.adaDataPenduduk = self.adaDataPenduduk
            } else {
                target.pathSinkronData = self.path
                target.noHpToSinkron = self.noHp
                target.adaDataPenduduk = self.adaDataPenduduk
            }
        }
    }
    
    
    //MARK:- ACTION
    
    @IBAction func kirimKodeAction(_ sender: Any) {
        
        if lat.isEmpty || long.isEmpty {
            gps = GPS(viewController: self)
            gps!.delegate = self
        }
        else {
            
            let noHp = self.nomorHpTextField.text!
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: .default) { (_) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
        
            if noHp.count <= 2 {
                alert.title = "Nomor handphone tidak valid"
                present(alert, animated: true, completion: nil)
                print("tes")
            } else if !noHp.contains("+") {
                alert.title = "Harap sertakan kode negara anda"
                present(alert, animated: true, completion: nil)
            } else {
              
                let alert = UIAlertController(title: "Apakah nomor handphone anda sudah benar ?", message: "Kode Verifikasi akan kami kirim ke nomor\n\(noHp)", preferredStyle: .alert)
                let batalAction = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
                let yaAction = UIAlertAction(title: "Ya", style: .default, handler: { (_) in
                    
                    //TODO:- AUTH
                    self.tungguSmsImage.image = #imageLiteral(resourceName: "selected_send_code")
                    
                    if !self.lat.isEmpty && !self.long.isEmpty {
                        self.gps!.stop()
                        
                        DummyData.clear()
                        
                        let noHpFix = noHp.replacingOccurrences(of: "+", with: "")
                        SVProgressHUD.show(withStatus: "Memuat halaman")
                        SVProgressHUD.setDefaultMaskType(.black)
                        AmbilNet.hpList(noHp: noHpFix, completion: { (path) in
                            if path.isEmpty {
                                Simpan.hpList(noHp: noHpFix, negara: self.negara, provinsi: self.prov, kota: self.kota)
                                Simpan.pendudukLokasi(noHp: noHpFix, negara: self.negara, prov: self.prov, kab: self.kota, kec: "", kel: "", kodepos: self.kodePos, alamat: self.alamat, lat: self.lat, long: self.long)
                                Simpan.pendudukProfile(negara: self.negara, prov: self.prov, kota: self.kota, noHp: noHpFix, persId: "persid", email: "", fbId: "", foto: "", nama: "", password: "", pin: Transformator.randomString(length: 6), tanggalJoin: Transformator.getNow(format: "dd-MM-yyyy HH:mm:ss"))
                                self.adaDataPenduduk = false
                            } else {
                                self.path = path
                                self.noHp = noHpFix
                                self.adaDataPenduduk = true
                            }
                            
                            let _ = SettingLite().insertData(keyfile: SettingKey.isTest, value: "0")
                            
                            self.performSegue(withIdentifier: "toProfil", sender: self)
                            SVProgressHUD.dismiss()
                            
                        })
                    }
                })
                
                alert.addAction(yaAction); alert.addAction(batalAction)
                present(alert, animated: true, completion: nil)
    
            }
        }
    }
    
    
    
    
}
