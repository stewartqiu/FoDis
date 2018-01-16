//
//  Transformator.swift
//  Project 1
//
//  Created by SchoolDroid on 12/15/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import Contacts

class Transformator {
    
    static func arrayToStringSeparatorOmega (stringArray : [String]) -> String {
        var value = String()
        
        for string in stringArray {
            value = value + "\(string)Ω"
        }
        
        return String(value.dropLast())
    }
    
    static func stringToArraySeparatorOmega (string : String) -> [String] {
        return string.components(separatedBy: "Ω")
    }
    
    static func arrayToStringSeparatorSlash(stringArray : [String]) -> String {
        
        var value = String()
        
        for string in stringArray {
            value = value + "\(string)/"
        }
        
        return String(value.dropLast())
    }
    
    static func stringToArraySeparatorSlash(string : String) -> [String]{
        
        return string.components(separatedBy: "/")
        
    }
    
    static func getNumberFromContactObj (contact : CNContact) -> String {
        return (contact.phoneNumbers[0].value).value(forKey: "digits") as! String
    }
    
    static func getRandomNumber (length : Int) -> String {
        
        var string = ""
        
        for _ in 1 ... length {
            string = string + String(arc4random_uniform(10))
        }
        
        return string
    }
    
    static func randomString(length: Int) -> String {
        
        let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    static func getNow (format : String) -> String {
        
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        let today = formatter.string(from: date)
        
        return today
        
    }
    
    static func cekPeranAnggota (permission : String) -> String{
        
        if permission == "1111000000" {
            return PeranAnggota.ketua
        }
        else if permission == "1100000000" {
            return PeranAnggota.admin
        }else {
            return PeranAnggota.anggota
        }
        
    }
    
}
