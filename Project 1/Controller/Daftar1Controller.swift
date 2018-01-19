//
//  Daftar1Controller.swift
//  Project 1
//
//  Created by SchoolDroid on 12/4/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseAuth

class Daftar1Controller: UIViewController , UITextFieldDelegate, GpsDelegate {
   
    @IBOutlet weak var tungguSmsImage: UIImageView!
    @IBOutlet weak var masukkanKodeImage: UIImageView!
    @IBOutlet weak var nomorHpTextField: UITextField!
    @IBOutlet weak var kodeVerifikasiTextField: UITextField!
    @IBOutlet weak var kirimUlangBtn: UIButton!
    @IBOutlet weak var verifikasiBtn: UIButton!
    @IBOutlet weak var kirimKodeBtn: UIButton!
    
    var lat = ""
    var long = ""
    var negara = ""
    var prov = ""
    var kota = ""
    var kec = ""
    var kel = ""
    var alamat = ""
    var kodePos = ""
    var path = ""
    var noHp1 = ""
    var adaDataPenduduk = false
    
    var gps : GPS?
    
    var verificationId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissController))
        
        gps = GPS(viewController: self)
        gps!.delegate = self
    }
    
    //MARK:- OVERRIDE
    
    override func viewWillDisappear(_ animated: Bool) {
        gps!.stop()
    }
    
    func getLocation(latitude: String?, longitude: String?, negara: String?, provinsi: String?, kota: String?, kec: String? , kel: String?, namaJalan: String?, kodePos: String?) {
        
        if latitude != nil { self.lat = latitude!}
        if longitude != nil { self.long = longitude!}
        if negara != nil { self.negara = negara!}
        if provinsi != nil { self.prov = provinsi!}
        if kota != nil {self.kota = kota!}
        if let kec = kec {self.kec = kec}
        if let kel = kel {self.kel = kel}
        if namaJalan != nil {self.alamat = namaJalan!}
        if kodePos != nil { self.kodePos = kodePos!}
        
        print("\(self.negara)_\(self.prov)_\(self.kota)_\(self.kec)_\(self.kel)_\(self.alamat)_\(self.kodePos)")
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
                target.noHpToSinkron = self.noHp1
                target.adaDataPenduduk = self.adaDataPenduduk
            }
        }
    }
    
    
    //MARK:- ACTION
    
    @IBAction func kirimKodeAction(_ sender: Any) {
        if lat.isEmpty || long.isEmpty {
            gps = GPS(viewController: self)
            gps!.delegate = self
            
            let alert = UIAlertController(title: "Lokasi", message: "Maaf, kami tidak bisa mendapatkan Negara dan Kota anda. Mohon coba lagi.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
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
            } else if !noHp.contains("+") {
                alert.title = "Harap sertakan kode negara anda"
                present(alert, animated: true, completion: nil)
            } else {
              
                let alert = UIAlertController(title: "Apakah nomor handphone anda sudah benar?", message: "Kode Verifikasi akan kami kirim ke nomor\n\(noHp)", preferredStyle: .alert)
                let batalAction = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
                let yaAction = UIAlertAction(title: "Ya", style: .default, handler: { (_) in
                    self.doAuth(noHp: noHp)
                })

                alert.addAction(yaAction); alert.addAction(batalAction)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func kirimUlangAction(_ sender: Any) {
        self.tungguSmsImage.image = #imageLiteral(resourceName: "not_selected_send_code")
        
        self.nomorHpTextField.isEnabled = true
        self.nomorHpTextField.becomeFirstResponder()
        self.kirimKodeBtn.isHidden = false
        self.kodeVerifikasiTextField.isHidden = true
        self.verifikasiBtn.isHidden = true
        self.kirimUlangBtn.isHidden = true
    }
    
    @IBAction func verifikasiAction(_ sender: Any) {
        let verificationCode = kodeVerifikasiTextField.text!
        
        if verificationCode.isEmpty {
            let alert = UIAlertController(title: nil, message: "Masukkan kode verifikasi", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
        } else {
           let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: verificationCode)
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.black)
            Auth.auth().signIn(with: credential) { (user, error) in
                SVProgressHUD.dismiss()
                if let error = error {
                    print("Error \(error)")
                    SVProgressHUD.showError(withStatus: "Kode Verifikasi yang dimasukkan salah")
                } else {
                    print("Verification Success")
                    
                    let noHp = user!.phoneNumber!
                    let userId = user!.uid
                    
                    self.successAuth(noHp: noHp, userId: userId)

                }
            }
        }
    }
    
    
    //MARK:- FUNCTION
    
    @objc func dismissController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func doAuth (noHp : String) {
        PhoneAuthProvider.provider().verifyPhoneNumber(noHp, uiDelegate: nil, completion: { (verificationID, error) in
            if let error = error {
                print("Error \(error)")
                let alert = UIAlertController(title: nil, message: "Maaf, terjadi kesalahan. Mohon coba kembali", preferredStyle: .alert)
                let batalAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(batalAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.verificationId = verificationID!
                
                self.tungguSmsImage.image = #imageLiteral(resourceName: "selected_send_code")
                
                self.nomorHpTextField.isEnabled = false
                self.kirimKodeBtn.isHidden = true
                self.kodeVerifikasiTextField.isHidden = false
                self.verifikasiBtn.isHidden = false
                self.kirimUlangBtn.isHidden = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 60.0, execute: {
                    self.kirimUlangBtn.isHidden = false
                })
            }
        })
    }
    
    func successAuth (noHp : String , userId : String) {
        self.masukkanKodeImage.image = #imageLiteral(resourceName: "selected_enter_code")
        if !self.lat.isEmpty && !self.long.isEmpty {
            self.gps!.stop()
            
            DummyData.clear()
            
            let noHpFix = noHp.replacingOccurrences(of: "+", with: "")
            SVProgressHUD.show(withStatus: "Memuat halaman")
            SVProgressHUD.setDefaultMaskType(.black)
            AmbilNet.hpList(noHp: noHpFix, completion: { (path) in
                if path.isEmpty {
                    Simpan.hpList(noHp: noHpFix, negara: self.negara, provinsi: self.prov, kota: self.kota)
                    Simpan.pendudukLokasi(noHp: noHpFix, negara: self.negara, prov: self.prov, kab: self.kota, kec: self.kec, kel: self.kel, kodepos: self.kodePos, alamat: self.alamat, lat: self.lat, long: self.long)
                    Simpan.pendudukProfile(negara: self.negara, prov: self.prov, kota: self.kota, noHp: noHpFix, persId: userId, email: "", fbId: "", foto: "", nama: "", password: "", pin: Transformator.randomString(length: 6), tanggalJoin: Transformator.getNow(format: "dd-MM-yyyy HH:mm:ss"))
                    self.adaDataPenduduk = false
                } else {
                    self.path = path
                    self.noHp1 = noHpFix
                    self.adaDataPenduduk = true
                }
                
                let _ = SettingLite().insertData(keyfile: SettingKey.isTest, value: "0")
                
                self.performSegue(withIdentifier: "toProfil", sender: self)
                SVProgressHUD.dismiss()
            })
        }
    }
    
    
    
}
