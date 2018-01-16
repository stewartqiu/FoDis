//
//  KelompokLite.swift
//  Project 1
//
//  Created by SchoolDroid on 12/13/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import Foundation
import SQLite

class DatabaseLite {
    static let connection : Connection! = {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("schooldroid").appendingPathExtension("sqlite3")               // MARK : CHANGE
            let database = try Connection(fileUrl.path)
            return database
        } catch {
            return nil
        }
    } ()
}

class KelompokLite {
    
    var database = DatabaseLite.connection!
    
    let kelompokTable = Table("kelompok")
    let id_key = Expression<Int>("id")
    let idKelompok_key = Expression<String>("idKelompok")
    let nama_key = Expression<String>("namaKelompok")
    let deskripsi_key = Expression<String>("deskripsiKelompok")
    let timeStamp_key = Expression<String>("timeStamp")
    let idKetua_key = Expression<String>("idKetuaKelompok")
    let namaKetua_key = Expression<String>("namaKetuaKelompok")
    let admin_key = Expression<String>("adminKelompok")
    let beritaAkhir_key = Expression<String>("beritaAkhir")
    let foto_key = Expression<String>("fotoGrup")
    let lastFoto_key = Expression<String>("lastFoto")
    let pinGrup_key = Expression<String>("pinGrup")
    let status_key = Expression<String>("status")
    let jumlahBerita_key = Expression<String>("jumlahBerita")
    let jumlahAnggota_key = Expression<String>("jumlahAnggota")
    let negara_key = Expression<String>("negara")
    let provinsi_key = Expression<String>("provinsi")
    let kota_key = Expression<String>("kota")
    
    init() {
    }
    
    func createTable () -> Bool {
        
        let createTable = self.kelompokTable.create { (table) in
            table.column(self.id_key, primaryKey: true)
            table.column(self.idKelompok_key)
            table.column(self.nama_key)
            table.column(self.deskripsi_key)
            table.column(self.timeStamp_key)
            table.column(self.idKetua_key)
            table.column(self.namaKetua_key)
            table.column(self.admin_key)
            table.column(self.beritaAkhir_key)
            table.column(self.foto_key)
            table.column(self.pinGrup_key)
            table.column(self.status_key)
            table.column(self.jumlahBerita_key)
            table.column(self.lastFoto_key)
            table.column(self.jumlahAnggota_key)
            table.column(self.negara_key)
            table.column(self.provinsi_key)
            table.column(self.kota_key)
        }
        
        do {
            try self.database.run(createTable)
            print("Created Table")
            return true
        } catch {
            print(error)
            return false
        }
    }

    
    func simpanData (idKelompok : String , namaKelompok : String , deskripsiKelompok : String , tanggalBuat : String , idKetua : String , namaKetua : String , admin : String , beritaAkhir : String, foto : String , pin : String , status : String, jumlahBerita : String , lastFoto : String , jumlahAnggota : String, negara: String , provinsi : String , kota : String) -> Bool {
        
        let _ = createTable()
        
        let res = getFiltered(key: idKelompok_key, value: idKelompok)
        
        if res.isEmpty {
        
            let insertData = self.kelompokTable.insert(self.idKelompok_key <- idKelompok,
                                                       self.nama_key <- namaKelompok,
                                                       self.deskripsi_key <- deskripsiKelompok ,
                                                       self.idKetua_key <- idKetua,
                                                       self.namaKetua_key <- namaKetua ,
                                                       self.timeStamp_key <- tanggalBuat,
                                                       self.admin_key <- admin,
                                                       self.beritaAkhir_key <- beritaAkhir,
                                                       self.foto_key <- foto,
                                                       self.pinGrup_key <- pin,
                                                       self.status_key <- status,
                                                       self.jumlahBerita_key <- jumlahBerita,
                                                       self.lastFoto_key <- lastFoto,
                                                       self.jumlahAnggota_key <- jumlahAnggota,
                                                       self.negara_key <- negara,
                                                       self.provinsi_key <- provinsi,
                                                       self.kota_key <- kota)
        
            do{
                try self.database.run(insertData)
                return true
            } catch {
                print("Error : \(error)")
                return false
            }
        }
        
        else {
            let data = self.kelompokTable.filter(self.idKelompok_key == idKelompok)
            
            let update = data.update(self.idKelompok_key <- idKelompok,
                                     self.nama_key <- namaKelompok,
                                     self.deskripsi_key <- deskripsiKelompok ,
                                     self.idKetua_key <- idKetua,
                                     self.namaKetua_key <- namaKetua ,
                                     self.timeStamp_key <- tanggalBuat,
                                     self.admin_key <- admin,
                                     self.beritaAkhir_key <- beritaAkhir,
                                     self.foto_key <- foto,
                                     self.pinGrup_key <- pin,
                                     self.status_key <- status,
                                     self.jumlahBerita_key <- jumlahBerita,
                                     self.lastFoto_key <- lastFoto,
                                     self.jumlahAnggota_key <- jumlahAnggota,
                                     self.negara_key <- negara,
                                     self.provinsi_key <- provinsi,
                                     self.kota_key <- kota)
            do {
                try self.database.run(update)
                return true
            } catch {
                print("Error : \(error)")
                return false
            }
            
        }
        
    }
    
    
    func deleteData (idKelompok : String) -> Bool{
        
        let data = self.kelompokTable.filter(self.idKelompok_key == idKelompok)
        let deleteData = data.delete()
        do {
            try self.database.run(deleteData)
            return true
        } catch {
            print("Error : \(error)")
            return false
        }
        
    }
    
    func getData() -> [Kelompok] {
        
        do {
            let data = try self.database.prepare(self.kelompokTable)
            
            var result = [Kelompok]()
            for res in data {
                let kelompok = Kelompok()
                kelompok.id = String(res[self.idKelompok_key])
                kelompok.nama = res[self.nama_key]
                kelompok.deskripsi = res[self.deskripsi_key]
                kelompok.idKetua = res[self.idKetua_key]
                kelompok.namaKetua = res[self.namaKetua_key]
                kelompok.admin = res[self.admin_key]
                kelompok.beritaAkhir = res[self.beritaAkhir_key]
                kelompok.foto = res[self.foto_key]
                kelompok.pin = res[self.pinGrup_key]
                kelompok.status = res[self.status_key]
                kelompok.jumlahBerita = res[self.jumlahBerita_key]
                kelompok.timeStamp = res[self.timeStamp_key]
                kelompok.lastFoto = res[self.lastFoto_key]
                kelompok.jumlahAnggota = res[self.jumlahAnggota_key]
                kelompok.negara = res[self.negara_key]
                kelompok.provinsi = res[self.provinsi_key]
                kelompok.kota = res[self.kota_key]
                result.append(kelompok)
            }
            
            return result
        } catch {
            print("Error : \(error)")
            return [Kelompok]()
        }
        
    }
    
    func getFiltered(key : Expression<String> , value : String) -> [Kelompok] {
        
        let filter = self.kelompokTable.filter(key == value)
        do{
            let data = try self.database.prepare(filter)
            
            var result = [Kelompok]()
            for res in data {
                let kelompok = Kelompok()
                kelompok.id = String(res[self.idKelompok_key])
                kelompok.nama = res[self.nama_key]
                kelompok.deskripsi = res[self.deskripsi_key]
                kelompok.idKetua = res[self.idKetua_key]
                kelompok.namaKetua = res[self.namaKetua_key]
                kelompok.admin = res[self.admin_key]
                kelompok.beritaAkhir = res[self.beritaAkhir_key]
                kelompok.foto = res[self.foto_key]
                kelompok.pin = res[self.pinGrup_key]
                kelompok.status = res[self.status_key]
                kelompok.jumlahBerita = res[self.jumlahBerita_key]
                kelompok.timeStamp = res[self.timeStamp_key]
                kelompok.lastFoto = res[self.lastFoto_key]
                kelompok.jumlahAnggota = res[self.jumlahAnggota_key]
                kelompok.negara = res[self.negara_key]
                kelompok.provinsi = res[self.provinsi_key]
                kelompok.kota = res[self.kota_key]
                result.append(kelompok)
            }
            
            return result
        } catch {
            print("Error : \(error)")
            return [Kelompok]()
        }
    }
    
    func deleteAll () {
        do{
            try database.run(kelompokTable.delete())
        }
        catch{
            print("error \(error)")
        }
    }
    
    
    //    func updateData (kelompok : Kelompok) -> Bool{
    //        // MAKE PARAM NIL FOR VALUE THAT DONT WANT TO UPDATED
    //
    //        do {
    //            if let namaFix = kelompok.nama {
    //                let update = data.update(self.nama_key <- namaFix)
    //                try self.database.run(update)
    //            }
    //
    //            if let deskripsiFix = kelompok.deskripsi {
    //                let update = data.update(self.deskripsi_key <- deskripsiFix)
    //                try self.database.run(update)
    //            }
    //
    //            if let pembuatFix = kelompok.idKetua {
    //                let update = data.update(self.idKetua_key <- pembuatFix)
    //                try self.database.run(update)
    //            }
    //
    //            if let namaKetua = kelompok.namaKetua {
    //                let update = data.update(self.namaKetua_key <- namaKetua)
    //                try self.database.run(update)
    //            }
    //
    //            if let anggotaArray = kelompok.anggota {
    //                let anggotaString = Transformator.arrayToStringSeparatorOmega(stringArray: anggotaArray)
    //                let update = data.update(self.anggota_key <- anggotaString)
    //                try self.database.run(update)
    //            }
    //
    //            if let adminArray = kelompok.admin {
    //                let adminString = Transformator.arrayToStringSeparatorOmega(stringArray: adminArray)
    //                let update = data.update(self.admin_key <- adminString)
    //                try self.database.run(update)
    //            }
    //
    //            if let idArtikelArray = kelompok.idArtikel {
    //                let idArtikelString = Transformator.arrayToStringSeparatorOmega(stringArray: idArtikelArray)
    //                let update = data.update(self.idArtikel_key <- idArtikelString)
    //                try self.database.run(update)
    //            }
    //
    //            return true
    //        }
    //        catch {
    //            print("Error : \(error)")
    //            return false
    //        }
    //    }

    
}
