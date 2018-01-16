//
//  SimpanNet.swift
//  INFO DISDIK
//
//  Created by SchoolDroid on 12/22/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import Firebase

class SimpanNet {
    
    let reference = Database.database().reference()
    let namaAplikasi = "InfoDisdik"
    let jenisOS = "iOS"
    
    init () {
        
    }
    
//     Simpan setting nohp , negara , provinsi , kota , lat, long waktu simpan PendudukLokasi
//     Simpan setting persid , nama , pin waktu simpan PendudukProfile
    
    static func hpList (noHp : String , negara : String , prov : String , kota : String){
        let ref = Database.database().reference().child("Penduduk/HPList")
        let value = [noHp : "\(negara)/\(prov)/\(kota)"]
        
        ref.updateChildValues(value)
        
    }
    
    static func pendudukLokasi (noHp : String, negara : String, prov: String, kab : String , kec : String , kel : String, kodepos : String, alamat : String , lat : String , long : String , completion : ((Bool)->(Void))?) {
        
        let reference = Database.database().reference()
        
        let ref = reference.child("Penduduk").child(negara).child(prov).child(kab).child(noHp).child("Data").child("Lokasi")
        let value = ["Alamat" : alamat ,
                     "Kab" : kab ,
                     "Kec" : kec ,
                     "Kel" : kel ,
                     "KodePos" : kodepos ,
                     "Latitude" : lat ,
                     "Longitude" : long ,
                     "Negara" : negara ,
                     "Prov" : prov]
        
        ref.updateChildValues(value) { (error, ref) in
            if error == nil {
                
                if let action = completion{
                    action(true)
                }
                
            } else {
                if let action = completion{
                    action(false)
                }
            }
        }
    }
    
    func pendudukProfile (negara : String , prov : String , kota : String , noHp : String , persId : String, email : String , fbId : String , foto : String , nama : String , password : String, pin : String, tanggalJoin : String, completion : ((Bool)->(Void))?) {
        
        let ref = reference.child("Penduduk").child(negara).child(prov).child(kota).child(noHp).child("Data").child("Profile")
        let value = ["Email" : email ,
                     "FbID" : fbId ,
                     "Foto" : foto ,
                     "Nama" : nama ,
                     "NomorHP" : noHp ,
                     "Password" : password ,
                     "PersID" : persId ,
                     "PinPersonal" : pin ,
                     "Tanggal_Join" : tanggalJoin]
        
        ref.updateChildValues(value) { (error, ref) in
            if error == nil {
                
                if let action = completion{
                    action(true)
                }
                
            } else {
                if let action = completion{
                    action(false)
                }
            }
        }
    }
    
    func payment (negara : String , prov : String , kota : String , noHp : String , cara : String , tanggal : String) {
        let ref = reference.child("Penduduk").child(negara).child(prov).child(kota).child(noHp).child("Data").child("Payment")
        let value = ["Cara" : cara,
                     "Tanggal" : tanggal]
        ref.updateChildValues(value)
    }
    
    func settingAplikasi (negara : String , prov : String , kota : String , kec : String , kel : String , alamat : String , kodepos : String , latitude : String , longitude : String , persId : String  , noHp : String , nama : String,  pinPersonal : String , tanggalJoin : String) {
        let ref = reference.child("Penduduk").child(negara).child(prov).child(kota).child(noHp).child("Aplikasi").child(namaAplikasi).child("Setting")
        let value = ["Alamat" : alamat,
                     "Kab" : kota,
                     "Kec" : kec,
                     "Kel" : kel,
                     "KodePos" : kodepos,
                     "Latitude" : latitude,
                     "Longitude" : longitude,
                     "Nama" : nama,
                     "Negara" : negara,
                     "NomorHP" : noHp,
                     "PersID" : persId,
                     "PinPersonal" : pinPersonal,
                     "Prov" : prov,
                     "Tanggal_Join" : tanggalJoin]
        ref.updateChildValues(value)
    }
    
    func statistikInfoDisdik(negara : String , prov : String , kota : String , noHp : String , nama : String , jenisHp : String , tanggalWaktu : String) {
        let ref = reference.child("Statistik").child(negara).child(prov).child(kota).child(namaAplikasi)
        let value = [noHp : "\(nama)_\(jenisOS) \(jenisHp)_\(tanggalWaktu)"]
        ref.updateChildValues(value)
    }
    
    func statistikGrupList(negara : String , prov : String , kota : String , idGrup : String , namaGrup : String , jumlahAnggota : String , jumlahBerita : String){
        let ref = reference.child("Statistik").child(negara).child(prov).child(kota).child("GrupList")
        let value = [idGrup : "\(namaGrup)_\(jumlahAnggota)_\(jumlahBerita)"]
        ref.updateChildValues(value)
    }
    
    func settingOsList (negara : String , prov : String , kota : String , noHp : String , dateTime : String) {
        let ref = reference.child("Setting/OSList/iOS/\(negara)/\(prov)/\(kota)")
        let value = [noHp : dateTime]
        ref.updateChildValues(value)
    }
    
    //TODO: - UPDATE NAMA
    
   func updateNama (negara : String , prov : String , kota : String , noHp : String , nama : String) {
        let ref1 = reference.child("Penduduk").child(negara).child(prov).child(kota).child(noHp).child("Aplikasi").child(namaAplikasi).child("Setting")
        let ref2 = reference.child("Penduduk").child(negara).child(prov).child(kota).child(noHp).child("Data").child("Profile")
        let value = ["Nama" : nama]
        ref1.updateChildValues(value)
        ref2.updateChildValues(value)
    }
    
    //TODO:- UPDATE FOTO URL Penduduk
    
    func updateFotoUrlPenduduk (negara : String , prov : String , kota : String, noHp : String , url : String){
        let ref = reference.child("Penduduk").child(negara).child(prov).child(kota).child(noHp).child("Data").child("Profile")
        let value = ["Foto" : url]
        ref.updateChildValues(value)
    }
    
    
    func updateImageUrlGrup (negara : String , prov : String , kota : String , idGrup : String, url : String) {
        let ref = reference.child("Grup/\(negara)/\(prov)/\(kota)/\(idGrup)/Data")
        let value = ["FotoGrup" : url,
                     "LastFoto" : Transformator.getNow(format: "dd-MM-yyyy HH:mm:ss")]
        ref.updateChildValues(value)
    }
    
    
    func grupData (negara : String , prov : String , kota : String , idGrup : String, adminList : String , beritaAkhir : String , deskripsiGrup : String , fotoGrup : String, idKetua : String , jumlahAnggota : String , jumlahBerita : String , namaGrup : String , namaKetua : String, pinGrup : String , status : String , tanggalBuat : String, lastFoto : String ) {
        
        let ref = reference.child("Grup/\(negara)/\(prov)/\(kota)/\(idGrup)/Data")
        let value = ["AdminList" : adminList ,
                     "BeritaAkhir" : beritaAkhir ,
                     "DeskripsiGrup" : deskripsiGrup ,
                     "FotoGrup" : fotoGrup ,
                     "IDGrup" : idGrup ,
                     "IDKetua" : idKetua ,
                     "JlhAnggota" : jumlahAnggota ,
                     "JlhBerita" : jumlahBerita ,
                     "LastFoto" : lastFoto,
                     "NamaGrup" : namaGrup ,
                     "NamaKetua" : namaKetua ,
                     "PinGrup" : pinGrup ,
                     "Status" : status,
                     "TglBuat" : tanggalBuat]
        ref.updateChildValues(value)
        
    }
    
    func anggota (negara : String , prov : String , kota : String , idLink : String , idGrup : String , hpAnggota : String , addedBy : String , allowedPin : String , namaAnggota : String , pathFoto : String , permission : String , tglInvite : String, promotedBy : String , removedBy : String) {
        
        let ref = reference.child("Grup/\(negara)/\(prov)/\(kota)/\(idGrup)/Anggota/\(hpAnggota)")
        let value = ["AddedBy" : addedBy,
                     "AllowedPin" : allowedPin,
                     "HPAnggota" : hpAnggota,
                     "IDGrup" : idGrup,
                     "IDLink" : idLink,
                     "NamaAnggota" : namaAnggota,
                     "PathFoto" : pathFoto,
                     "Permission" : permission,
                     "TglInvite" : tglInvite,
                     "PromotedBy" : promotedBy,
                     "RemovedBy" : removedBy]
        ref.updateChildValues(value)
        
        infoDisdik(noHp: hpAnggota, idGrup: idGrup, path: "Grup/\(negara)/\(prov)/\(kota)/\(idGrup)")
        
    }
    
    func infoDisdik (noHp : String , idGrup : String , path : String) {
        
        let ref = reference.child("InfoDisdik/\(noHp)")
        let value = [idGrup : path]
        ref.updateChildValues(value)
        
    }
    
    func beritaData (negara : String , prov : String , kota : String , idGrup : String , idBerita : String , created : String , createdBy : String , judul : String , kataKunci : String , publish : String , published : String , tanggal : String , totLike : String , totView : String , unpublished : String) {
        
        let ref = reference.child("Grup/\(negara)/\(prov)/\(kota)/\(idGrup)/Berita/\(idBerita)/Data")
        let value = ["Created" : created ,
                     "CreatedBy" : createdBy ,
                     "IDBerita" : idBerita ,
                     "IDGrup" : idGrup ,
                     "Judul" : judul ,
                     "KataKunci" : kataKunci ,
                     "Publish" : publish ,
                     "Published" : published ,
                     "Tanggal" : tanggal ,
                     "TotLike" : totLike ,
                     "TotView" : totView ,
                     "UnPublished" : unpublished]
        ref.updateChildValues(value)
        
    }
    
    func isiBerita (negara : String , prov : String , kota : String , idGrup : String , idBerita : String , idIsi : String , berita : String , fileUrl : String , foto : String) {
        
        let ref = reference.child("Grup/\(negara)/\(prov)/\(kota)/\(idGrup)/Berita/\(idBerita)/Isi/\(idIsi)")
        let value = ["Berita" : berita,
                     "FileURL" : fileUrl,
                     "Foto" : foto,
                     "IDBerita" : idBerita,
                     "IDIsi" : idIsi]
        ref.updateChildValues(value)
        
    }
    
    func viewBerita (negara : String , prov : String , kota : String , idGrup : String , idBerita : String , idView : String , hpAnggota : String , like : String , tglLike : String , tglView : String) {
        
        let ref = reference.child("Grup/\(negara)/\(prov)/\(kota)/\(idGrup)/Berita/\(idBerita)/View/\(idView)")
        let value = ["HPAnggota" : hpAnggota,
                     "IDBerita" : idBerita,
                     "IDView" : idView,
                     "Like" : like,
                     "tglLike" : tglLike,
                     "tglView" : tglView]
        ref.updateChildValues(value)
        
        
    }
    
    
    func deleteGrupAnggota(negaraKel : String , provKel : String , kotaKel : String , idGrup : String , hpToDelete : String) {
        let ref = reference.child("Grup/\(negaraKel)/\(provKel)/\(kotaKel)/\(idGrup)/Anggota/\(hpToDelete)")
        ref.removeValue()
    }
    
    func deleteGrupPath (idGrup : String , hpToDelete : String) {
        let ref = reference.child("InfoDisdik/\(hpToDelete)/\(idGrup)")
        ref.removeValue()
    }
    
    
    func updateBeritaAkhir (negara : String , prov : String , kota : String , idGrup : String , idBerita : String) {
        let ref = reference.child("Grup/\(negara)/\(prov)/\(kota)/\(idGrup)/Data")
        let value = ["BeritaAkhir" : idBerita]
        ref.updateChildValues(value)
    }
    
   
    
    func uploadImagePenduduk (noHp : String , image : UIImage , url : ((String)->())?) {
        
        let uploadData = UIImageJPEGRepresentation(image, 0.3)
        
        if let data = uploadData {
            let ref = Storage.storage().reference().child("\(namaAplikasi)/Penduduk/\(noHp)_foto.jpg")
            ref.putData(data, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("Error \(error!)")
                    if let url = url {
                        url("")
                    }
                }
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    if let url = url {
                        url(imageUrl)
                    }
                }
            })
        }
    }
    
    func uploadImageKelompok (idGrup : String , image : UIImage , url : ((String)->())?) {
        
        let uploadData = UIImageJPEGRepresentation(image, 0.3)
        
        if let data = uploadData {
            let ref = Storage.storage().reference().child("\(namaAplikasi)/Grup/\(idGrup)_foto.jpg")
            ref.putData(data, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("Error \(error!)")
                    if let url = url {
                        url("")
                    }
                }
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    if let url = url {
                        url(imageUrl)
                    }
                }
            })
        }
        
    }
    
    
    func uploadFotoIsiBerita (negaraKel : String , provKel : String , kotaKel : String , idKelompok : String, namaFoto : String , image : UIImage, url : ((String)->())?) {
        
        let uploadData = UIImageJPEGRepresentation(image, 0.3)
        
        if let data = uploadData {
            let ref = Storage.storage().reference().child("Grup/\(negaraKel)/\(provKel)/\(kotaKel)/\(idKelompok)/\(namaFoto)")
            ref.putData(data, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("Error \(error!)")
                    if let url = url {
                        url("")
                    }
                }
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    if let url = url {
                        url(imageUrl)
                    }
                }
            })
        }
    }
    
    func downloadImage(noHp : String , completion: ((UIImage) -> (Void))?){
        let ref = Storage.storage().reference().child(namaAplikasi).child("Penduduk").child("\(noHp)_foto.jpg")
        ref.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
            let image = UIImage(data: data!)!
            if let action = completion {
                action(image)
            }
        }
    }
    
    
    
   
    
}









