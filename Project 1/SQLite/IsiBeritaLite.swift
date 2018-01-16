//
//  IsiBeritaLite.swift
//  INFO DISDIK
//
//  Created by SchoolDroid on 1/3/18.
//  Copyright © 2018 SchoolDroid. All rights reserved.
//

import SQLite

class IsiBeritaLite {
    
    var database = DatabaseLite.connection!
    
    init() {}
    
    let isiBeritaTabel = Table("isiBerita")
    let id_key = Expression<Int>("id")
    let idIsi_Key = Expression<String>("idIsi")
    let idBerita_key = Expression<String>("idBerita")
    let berita_key = Expression<String>("berita")
    let foto_key = Expression<String>("foto")
    let fileUrl_key = Expression<String>("fileUrl")

    func createTable () -> Bool {
        
        let createTable = self.isiBeritaTabel.create { (table) in
            table.column(self.id_key, primaryKey: true)
            table.column(self.idIsi_Key)
            table.column(self.idBerita_key)
            table.column(self.berita_key)
            table.column(self.foto_key)
            table.column(self.fileUrl_key)
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
    
    
    func simpanData (idIsi : String , idBerita : String , berita : String , foto : String, fileUrl : String) -> Bool {               // MARK : CHANGE
        
        let _ = createTable()
        
        let res = getFiltered(key: self.idIsi_Key, value: idIsi)
        
        if res.isEmpty{
            let insertData = self.isiBeritaTabel.insert(self.idIsi_Key <- idIsi ,
                                                        self.idBerita_key <- idBerita ,
                                                        self.berita_key <- berita ,
                                                        self.foto_key <- foto ,
                                                        self.fileUrl_key <- fileUrl)
            
            do{
                try self.database.run(insertData)
                print("New")
                return true
            } catch {
                print("Error : \(error)")
                return false
            }
        }
            
        else {
            
            let data = self.isiBeritaTabel.filter(self.idIsi_Key == idIsi)
            
            let update = data.update(self.idIsi_Key <- idIsi ,
                                     self.idBerita_key <- idBerita ,
                                     self.berita_key <- berita ,
                                     self.foto_key <- foto ,
                                     self.fileUrl_key <- fileUrl)
            
            do {
                try self.database.run(update)
                print("Update")
                return true
            }
            catch {
                print("Error : \(error)")
                return false
            }
            
        }

    }
    
    func deleteData (idIsi : String) -> Bool{
        let data = self.isiBeritaTabel.filter(self.idIsi_Key == idIsi)
        let deleteData = data.delete()
        do {
            try self.database.run(deleteData)
            return true
        } catch {
            print("Error : \(error)")
            return false
        }
    }
    
    func getData() -> [IsiBerita] {
        do {
            let data = try self.database.prepare(self.isiBeritaTabel)
            var result = [IsiBerita]()
            for res in data {
                let isiBerita = IsiBerita()
                isiBerita.berita = res[self.berita_key]
                isiBerita.fileUrl = res[self.fileUrl_key]
                isiBerita.foto = res[self.foto_key]
                isiBerita.idIsi = res[self.idIsi_Key]
                isiBerita.idBerita = res[self.idBerita_key]
                
                result.append(isiBerita)
            }
            return result
        } catch {
            print(error)
            return [IsiBerita]()
        }
    }
    
    func getFiltered(key : Expression<String> , value : String) -> [IsiBerita] {
        let filter = self.isiBeritaTabel.filter(key == value)
        do{
            let data = try self.database.prepare(filter)
            
            var result = [IsiBerita]()
            for res in data {
                let isiBerita = IsiBerita()
                isiBerita.berita = res[self.berita_key]
                isiBerita.fileUrl = res[self.fileUrl_key]
                isiBerita.foto = res[self.foto_key]
                isiBerita.idIsi = res[self.idIsi_Key]
                isiBerita.idBerita = res[self.idBerita_key]
                
                result.append(isiBerita)
            }
            return result
        } catch {
            print("Error : \(error)")
            return [IsiBerita]()
        }
    }
    
    func deleteAll () {
        do{
            try database.run(isiBeritaTabel.delete())
        }
        catch{
            print("error \(error)")
        }
    }
    
    
}
