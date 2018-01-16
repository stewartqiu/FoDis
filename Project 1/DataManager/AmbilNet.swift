//
//  SyncToSqlite.swift
//  INFO DISDIK
//
//  Created by SchoolDroid on 1/8/18.
//  Copyright © 2018 SchoolDroid. All rights reserved.
//

import Firebase

class AmbilNet {
    
    let reference = Database.database().reference()
    let setting = SettingLite()
    var negara = String()
    var prov = String()
    var kota = String()
    var noHp = String()
    let namaAplikasi = "InfoDisdik"
    
    init () {
        negara = setting.getFiltered(keyfile: SettingKey.negara)!
        prov = setting.getFiltered(keyfile: SettingKey.provinsi)!
        kota = setting.getFiltered(keyfile: SettingKey.kota)!
        noHp = setting.getFiltered(keyfile: SettingKey.noHp)!
    }
    
    static func hpList (noHp : String, completion : ((String)->())?) {
        let reference = Database.database().reference().child("Penduduk/HPList/\(noHp)")
        reference.observeSingleEvent(of: .value) { (snapshot) in
            if let action = completion {
                if snapshot.exists() {
                    action(snapshot.value as! String)
                } else {
                    action(String())
                }
            }
        }
    }
    
    static func setting (negara : String , prov : String , kota : String , noHp : String, completion : ((Bool)->())?) {
        let setting = SettingLite()
        let reference = Database.database().reference().child("Penduduk").child(negara).child(prov).child(kota).child(noHp).child("Aplikasi").child("InfoDisdik").child("Setting")
        reference.observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.exists(){
             if let value = snapshot.value as? [String:String] {
                if let id = value["PersID"]{
                    let _ = setting.insertData(keyfile: SettingKey.id, value: id)
                }
                if let noHp = value["NomorHP"]{
                    let _ = setting.insertData(keyfile: SettingKey.noHp, value: noHp)
                }
                if let nama = value["Nama"]{
                    let _ = setting.insertData(keyfile: SettingKey.nama, value: nama)
                }
                if let negara = value["Negara"]{
                    let _ = setting.insertData(keyfile: SettingKey.negara, value: negara)
                }
                if let provinsi = value["Prov"]{
                    let _ = setting.insertData(keyfile: SettingKey.provinsi, value: provinsi)
                }
                if let kota = value["Kab"]{
                    let _ = setting.insertData(keyfile: SettingKey.kota, value: kota)
                }
                if let pin = value["PinPersonal"]{
                    let _ = setting.insertData(keyfile: SettingKey.pin, value: pin)
                }
                if let lat = value["Latitude"]{
                    let _ = setting.insertData(keyfile: SettingKey.lat, value: lat)
                }
                if let long = value["Longitude"]{
                    let _ = setting.insertData(keyfile: SettingKey.long, value: long)
                }
            }
                
                let reference = Database.database().reference().child("Penduduk").child(negara).child(prov).child(kota).child(noHp).child("Data").child("Profile").child("Foto")
                reference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                    if snapshot.exists(){
                        let value = snapshot.value as! String
                        let _ = setting.insertData(keyfile: SettingKey.foto, value: value)
                        if let action = completion {
                            action(true)
                        }
                    } else {
                        let _ = setting.insertData(keyfile: SettingKey.foto, value: "")
                        if let action = completion {
                            action(true)
                        }
                    }
                })
            } else {
                if let action = completion {
                    action(false)
                }
            }
        
        }
        
        //foto
        
    }
    
    static func lokasiPenduduk(negara : String , prov : String , kota : String , nohp : String, completion : ((Lokasi)->())?){
        let ref =  Database.database().reference().child("Penduduk").child(negara).child(prov).child(kota).child(nohp).child("Data").child("Lokasi")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                let value = snapshot.value as! [String:String]
                
                let lokasi = Lokasi()
                if let alamat = value["Alamat"] {
                    lokasi.alamat = alamat
                }
                if let kota = value["Kab"] {
                    lokasi.kota = kota
                }
                if let kodepos = value["KodePos"] {
                    lokasi.kodepos = kodepos
                }
                if let lat = value["Latitude"] {
                    lokasi.latitude = lat
                }
                if let long = value["Longitude"] {
                    lokasi.longitude = long
                }
                if let negara = value["Negara"] {
                    lokasi.negara = negara
                }
                if let prov = value["Prov"] {
                    lokasi.provinsi = prov
                }
                
                if let action = completion {
                    action(lokasi)
                }
            } else {
                if let action = completion {
                    action(Lokasi())
                }
            }
            
        }
    }
    
    
    func grupPath(completion : ((String) -> ())?){
        let ref = reference.child("\(namaAplikasi)/\(noHp)")
        ref.observe(.childAdded) { (snapshot) in
            let key = snapshot.key
            let pathGrup = snapshot.value as! String
            
            let _ = PathGrupLite().insertData(keyfile: key, value: pathGrup)
            
            if let action = completion{
                action(pathGrup)
            }
        }
        print("read")
    }
    
    func grupChangeListener(pathGrup : String, completion: (()->())?) {
        let ref = self.reference.child("\(pathGrup)")
        ref.observe(.childChanged) { (snapshot) in
            
            print("Changed")
            
            let key = snapshot.key
            
            //print(snapshot.key)
            //print(snapshot.value)
            
            //MARK:- KELOMPOK DATA
            
            if key == "Data" {
                let value = snapshot.value as! [String:String]
                
                var adminList = "", beritaAkhir = "" , deskripsi = "" , foto = "" , idGrup = "" , idKetua = "" , jumlahAnggota = "" , jumlahBerita = "" , namaGrup = "" , namaKetua = "" , pinGrup = "" , status = "" , tanggalBuat = "" , lastFoto = ""
                if let adminval = value["AdminList"] {
                    adminList = adminval
                }
                if let beritaAkhirVal = value["BeritaAkhir"] {
                    beritaAkhir = beritaAkhirVal
                }
                if let deskripsiVal = value["DeskripsiGrup"] {
                    deskripsi = deskripsiVal
                }
                if let fotoVal = value["FotoGrup"]{
                    foto = fotoVal
                }
                if let idGrupVal = value["IDGrup"]{
                    idGrup = idGrupVal
                }
                if let idKetuaVal = value["IDKetua"]{
                    idKetua = idKetuaVal
                }
                if let jumlahAnggotaVal = value["JlhAnggota"]{
                    jumlahAnggota = jumlahAnggotaVal
                }
                if let jumlahBeritaVal = value["JlhBerita"]{
                    jumlahBerita = jumlahBeritaVal
                }
                if let namaGrupVal = value["NamaGrup"]{
                    namaGrup = namaGrupVal
                }
                if let namaKetuaVal = value["NamaKetua"]{
                    namaKetua = namaKetuaVal
                }
                if let pinGrupVal = value["PinGrup"]{
                    pinGrup = pinGrupVal
                }
                if let statusVal = value["Status"]{
                    status = statusVal
                }
                if let tanggalBuatVal = value["TglBuat"]{
                    tanggalBuat = tanggalBuatVal
                }
                if let lastFotoVal = value["LastFoto"]{
                    lastFoto = lastFotoVal
                }
                
                let pathPisah = pathGrup.components(separatedBy: "/")
                let negaraKel = pathPisah[1]
                let provKel = pathPisah[2]
                let kotaKel = pathPisah[3]
                
                let _ = KelompokLite().simpanData(idKelompok: idGrup, namaKelompok: namaGrup, deskripsiKelompok: deskripsi, tanggalBuat: tanggalBuat, idKetua: idKetua, namaKetua: namaKetua, admin: adminList, beritaAkhir: beritaAkhir, foto: foto, pin: pinGrup, status: status, jumlahBerita: jumlahBerita, lastFoto: lastFoto, jumlahAnggota: jumlahAnggota, negara: negaraKel, provinsi: provKel, kota: kotaKel)
            }
                
                //MARK:- KELOMPOK ANGGOTA DATA
                
            else if key == "Anggota" {
                let children = snapshot.children
                while let res = children.nextObject() as? DataSnapshot {
                    let value = res.value as! [String:String]
                    
                    var addedBy = "", allowedPin = "", hpAnggota = "", idGrup = "", idLink = "" , namaAnggota = "", pathFoto = "" , permission = "", promotedBy = "" , removedBy = "" , tglInvite = ""
                    
                    if let addedByVal = value["AddedBy"]{
                        addedBy = addedByVal
                    }
                    if let allowedPinVal = value["AllowedPin"] {
                        allowedPin = allowedPinVal
                    }
                    if let hpAnggotaVal = value["HPAnggota"] {
                        hpAnggota = hpAnggotaVal
                    }
                    if let idGrupVal = value["IDGrup"] {
                        idGrup = idGrupVal
                    }
                    if let idLinkVal = value["IDLink"] {
                        idLink = idLinkVal
                    }
                    if let namaAnggotaVal = value["NamaAnggota"] {
                        namaAnggota = namaAnggotaVal
                    }
                    if let pathFotoVal = value["PathFoto"] {
                        pathFoto = pathFotoVal
                    }
                    if let permissionVal = value["Permission"] {
                        permission = permissionVal
                    }
                    if let promotedByVal = value["PromotedBy"] {
                        promotedBy = promotedByVal
                    }
                    if let removedByVal = value["RemovedBy"] {
                        removedBy = removedByVal
                    }
                    if let tglInviteVal = value["TglInvite"] {
                        tglInvite = tglInviteVal
                    }
                    
                    let _ = AnggotaLite().simpanData(idLink: idLink, idGrup: idGrup, hpAnggota: hpAnggota, namaAnggota: namaAnggota, permission: permission, addedBy: addedBy, removedBy: removedBy, promotedBy: promotedBy, pathFoto: pathFoto, allowedPin: allowedPin, tglInvite: tglInvite)
                }
            }
                
                //MARK:- KELOMPOK BERITA DATA
                
            else if key == "Berita" {
                let children = snapshot.children
                while let snap = children.nextObject() as? DataSnapshot{
                    let child = snap.children
                    while let res = child.nextObject() as? DataSnapshot{
                        let key = res.key
                        
                        //MARK:- DATA
                        
                        if key == "Data" {
                            let value = res.value as! [String:String]
                            
                            var created = "" , createdBy = "" , idBerita = "" , idGrup = "" , judul = "" , kataKunci = "", publish = "", published = "", tanggal = "", totLike = "", totView = "", unpublished = ""
                            
                            if let createdVal = value["Created"]{
                                created = createdVal
                            }
                            if let createdByVal = value["CreatedBy"]{
                                createdBy = createdByVal
                            }
                            if let idBeritaVal = value["IDBerita"]{
                                idBerita = idBeritaVal
                            }
                            if let idGrupVal = value["IDGrup"]{
                                idGrup = idGrupVal
                            }
                            if let judulVal = value["Judul"]{
                                judul = judulVal
                            }
                            if let kataKunciVal = value["KataKunci"]{
                                kataKunci = kataKunciVal
                            }
                            if let publishVal = value["Publish"]{
                                publish = publishVal
                            }
                            if let publishedVal = value["Published"]{
                                published = publishedVal
                            }
                            if let tanggalVal = value["Tanggal"]{
                                tanggal = tanggalVal
                            }
                            if let totLikeVal = value["TotLike"]{
                                totLike = totLikeVal
                            }
                            if let totViewVal = value["TotView"]{
                                totView = totViewVal
                            }
                            if let unpublishedVal = value["UnPublished"]{
                                unpublished = unpublishedVal
                            }
                            
                            let _ = BeritaLite().simpanData(idBerita: idBerita, idGrup: idGrup, judul: judul, kataKunci: kataKunci, created: created, createdBy: createdBy, publish: publish, published: published, tanggal: tanggal, totLike: totLike, totView: totView, unpublished: unpublished)
                            
                        }
                            
                        else if key == "Isi" {
                            let children = res.children
                            while let resChild = children.nextObject() as? DataSnapshot{
                                let value = resChild.value as! [String:String]
                                
                                var berita = "" , fileUrl = "" , foto = "" , idBerita = "" , idIsi = ""
                                
                                if let beritaVal = value["Berita"]{
                                    berita = beritaVal
                                }
                                if let fileUrlVal = value["FileURL"]{
                                    fileUrl = fileUrlVal
                                }
                                if let fotoVal = value["Foto"]{
                                    foto = fotoVal
                                }
                                if let idBeritaVal = value["IDBerita"]{
                                    idBerita = idBeritaVal
                                }
                                if let idIsiVal = value["IDIsi"]{
                                    idIsi = idIsiVal
                                }
                                
                                let _ = IsiBeritaLite().simpanData(idIsi: idIsi, idBerita: idBerita, berita: berita, foto: foto, fileUrl: fileUrl)
                            }
                        }
                        
                        else if key == "View" {
                            let children = res.children
                            while let resChild = children.nextObject() as? DataSnapshot{
                                let value = resChild.value as! [String:String]
                                
                                var hpAnggota = "" , idBerita = "" , idView = "" , like = "" , tglLike = "" , tglView = ""
                                
                                if let hpAnggotaVal = value["HPAnggota"]{
                                    hpAnggota = hpAnggotaVal
                                }
                                if let idBeritaVal = value["IDBerita"]{
                                    idBerita = idBeritaVal
                                }
                                if let idViewVal = value["IDView"]{
                                    idView = idViewVal
                                }
                                if let likeVal = value["Like"]{
                                    like = likeVal
                                }
                                if let tglLikeVal = value["tglLike"]{
                                    tglLike = tglLikeVal
                                }
                                if let tglViewVal = value["tglView"]{
                                    tglView = tglViewVal
                                }
                                
                                let _ = ViewBeritaLite().simpanData(idView: idView, idBerita: idBerita, hpAnggota: hpAnggota, tglView: tglView, like: like, tglLike: tglLike)
                            }
                            
                        }
                        
                        
                        
                    }
                }
                
            }
            
            if let action = completion {
                action()
            }
        }
    }
    
    
    
    
    func grupAddedListener(pathGrup : String , completion: (()->())?){
        let ref = self.reference.child("\(pathGrup)")
        ref.observe(.childAdded) { (snapshot) in
            
            print ("Added")
            
            let key = snapshot.key
            
            //print(snapshot.key)
            //print(snapshot.value)
            
            //MARK:- KELOMPOK DATA
            
            if key == "Data" {
                let value = snapshot.value as! [String:String]
                
                var adminList = "", beritaAkhir = "" , deskripsi = "" , foto = "" , idGrup = "" , idKetua = "" , jumlahAnggota = "" , jumlahBerita = "" , namaGrup = "" , namaKetua = "" , pinGrup = "" , status = "" , tanggalBuat = "" , lastFoto = ""
                if let adminval = value["AdminList"] {
                    adminList = adminval
                }
                if let beritaAkhirVal = value["BeritaAkhir"] {
                    beritaAkhir = beritaAkhirVal
                }
                if let deskripsiVal = value["DeskripsiGrup"] {
                    deskripsi = deskripsiVal
                }
                if let fotoVal = value["FotoGrup"]{
                    foto = fotoVal
                }
                if let idGrupVal = value["IDGrup"]{
                    idGrup = idGrupVal
                }
                if let idKetuaVal = value["IDKetua"]{
                    idKetua = idKetuaVal
                }
                if let jumlahAnggotaVal = value["JlhAnggota"]{
                    jumlahAnggota = jumlahAnggotaVal
                }
                if let jumlahBeritaVal = value["JlhBerita"]{
                    jumlahBerita = jumlahBeritaVal
                }
                if let namaGrupVal = value["NamaGrup"]{
                    namaGrup = namaGrupVal
                }
                if let namaKetuaVal = value["NamaKetua"]{
                    namaKetua = namaKetuaVal
                }
                if let pinGrupVal = value["PinGrup"]{
                    pinGrup = pinGrupVal
                }
                if let statusVal = value["Status"]{
                    status = statusVal
                }
                if let tanggalBuatVal = value["TglBuat"]{
                    tanggalBuat = tanggalBuatVal
                }
                if let lastFotoVal = value["LastFoto"]{
                    lastFoto = lastFotoVal
                }
                
                let pathPisah = pathGrup.components(separatedBy: "/")
                let negaraKel = pathPisah[1]
                let provKel = pathPisah[2]
                let kotaKel = pathPisah[3]
                
                let _ = KelompokLite().simpanData(idKelompok: idGrup, namaKelompok: namaGrup, deskripsiKelompok: deskripsi, tanggalBuat: tanggalBuat, idKetua: idKetua, namaKetua: namaKetua, admin: adminList, beritaAkhir: beritaAkhir, foto: foto, pin: pinGrup, status: status, jumlahBerita: jumlahBerita, lastFoto: lastFoto, jumlahAnggota: jumlahAnggota, negara: negaraKel, provinsi: provKel, kota: kotaKel)
            }
                
            //MARK:- KELOMPOK ANGGOTA DATA
                
            else if key == "Anggota" {
                let children = snapshot.children
                while let res = children.nextObject() as? DataSnapshot {
                    let value = res.value as! [String:String]
                    
                    var addedBy = "", allowedPin = "", hpAnggota = "", idGrup = "", idLink = "" , namaAnggota = "", pathFoto = "" , permission = "", promotedBy = "" , removedBy = "" , tglInvite = ""
                    
                    if let addedByVal = value["AddedBy"]{
                        addedBy = addedByVal
                    }
                    if let allowedPinVal = value["AllowedPin"] {
                        allowedPin = allowedPinVal
                    }
                    if let hpAnggotaVal = value["HPAnggota"] {
                        hpAnggota = hpAnggotaVal
                    }
                    if let idGrupVal = value["IDGrup"] {
                        idGrup = idGrupVal
                    }
                    if let idLinkVal = value["IDLink"] {
                        idLink = idLinkVal
                    }
                    if let namaAnggotaVal = value["NamaAnggota"] {
                        namaAnggota = namaAnggotaVal
                    }
                    if let pathFotoVal = value["PathFoto"] {
                        pathFoto = pathFotoVal
                    }
                    if let permissionVal = value["Permission"] {
                        permission = permissionVal
                    }
                    if let promotedByVal = value["PromotedBy"] {
                        promotedBy = promotedByVal
                    }
                    if let removedByVal = value["RemovedBy"] {
                        removedBy = removedByVal
                    }
                    if let tglInviteVal = value["TglInvite"] {
                        tglInvite = tglInviteVal
                    }
                    
                    let _ = AnggotaLite().simpanData(idLink: idLink, idGrup: idGrup, hpAnggota: hpAnggota, namaAnggota: namaAnggota, permission: permission, addedBy: addedBy, removedBy: removedBy, promotedBy: promotedBy, pathFoto: pathFoto, allowedPin: allowedPin, tglInvite: tglInvite)
                }
            }
            
            //MARK:- KELOMPOK BERITA DATA
            
            else if key == "Berita" {
                let children = snapshot.children
                while let snap = children.nextObject() as? DataSnapshot{
                    let child = snap.children
                    while let res = child.nextObject() as? DataSnapshot{
                        let key = res.key
                        
                        //MARK:- DATA
                        
                        if key == "Data" {
                            let value = res.value as! [String:String]
                            
                            var created = "" , createdBy = "" , idBerita = "" , idGrup = "" , judul = "" , kataKunci = "", publish = "", published = "", tanggal = "", totLike = "", totView = "", unpublished = ""
                            
                            if let createdVal = value["Created"]{
                                created = createdVal
                            }
                            if let createdByVal = value["CreatedBy"]{
                                createdBy = createdByVal
                            }
                            if let idBeritaVal = value["IDBerita"]{
                                idBerita = idBeritaVal
                            }
                            if let idGrupVal = value["IDGrup"]{
                                idGrup = idGrupVal
                            }
                            if let judulVal = value["Judul"]{
                                judul = judulVal
                            }
                            if let kataKunciVal = value["KataKunci"]{
                                kataKunci = kataKunciVal
                            }
                            if let publishVal = value["Publish"]{
                                publish = publishVal
                            }
                            if let publishedVal = value["Published"]{
                                published = publishedVal
                            }
                            if let tanggalVal = value["Tanggal"]{
                                tanggal = tanggalVal
                            }
                            if let totLikeVal = value["TotLike"]{
                                totLike = totLikeVal
                            }
                            if let totViewVal = value["TotView"]{
                                totView = totViewVal
                            }
                            if let unpublishedVal = value["UnPublished"]{
                                unpublished = unpublishedVal
                            }
                            
                            let _ = BeritaLite().simpanData(idBerita: idBerita, idGrup: idGrup, judul: judul, kataKunci: kataKunci, created: created, createdBy: createdBy, publish: publish, published: published, tanggal: tanggal, totLike: totLike, totView: totView, unpublished: unpublished)
                            
                        }
                        
                        else if key == "Isi" {
                            let children = res.children
                            while let resChild = children.nextObject() as? DataSnapshot{
                                let value = resChild.value as! [String:String]
                                
                                var berita = "" , fileUrl = "" , foto = "" , idBerita = "" , idIsi = ""
                                
                                if let beritaVal = value["Berita"]{
                                    berita = beritaVal
                                }
                                if let fileUrlVal = value["FileURL"]{
                                    fileUrl = fileUrlVal
                                }
                                if let fotoVal = value["Foto"]{
                                    foto = fotoVal
                                }
                                if let idBeritaVal = value["IDBerita"]{
                                    idBerita = idBeritaVal
                                }
                                if let idIsiVal = value["IDIsi"]{
                                    idIsi = idIsiVal
                                }
                                
                                let _ = IsiBeritaLite().simpanData(idIsi: idIsi, idBerita: idBerita, berita: berita, foto: foto, fileUrl: fileUrl)
                            
                            }
                        }
                        
                        else if key == "View" {
                            let children = res.children
                            while let resChild = children.nextObject() as? DataSnapshot{
                                let value = resChild.value as! [String:String]
                                
                                var hpAnggota = "" , idBerita = "" , idView = "" , like = "" , tglLike = "" , tglView = ""
                                
                                if let hpAnggotaVal = value["HPAnggota"]{
                                    hpAnggota = hpAnggotaVal
                                }
                                if let idBeritaVal = value["IDBerita"]{
                                    idBerita = idBeritaVal
                                }
                                if let idViewVal = value["IDView"]{
                                    idView = idViewVal
                                }
                                if let likeVal = value["Like"]{
                                    like = likeVal
                                }
                                if let tglLikeVal = value["tglLike"]{
                                    tglLike = tglLikeVal
                                }
                                if let tglViewVal = value["tglView"]{
                                    tglView = tglViewVal
                                }
                                
                                let _ = ViewBeritaLite().simpanData(idView: idView, idBerita: idBerita, hpAnggota: hpAnggota, tglView: tglView, like: like, tglLike: tglLike)
                            }
                        }
                    }
                }
                
            }
            
            if let action = completion {
                action()
            }
            
        }
    }
    
    func anggotaRemovedListener(pathGrup : String , completion : (()->())?) {
        let ref = self.reference.child("\(pathGrup)/Anggota")
        ref.observe(.childRemoved) { (snapshot) in

            if snapshot.exists() {
                print("Anggota Removed")
                let value = snapshot.value as! [String:String]
                if let idLink = value["IDLink"] {
                    let _ = AnggotaLite().deleteData(idLink: idLink)
                }
            }
            
            if let action = completion {
                action()
            }
        }
        
    }
    
    func grupPathRemovedListener(completion : (()->())?) {
        
        let ref = reference.child("\(namaAplikasi)/\(noHp)")
        ref.observe(.childRemoved) { (snapshot) in
            
            if snapshot.exists() {
                print("Path Grup Removed")
                let idGrup = snapshot.key
                let _ = KelompokLite().deleteData(idKelompok: idGrup)
            }
            
            if let action = completion {
                action()
            }
            
        }
        
    }
    
}
