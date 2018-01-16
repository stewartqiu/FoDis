//
//  DummyData.swift
//  INFO DISDIK
//
//  Created by SchoolDroid on 1/7/18.
//  Copyright © 2018 SchoolDroid. All rights reserved.
//

import UIKit

class DummyData{
    
    static func inject(){
        
        let noHp = "1111"
        let nama = "Hamizar Iskandar (Contoh)"
        let negara = "Indonesia"
        let provinsi = "Riau"
        let kota = "Pekanbaru"
        
        let setting = SettingLite()
        let _ = setting.insertData(keyfile: SettingKey.isTest, value: "1")
        let _ = setting.insertData(keyfile: SettingKey.noHp, value: noHp)
        let _ = setting.insertData(keyfile: SettingKey.nama, value: nama)
        let _ = setting.insertData(keyfile: SettingKey.negara, value: negara)
        let _ = setting.insertData(keyfile: SettingKey.provinsi, value: provinsi)
        let _ = setting.insertData(keyfile: SettingKey.kota, value: kota)
        
        let idGrup = "\(noHp)0001"
        let idBerita = "\(idGrup)000001"
      
        let _ = KelompokLite().simpanData(idKelompok: idGrup, namaKelompok: "Kadis Pendidikan Kab/Kota", deskripsiKelompok: "Seputar Informasi untuk Kepala Dinas Pendidikan Kab/Kota", tanggalBuat: "18-07-2017", idKetua: noHp, namaKetua: nama, admin: nama, beritaAkhir: "11110001000001", foto: "", pin: "", status: "", jumlahBerita: "2", lastFoto: "", jumlahAnggota: "5", negara: negara, provinsi: provinsi, kota: kota)
        
        let _ = AnggotaLite().simpanData(idLink: "111100010001", idGrup: idGrup, hpAnggota: "2133", namaAnggota: "Bambang Wahyudi (Contoh)", permission: "0000000000", addedBy: noHp, removedBy: "", promotedBy: "", pathFoto: "", allowedPin: "", tglInvite: "")
        
        let _ = AnggotaLite().simpanData(idLink: "111100010000", idGrup: idGrup, hpAnggota: noHp, namaAnggota: nama, permission: "1111000000", addedBy: noHp, removedBy: "", promotedBy: "", pathFoto: "", allowedPin: "", tglInvite: "")
        
        let _ = AnggotaLite().simpanData(idLink: "111100010002", idGrup: idGrup, hpAnggota: "2533", namaAnggota: "Fitri Aulia Utami (Contoh)", permission: "0000000000", addedBy: noHp, removedBy: "", promotedBy: "", pathFoto: "", allowedPin: "", tglInvite: "")
        
        let _ = AnggotaLite().simpanData(idLink: "111100010003", idGrup: idGrup, hpAnggota: "2433", namaAnggota: "Nur Yulyawati (Contoh)", permission: "0000000000", addedBy: noHp, removedBy: "", promotedBy: "", pathFoto: "", allowedPin: "", tglInvite: "")
        
        let _ = AnggotaLite().simpanData(idLink: "111100010004", idGrup: idGrup, hpAnggota: "2633", namaAnggota: "Kasdi Usman (Contoh)", permission: "0000000000", addedBy: noHp, removedBy: "", promotedBy: "", pathFoto: "", allowedPin: "", tglInvite: "")
        
        let _ = BeritaLite().simpanData(idBerita: "11110001000001", idGrup: idGrup, judul: "Pertanggung Jawaban Dana BOS Triwulan II Tahun 2017", kataKunci: "#BOS #KertasKerja", created: "18-07-2017", createdBy: noHp, publish: "", published: "", tanggal: "18-07-2017", totLike: "", totView: "", unpublished: "")
        
        let _ = IsiBeritaLite().simpanData(idIsi: "11110001000001001", idBerita: "11110001000001", berita: "Kertas Kerja BOS Triwulan II Tahun 2017 dan v2t1 SD dapat diunduh di bawah ini :", foto: "", fileUrl: "")
        
        let _ = IsiBeritaLite().simpanData(idIsi: "11110001000001002", idBerita: "11110001000001", berita: "", foto: "KertasKerja.png", fileUrl: "kertaskerja.gambarsampel")
        
        let _ = IsiBeritaLite().simpanData(idIsi: "11110001000001003", idBerita: "11110001000001", berita: "Kami juga menyertakan Tutorial BOS. Semoga Bermanfaat", foto: "", fileUrl: "")
        
    }
    
    static func clear () {
        SettingLite().deleteAll()
        KelompokLite().deleteAll()
        AnggotaLite().deleteAll()
        BeritaLite().deleteAll()
        IsiBeritaLite().deleteAll()
    }

    
}
