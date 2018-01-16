//
//  KontakLite.swift
//  Project 1
//
//  Created by SchoolDroid on 12/15/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import SQLite

class AnggotaLite {

    var database = DatabaseLite.connection!
    
    init() {
    }
    
    let namaTable = Table("Anggota")
    let id = Expression<Int>("id")
    let idLink = Expression<String>("idLink")
    let idGrup = Expression<String>("idGrup")
    let hpAnggota = Expression<String>("HpAnggota")
    let namaAnggota = Expression<String>("NamaAnggota")
    let permission = Expression<String>("Permission")
    let addedBy = Expression<String>("AddedBy")
    let removedBy = Expression<String>("RemovedBy")
    let promotedBy = Expression<String>("PromotedBy")
    let pathFoto = Expression<String>("PathFoto")
    let allowedPin = Expression<String>("AllowedPin")
    let tglInvite = Expression<String>("tglInvite")
    
    func createTable () -> Bool {
        
        let createTable = self.namaTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.idLink)
            table.column(self.idGrup)
            table.column(self.hpAnggota)
            table.column(self.namaAnggota)
            table.column(self.permission)
            table.column(self.addedBy)
            table.column(self.removedBy)
            table.column(self.promotedBy)
            table.column(self.pathFoto)
            table.column(self.allowedPin)
            table.column(self.tglInvite)
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
    
    
    func simpanData (idLink : String , idGrup : String , hpAnggota : String , namaAnggota : String , permission : String , addedBy : String , removedBy : String , promotedBy : String , pathFoto : String , allowedPin : String , tglInvite : String) -> Bool {               // MARK : CHANGE
        
        let _ = createTable()
        
        let res = getFiltered(key: self.idLink, value: idLink)
        
        if res.isEmpty {
        
            let insertData = self.namaTable.insert(self.idLink <- idLink,
                                                   self.idGrup <- idGrup,
                                                   self.hpAnggota <- hpAnggota,
                                                   self.namaAnggota <- namaAnggota,
                                                   self.permission <- permission,
                                                   self.addedBy <- addedBy,
                                                   self.removedBy <- removedBy,
                                                   self.promotedBy <- promotedBy,
                                                   self.pathFoto <- pathFoto,
                                                   self.allowedPin <- allowedPin,
                                                   self.tglInvite <- tglInvite)
        
            do{
                try self.database.run(insertData)
                return true
            } catch {
                print("Error : \(error)")
                return false
            }
        }
        
        else {
             let data = self.namaTable.filter(self.idLink == idLink)
            
            let update = data.update(self.idLink <- idLink,
                                     self.idGrup <- idGrup,
                                     self.hpAnggota <- hpAnggota,
                                     self.namaAnggota <- namaAnggota,
                                     self.permission <- permission,
                                     self.addedBy <- addedBy,
                                     self.removedBy <- removedBy,
                                     self.promotedBy <- promotedBy,
                                     self.pathFoto <- pathFoto,
                                     self.allowedPin <- allowedPin,
                                     self.tglInvite <- tglInvite)
            
            do {
                try self.database.run(update)
                return true
            }
            catch{
                print("Error : \(error)")
                return false
            }
        }
        
    }
    
    
    func deleteData (idLink : String) -> Bool{
        
        let data = self.namaTable.filter(self.idLink == idLink)
        let deleteData = data.delete()
        do {
            try self.database.run(deleteData)
            return true
        } catch {
            print("Error : \(error)")
            return false
        }
        
    }
    
    func getData() -> [Anggota] {
        
        do {
            let data = try self.database.prepare(self.namaTable)               // MARK : CHANGE
            var result = [Anggota]()
            for res in data {
                let anggota = Anggota()
                anggota.idLink = res[self.idLink]
                anggota.idGrup = res[self.idGrup]
                anggota.hpAnggota = res[self.hpAnggota]
                anggota.namaAnggota = res[self.namaAnggota]
                anggota.permission = res[self.permission]
                anggota.addedBy = res[self.addedBy]
                anggota.removedBy = res[self.removedBy]
                anggota.promotedBy = res[self.promotedBy]
                anggota.pathFoto = res[self.pathFoto]
                anggota.allowedPin = res[self.allowedPin]
                anggota.tglInvite = res[self.tglInvite]

                
                result.append(anggota)    // MARK : CHANGE
            }
            return result
        } catch {
            print(error)
            return [Anggota]()
        }
        
    }
    
    func getFiltered(key : Expression<String> , value : String) -> [Anggota] {
        
        let filter = self.namaTable.filter(key == value)
        do{
            let data = try self.database.prepare(filter)
            
            var result = [Anggota]()
            for res in data {
                let anggota = Anggota()
                anggota.idLink = res[self.idLink]
                anggota.idGrup = res[self.idGrup]
                anggota.hpAnggota = res[self.hpAnggota]
                anggota.namaAnggota = res[self.namaAnggota]
                anggota.permission = res[self.permission]
                anggota.addedBy = res[self.addedBy]
                anggota.removedBy = res[self.removedBy]
                anggota.promotedBy = res[self.promotedBy]
                anggota.pathFoto = res[self.pathFoto]
                anggota.allowedPin = res[self.allowedPin]
                anggota.tglInvite = res[self.tglInvite]
                
                result.append(anggota)
            }
            
            return result
        } catch {
            print("Error : \(error)")
            return [Anggota]()
        }
    }
    
    func deleteAll () {
        do{
            try database.run(namaTable.delete())
        }
        catch{
            print("error \(error)")
        }
    }
    
}
