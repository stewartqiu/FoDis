//
//  Simpan.swift
//  INFO DISDIK
//
//  Created by SchoolDroid on 12/31/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import Foundation

class Simpan {
    

    
    static func hpList (noHp : String , negara : String , provinsi : String , kota : String){
        SimpanNet.hpList(noHp: noHp, negara: negara, prov: provinsi, kota: kota)
    }
    
    
    
    static func pendudukLokasi (noHp : String, negara : String, prov: String, kab : String , kec : String , kel : String, kodepos : String, alamat : String , lat : String , long : String) {
        
        SimpanNet.pendudukLokasi(noHp: noHp, negara: negara, prov: prov, kab: kab, kec: kec, kel: kel, kodepos: kodepos, alamat: alamat, lat: lat, long: long, completion: nil)
        
        let setting = SettingLite()
        
        let _ = setting.insertData(keyfile: SettingKey.noHp, value: noHp)
        let _ = setting.insertData(keyfile: SettingKey.negara, value: negara)
        let _ = setting.insertData(keyfile: SettingKey.provinsi, value: prov)
        let _ = setting.insertData(keyfile: SettingKey.kota, value: kab)
        let _ = setting.insertData(keyfile: SettingKey.lat, value: lat)
        let _ = setting.insertData(keyfile: SettingKey.long, value: long)
    }
    
    
    
    
    static func pendudukProfile (negara : String , prov : String , kota : String , noHp : String , persId : String, email : String , fbId : String , foto : String , nama : String , password : String, pin : String, tanggalJoin : String) {
        
        SimpanNet().pendudukProfile(negara: negara, prov: prov, kota: kota, noHp: noHp, persId: persId, email: email, fbId: fbId, foto: foto, nama: nama, password: password, pin: pin, tanggalJoin: tanggalJoin, completion: nil)
        
        let setting = SettingLite()
        
        let _ = setting.insertData(keyfile: SettingKey.id, value: persId)
        let _ = setting.insertData(keyfile: SettingKey.nama, value: nama)
        let _ = setting.insertData(keyfile: SettingKey.pin, value: pin)
    }
    
    
    
    
    
    static func settingAplikasi(negara : String , prov : String , kota : String , kec : String , kel : String , alamat : String , kodepos : String , latitude : String , longitude : String , persId : String  , noHp : String , nama : String,  pinPersonal : String , tanggalJoin : String) {
        
        SimpanNet().settingAplikasi(negara: negara, prov: prov, kota: kota, kec: kec, kel: kel, alamat: alamat, kodepos: kodepos, latitude: latitude, longitude: longitude, persId: persId, noHp: noHp, nama: nama, pinPersonal: pinPersonal, tanggalJoin: tanggalJoin)
        
        
        let setting = SettingLite()
        
        let _ = setting.insertData(keyfile: SettingKey.id, value: persId)
        let _ = setting.insertData(keyfile: SettingKey.nama, value: nama)
        let _ = setting.insertData(keyfile: SettingKey.pin, value: pinPersonal)
        
    }
    
    
    
    
    
    static func updateNama (negara : String , prov : String , kota : String , noHp : String, nama : String) {
        
        SimpanNet().updateNama(negara: negara, prov: prov, kota: kota, noHp: noHp, nama: nama)
        
        let setting = SettingLite()
        let _ = setting.insertData(keyfile: SettingKey.nama, value: nama)
    }
    
    
    
    
    
    static func updateFotoUrlPenduduk(negara : String , prov : String , kota : String, noHp : String , url : String){
        
        SimpanNet().updateFotoUrlPenduduk(negara: negara, prov: prov, kota: kota, noHp: noHp, url: url)
        
        let setting = SettingLite()
        let _ = setting.insertData(keyfile: SettingKey.foto, value: url)
    }
    
    
    
    
    static func updateImageUrlGrup (negara : String , prov : String , kota : String , idGrup : String, url : String) {
        SimpanNet().updateImageUrlGrup(negara: negara, prov: prov, kota: kota, idGrup: idGrup, url: url)
    }
    
    
    
    
    static func kelompok (isTest : Bool ,negara : String , prov : String , kota : String , idKelompok : String , namaKelompok : String , deskripsiKelompok : String, tanggalBuat : String , idKetua : String , namaKetua : String , admin : String , jumlahAnggota : String , jumlahBerita : String , beritaAkhir : String , fotoGrup : String , pinGrup : String , status : String , lastFoto : String) {
        if !isTest {
            SimpanNet().grupData(negara: negara, prov: prov, kota: kota, idGrup: idKelompok, adminList: admin, beritaAkhir: beritaAkhir, deskripsiGrup: deskripsiKelompok, fotoGrup: fotoGrup, idKetua: idKetua, jumlahAnggota: jumlahAnggota, jumlahBerita: jumlahBerita, namaGrup: namaKelompok, namaKetua: namaKetua, pinGrup: pinGrup, status: status, tanggalBuat: tanggalBuat, lastFoto: lastFoto)
        }
        let _ = KelompokLite().simpanData(idKelompok: idKelompok, namaKelompok: namaKelompok, deskripsiKelompok: deskripsiKelompok, tanggalBuat: tanggalBuat, idKetua: idKetua, namaKetua: namaKetua, admin: admin, beritaAkhir: beritaAkhir, foto: fotoGrup, pin: pinGrup, status: status, jumlahBerita: jumlahBerita, lastFoto: lastFoto, jumlahAnggota: jumlahAnggota, negara: negara, provinsi: prov, kota: kota)
    }
    
    
    
    
    
    static func anggota (isTest : Bool ,negaraKel : String , provKel : String , kotaKel : String , idLink : String , idGrup : String , hpAnggota : String , addedBy : String , allowedPin : String , namaAnggota : String , pathFoto : String , permission : String , tglInvite : String , promotedBy : String , removedBy : String) {
        if !isTest {
            SimpanNet().anggota(negara: negaraKel, prov: provKel, kota: kotaKel, idLink: idLink, idGrup: idGrup, hpAnggota: hpAnggota, addedBy: addedBy, allowedPin: allowedPin, namaAnggota: namaAnggota, pathFoto: pathFoto, permission: permission, tglInvite: tglInvite, promotedBy: promotedBy, removedBy: removedBy)
        }
        let _ = AnggotaLite().simpanData(idLink: idLink, idGrup: idGrup, hpAnggota: hpAnggota, namaAnggota: namaAnggota, permission: permission, addedBy: addedBy, removedBy: removedBy, promotedBy: promotedBy, pathFoto: pathFoto, allowedPin: allowedPin, tglInvite: tglInvite)
    }
    
    
    
    
    
    static func beritaData (isTest : Bool, negaraKel : String , provKel : String , kotaKel : String , idBerita : String , idGrup : String , judul : String , kataKunci : String, created : String , createdBy : String , publish : String , published : String , tanggal : String , totLike : String , totView : String , unpublished : String) {
        if !isTest {
            SimpanNet().beritaData(negara: negaraKel, prov: provKel, kota: kotaKel, idGrup: idGrup, idBerita: idBerita, created: created, createdBy: createdBy, judul: judul, kataKunci: kataKunci, publish: publish, published: published, tanggal: tanggal, totLike: totLike, totView: totView, unpublished: unpublished)
        }
        let _ = BeritaLite().simpanData(idBerita: idBerita, idGrup: idGrup, judul: judul, kataKunci: kataKunci, created: created, createdBy: createdBy, publish: publish, published: published, tanggal: tanggal, totLike: totLike, totView: totView, unpublished: unpublished)
    }
    
    
    
    
    static func isiBerita (isTest : Bool, negara : String , prov : String , kota : String , idGrup : String , idBerita : String , idIsi : String , berita : String , fileUrl : String , foto : String) {
        if !isTest {
            SimpanNet().isiBerita(negara: negara, prov: prov, kota: kota, idGrup: idGrup, idBerita: idBerita, idIsi: idIsi, berita: berita, fileUrl: fileUrl, foto: foto)
        }
        
        let _ = IsiBeritaLite().simpanData(idIsi: idIsi, idBerita: idBerita, berita: berita, foto: foto, fileUrl: fileUrl)
        
    }
    
    
    
    
    static func viewBerita (isTest : Bool , negaraKel : String , provKel : String , kotaKel : String , idGrup : String , idBerita : String , idView : String , hpAnggota : String , like : String , tglLike : String , tglView : String) {
        if !isTest {
            SimpanNet().viewBerita(negara: negaraKel, prov: provKel, kota: kotaKel, idGrup: idGrup, idBerita: idBerita, idView: idView, hpAnggota: hpAnggota, like: like, tglLike: tglLike, tglView: tglView)
        }
        
        let _ = ViewBeritaLite().simpanData(idView: idView, idBerita: idBerita, hpAnggota: hpAnggota, tglView: tglView, like: like, tglLike: tglLike)
    }
    
    
    
    
    static func updateBeritaAkhir (isTest : Bool , negara : String , prov : String , kota : String , idGrup : String , idBerita : String){
        if !isTest {
            SimpanNet().updateBeritaAkhir(negara: negara, prov: prov, kota: kota, idGrup: idGrup, idBerita: idBerita)
        }

        let kelompok = KelompokLite().getFiltered(key: KelompokLite().idKelompok_key, value: idGrup)[0]

        let _ =  KelompokLite().simpanData(idKelompok: kelompok.id!, namaKelompok: kelompok.nama!, deskripsiKelompok: kelompok.deskripsi!, tanggalBuat: kelompok.timeStamp!, idKetua: kelompok.idKetua!, namaKetua: kelompok.namaKetua!, admin: kelompok.admin!, beritaAkhir: idBerita, foto: kelompok.foto!, pin: kelompok.pin!, status: kelompok.status!, jumlahBerita: kelompok.jumlahBerita!, lastFoto: kelompok.id!, jumlahAnggota: kelompok.jumlahAnggota!, negara: kelompok.negara!, provinsi: kelompok.provinsi!, kota: kelompok.kota!)
    }
    
    
    
    static func deleteAnggota (isTest : Bool , negaraKel : String , provKel : String , kotaKel : String , idGrup : String , hpToDelete : String , idLink : String) {
        if !isTest {
            SimpanNet().deleteGrupAnggota(negaraKel: negaraKel, provKel: provKel, kotaKel: kotaKel, idGrup: idGrup, hpToDelete: hpToDelete)
            SimpanNet().deleteGrupPath(idGrup: idGrup, hpToDelete: hpToDelete)
        }
        
        let _ = AnggotaLite().deleteData(idLink: idLink)
    }
    
    
    
    
    static func updateNamaDanFotoOnGrup (grupPath : String , nama : String , url : String){
        let noHp = SettingLite().getFiltered(keyfile: SettingKey.noHp)!
        
        SimpanNet().updateNamaOnGrup(grupPath: grupPath, noHp: noHp, nama: nama)
        SimpanNet().updateFotoUrlOnGrup(grupPath: grupPath, noHp: noHp, url: url)
    }
    
    
}
