//
//  ArtikelLite.swift
//  Project 1
//
//  Created by SchoolDroid on 12/14/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import Foundation
import SQLite

class BeritaLite {
    
    var database = DatabaseLite.connection!
    
    init() {}
    
    let beritaTable = Table("berita")
    let id_key = Expression<Int>("id")
    let created_key = Expression<String>("created")
    let createdBy_key = Expression<String>("createdBy")
    let idBerita_key = Expression<String>("idBerita")
    let idKelompok_key = Expression<String>("idKelompok")
    let judul_key = Expression<String>("judul")
    let kataKunci_key = Expression<String>("kataKunci")
    let publish_key = Expression<String>("publish")
    let published_key = Expression<String>("published")
    let tanggal_key = Expression<String>("tanggal")
    let totLike_key = Expression<String>("totLike")
    let totView_key = Expression<String>("totView")
    let unpublished_key = Expression<String>("unpublished")
    
    func createTable () -> Bool {
        
        let createTable = self.beritaTable.create { (table) in
            table.column(self.id_key, primaryKey: true)
            table.column(self.created_key)
            table.column(self.createdBy_key)
            table.column(self.idBerita_key)
            table.column(self.idKelompok_key)
            table.column(self.judul_key)
            table.column(self.kataKunci_key)
            table.column(self.publish_key)
            table.column(self.published_key)
            table.column(self.tanggal_key)
            table.column(self.totLike_key)
            table.column(self.totView_key)
            table.column(self.unpublished_key)
        }
        
        do {
            try self.database.run(createTable)
            print("Created Table")
            return true
        } catch {
            print("error \(error)")
            return false
        }
    }
    
    func simpanData (idBerita : String , idGrup : String , judul : String , kataKunci : String, created : String , createdBy : String , publish : String , published : String , tanggal : String , totLike : String , totView : String , unpublished : String) -> Bool {               // MARK : CHANGE
        
        let _ = createTable()
        
        let res = getFiltered(key: self.idBerita_key, value: idBerita)
        
        if res.isEmpty{
            let insertData = self.beritaTable.insert(self.idBerita_key <- idBerita ,
                                                     self.idKelompok_key <- idGrup ,
                                                     self.judul_key <- judul ,
                                                     self.kataKunci_key <- kataKunci ,
                                                     self.created_key <- created,
                                                     self.createdBy_key <- createdBy,
                                                     self.publish_key <- publish,
                                                     self.published_key <- published,
                                                     self.tanggal_key <- tanggal,
                                                     self.totLike_key <- totLike,
                                                     self.totView_key <- totView,
                                                     self.unpublished_key <- unpublished)
            
            do{
                try self.database.run(insertData)
                return true
            } catch {
                print("Error : \(error)")
                return false
            }
        }
        
        else {
            
            let data = self.beritaTable.filter(self.idBerita_key == idBerita)
            
            let update = data.update(self.idBerita_key <- idBerita ,
                                     self.idKelompok_key <- idGrup ,
                                     self.judul_key <- judul ,
                                     self.kataKunci_key <- kataKunci ,
                                     self.created_key <- created,
                                     self.createdBy_key <- createdBy,
                                     self.publish_key <- publish,
                                     self.published_key <- published,
                                     self.tanggal_key <- tanggal,
                                     self.totLike_key <- totLike,
                                     self.totView_key <- totView,
                                     self.unpublished_key <- unpublished)
            
            do {
                try self.database.run(update)
                return true
            }
            catch {
                print("Error : \(error)")
                return false
            }
            
        }
        
        
        
        
    }
    
    func deleteData (idBerita : String) -> Bool{
        
        let data = self.beritaTable.filter(self.idBerita_key == idBerita)
        let deleteData = data.delete()
        do {
            try self.database.run(deleteData)
            return true
        } catch {
            print("Error : \(error)")
            return false
        }
        
    }
    
    func getData() -> [Berita] {
        
        do {
            let data = try self.database.prepare(self.beritaTable)               // MARK : CHANGE
            var result = [Berita]()
            for res in data {
                let berita = Berita()
                berita.created = res[self.created_key]
                berita.createdBy = res[self.createdBy_key]
                berita.idBerita = res[self.idBerita_key]
                berita.idGrup = res[self.idKelompok_key]
                berita.judul = res[self.judul_key]
                berita.kataKunci = res[self.kataKunci_key]
                berita.publish = res[self.publish_key]
                berita.published = res[self.published_key]
                berita.tanggal = res[self.tanggal_key]
                berita.totLike = res[self.totLike_key]
                berita.totView = res[self.totView_key]
                berita.unpublished = res[self.unpublished_key]
                
                result.append(berita)    // MARK : CHANGE
            }
            return result
        } catch {
            print(error)
            return [Berita]()
        }
        
    }
    
    func getFiltered(key : Expression<String> , value : String) -> [Berita] {
        
        let filter = self.beritaTable.filter(key == value)
        do{
            let data = try self.database.prepare(filter)
            
            var result = [Berita]()
            for res in data {
                let berita = Berita()
                berita.created = res[self.created_key]
                berita.createdBy = res[self.createdBy_key]
                berita.idBerita = res[self.idBerita_key]
                berita.idGrup = res[self.idKelompok_key]
                berita.judul = res[self.judul_key]
                berita.kataKunci = res[self.kataKunci_key]
                berita.publish = res[self.publish_key]
                berita.published = res[self.published_key]
                berita.tanggal = res[self.tanggal_key]
                berita.totLike = res[self.totLike_key]
                berita.totView = res[self.totView_key]
                berita.unpublished = res[self.unpublished_key]
                
                result.append(berita)    // MARK : CHANGE
            }
            return result
        } catch {
            print("Error : \(error)")
            return [Berita]()
        }
    }
    
    func deleteAll () {
        do{
            try database.run(beritaTable.delete())
        }
        catch{
            print("error \(error)")
        }
    }
}
