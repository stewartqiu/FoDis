//
//  ViewBeritaLite.swift
//  INFO DISDIK
//
//  Created by SchoolDroid on 1/13/18.
//  Copyright © 2018 SchoolDroid. All rights reserved.
//

import SQLite

class ViewBeritaLite {
    
    var database = DatabaseLite.connection!
    
    init() {
    }
    
    let namaTabel = Table("viewBerita")
    let id_key = Expression<Int>("id")
    let idView_Key = Expression<String>("idView")
    let idBerita_key = Expression<String>("idBerita")
    let hpAnggota_key = Expression<String>("hpAnggota")
    let tglView_key = Expression<String>("tglView")
    let like_key = Expression<String>("like")
    let tglLike_key = Expression<String>("tglLike")
    
    func createTable () -> Bool {
        
        let createTable = self.namaTabel.create { (table) in
            table.column(self.id_key, primaryKey: true)
            table.column(self.idView_Key)
            table.column(self.idBerita_key)
            table.column(self.hpAnggota_key)
            table.column(self.tglView_key)
            table.column(self.like_key)
            table.column(self.tglLike_key)
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
    
    func simpanData (idView : String , idBerita : String , hpAnggota : String , tglView : String, like : String , tglLike : String) -> Bool {
        
        let _ = createTable()
        
        let res = getFiltered(key: self.idView_Key, value: idView)
        
        if res.isEmpty{
            let insertData = self.namaTabel.insert(self.idView_Key <- idView ,
                                                        self.idBerita_key <- idBerita ,
                                                        self.hpAnggota_key <- hpAnggota ,
                                                        self.tglView_key <- tglView ,
                                                        self.like_key <- like,
                                                        self.tglLike_key <- tglLike)
            
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
            
            let data = self.namaTabel.filter(self.idView_Key == idView)
            
            let update = data.update(self.idView_Key <- idView ,
                                     self.idBerita_key <- idBerita ,
                                     self.hpAnggota_key <- hpAnggota ,
                                     self.tglView_key <- tglView ,
                                     self.like_key <- like,
                                     self.tglLike_key <- tglLike)
            
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
    
    func deleteData (idView : String) -> Bool{
        let data = self.namaTabel.filter(self.idView_Key == idView)
        let deleteData = data.delete()
        do {
            try self.database.run(deleteData)
            return true
        } catch {
            print("Error : \(error)")
            return false
        }
    }
    
    func getData() -> [ViewBerita] {
        do {
            let data = try self.database.prepare(self.namaTabel)
            var result = [ViewBerita]()
            for res in data {
                let viewBerita = ViewBerita()
                viewBerita.idView = res[self.idView_Key]
                viewBerita.idBerita = res[self.idBerita_key]
                viewBerita.hpAnggota = res[self.hpAnggota_key]
                viewBerita.tglView = res[self.tglView_key]
                viewBerita.like = res[self.like_key]
                viewBerita.tglLike = res[self.tglLike_key]
                
                result.append(viewBerita)
            }
            return result
        } catch {
            print(error)
            return [ViewBerita]()
        }
    }
    
    func getFiltered(key : Expression<String> , value : String) -> [ViewBerita] {
        let filter = self.namaTabel.filter(key == value)
        do{
            let data = try self.database.prepare(filter)
            
            var result = [ViewBerita]()
            for res in data {
                let viewBerita = ViewBerita()
                viewBerita.idView = res[self.idView_Key]
                viewBerita.idBerita = res[self.idBerita_key]
                viewBerita.hpAnggota = res[self.hpAnggota_key]
                viewBerita.tglView = res[self.tglView_key]
                viewBerita.like = res[self.like_key]
                viewBerita.tglLike = res[self.tglLike_key]
                
                result.append(viewBerita)
            }
            return result
        } catch {
            print("Error : \(error)")
            return [ViewBerita]()
        }
    }
    
    func deleteAll () {
        do{
            try database.run(namaTabel.delete())
        }
        catch{
            print("error \(error)")
        }
    }
    
    
}
