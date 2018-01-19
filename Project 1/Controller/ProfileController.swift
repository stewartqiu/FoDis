//
//  ProfileController.swift
//  Project 1
//
//  Created by SchoolDroid on 12/4/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import UIKit
import SVProgressHUD
import Kingfisher

class ProfileController: UIViewController , UINavigationControllerDelegate , UIImagePickerControllerDelegate{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var namaTextField: UITextField!
    @IBOutlet weak var btnLanjut: UIButton!
    
    var selectedImage : UIImage?
    var lat = String()
    var long = String()
    var negara = String()
    var prov = String()
    var kota = String()
    var alamat = String()
    var kodePos = String()
    
    var adaDataPenduduk = false
    var pathSinkronData = String()
    var noHpToSinkron = String()
    
    var adaDataInfoDisdik = false
    var negaraAmbil = String()
    var provAmbil = String()
    var kotaAmbil = String()
    var kodeposAmbil = String()
    var latitudeAmbil = String()
    var longitudeAmbil = String()
    var alamatAmbil = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageViewHandler()
        
        if adaDataPenduduk {
            sinkronData()
        }
        
    }
    
    @IBAction func selesaiPressed(_ sender: Any) {

        let nama = namaTextField.text!
        if nama.count < 1 {
            let alert = UIAlertController(title: "Mohon untuk mengisi nama anda", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            if !adaDataPenduduk { // Daftar baru
                let noHp = SettingLite().getFiltered(keyfile: SettingKey.noHp)!
                Simpan.settingAplikasi(negara: negara, prov: prov, kota: kota, kec: "", kel: "", alamat: alamat, kodepos: kodePos, latitude: lat, longitude: long, persId: "persID", noHp: noHp, nama: nama, pinPersonal: Transformator.randomString(length: 6), tanggalJoin: Transformator.getNow(format: "dd-MM-yyyy HH:mm:ss"))
           
                yangdiUlang(negara: self.negara, prov: self.prov, kota: self.kota, noHp: noHp, nama: nama)
                
            } else if !adaDataInfoDisdik {
                Simpan.settingAplikasi(negara: negaraAmbil, prov: provAmbil, kota: kotaAmbil, kec: "", kel: "", alamat: alamatAmbil, kodepos: kodeposAmbil, latitude: latitudeAmbil, longitude: longitudeAmbil, persId: "persID", noHp: noHpToSinkron, nama: nama, pinPersonal: Transformator.randomString(length: 6), tanggalJoin: Transformator.getNow(format: "dd-MM-yyyy HH:mm:ss"))
                
                self.yangdiUlang(negara: negaraAmbil, prov: provAmbil, kota: kotaAmbil, noHp: noHpToSinkron, nama: nama)
            }
            
            else { // Login saja, data sudah ada
                
                let negara = SettingLite().getFiltered(keyfile: SettingKey.negara)!
                let prov = SettingLite().getFiltered(keyfile: SettingKey.provinsi)!
                let kota = SettingLite().getFiltered(keyfile: SettingKey.kota)!
                let noHp = SettingLite().getFiltered(keyfile: SettingKey.noHp)!
                
                yangdiUlang(negara: negara, prov: prov, kota: kota, noHp: noHp, nama: nama)
                
            }
        }
    }
    
    func yangdiUlang(negara : String , prov : String , kota : String , noHp : String , nama : String) {
        SimpanNet().settingOsList(negara: negara, prov: prov, kota: kota, noHp: noHp, dateTime: Transformator.getNow(format: "dd-MM-yyyy HH:mm:ss"))
        SimpanNet().statistikInfoDisdik(negara: negara, prov: prov, kota: kota, noHp: noHp, nama: nama, jenisHp: UIDevice().modelName, tanggalWaktu: Transformator.getNow(format: "dd-MM-yyyy HH:mm:ss"))
        Simpan.updateNama(negara: negara, prov: prov, kota: kota, noHp: noHp, nama: nama)
        
        if let image = selectedImage {
            SVProgressHUD.show(withStatus: "Mengunggah foto")
            SVProgressHUD.setDefaultMaskType(.black)
            SimpanNet().uploadImagePenduduk(noHp: noHp, image: image, url: { (url) in
                Simpan.updateFotoUrlPenduduk(negara: negara, prov: prov, kota: kota, noHp: noHp, url: url)
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "toMain", sender: self)
            })
        }
        else {
            performSegue(withIdentifier: "toMain", sender: self)
        }
    }
    
    
    // MARK : - OVERRIDE
     //****************************************************************
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imageURL = info[UIImagePickerControllerImageURL] as! NSURL
        print(imageURL)
        if let image = info[UIImagePickerControllerEditedImage]{
            selectedImage = image as? UIImage
        } else {
            selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.height / 2.0
        btnLanjut.layer.cornerRadius = btnLanjut.frame.height / 2
    }
    
    
    
    // MARK: - ACTION
    //****************************************************************
    
    
    @objc func showAlert () {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAct = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
        let kameraAct = UIAlertAction(title: "Kamera", style: .default) { (_) in
            STool.openKamera(sender: self, editable: true)
        }
        let fotoAct = UIAlertAction(title: "Pilih Foto", style: .default) { (_) in
            STool.openPhotoLibrary(sender: self, editable: true)
        }
        
        alert.addAction(cancelAct)
        alert.addAction(kameraAct)
        alert.addAction(fotoAct)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - FUNCTION
    //****************************************************************

    func imageViewHandler () {
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showAlert)))
    }
    
    func sinkronData(){
        SVProgressHUD.show(withStatus: "Memuat halaman")
        SVProgressHUD.setDefaultMaskType(.black)
        let pathPisah = pathSinkronData.components(separatedBy: "/")
        let negara = pathPisah[0]
        let prov = pathPisah[1]
        let kota = pathPisah[2]
        AmbilNet.setting(negara: negara, prov: prov, kota: kota, noHp: noHpToSinkron) { (get) in
            if get {
                SVProgressHUD.dismiss()
                self.adaDataInfoDisdik = true
                let urlFoto = SettingLite().getFiltered(keyfile: SettingKey.foto)!
                if !urlFoto.isEmpty && urlFoto != "null" {
                    self.imageView.kf.indicatorType = .activity
                    self.imageView.kf.setImage(with: URL(string: urlFoto), placeholder: #imageLiteral(resourceName: "profile_photo_empty"))
                }
                
                let nama = SettingLite().getFiltered(keyfile: SettingKey.nama)!
                self.namaTextField.text = nama
                
            } else {
                AmbilNet.lokasiPenduduk(negara: negara, prov: prov, kota: kota, nohp: self.noHpToSinkron, completion: { (lokasi) in
                    SVProgressHUD.dismiss()
                    self.negaraAmbil = lokasi.negara!
                    self.provAmbil = lokasi.provinsi!
                    self.kotaAmbil = lokasi.kota!
                    self.kodeposAmbil = lokasi.kodepos!
                    self.alamatAmbil = lokasi.alamat!
                    self.latitudeAmbil = lokasi.latitude!
                    self.longitudeAmbil = lokasi.longitude!
                })
                self.adaDataInfoDisdik = false
            }
            
        }
    }
    
    
   
    
    
}
