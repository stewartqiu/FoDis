//
//  STool.swift
//  INFO DISDIK
//
//  Created by SchoolDroid on 12/23/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import Photos
import PhotosUI

class STool {
    
    static func fetchContacts () -> [CNContact]{
        
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),CNContactPhoneNumbersKey] as! [CNKeyDescriptor]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        var contacts = [CNContact]()
        
        fetchRequest.mutableObjects = false
        fetchRequest.unifyResults = true
        fetchRequest.sortOrder = .userDefault
        
        let contactStoreID = CNContactStore().defaultContainerIdentifier()
        print("\(contactStoreID)")
        
        do {
            
            try CNContactStore().enumerateContacts(with: fetchRequest) { (contact, stop) -> Void in
                contacts.append(contact)
            }
            
        } catch let e as NSError {
            print(e.localizedDescription)
        }
        
        return contacts
        
    }
    
    static func openDocumentPicker (sender: UIViewController) {
        // Protocol UIDocumentPickerViewController
        let documentPicker = UIDocumentPickerViewController(documentTypes: [], in: .import)
        sender.present(documentPicker, animated: true, completion: nil)
    }
    
    static func openKamera (sender: UIViewController , editable : Bool) {
        // Protocol UIImagePickerControllerDelegate & UINavigationControllerDelegate
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = sender as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        if editable {
            imagePicker.allowsEditing = true
        } else {
            imagePicker.allowsEditing = false
        }
        imagePicker.sourceType = .camera
        sender.present(imagePicker, animated: true, completion: nil)
    }
    
    static func openPhotoLibrary(sender: UIViewController , editable : Bool) {
        // Protocol UIImagePickerControllerDelegate & UINavigationControllerDelegate
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = sender as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        if editable {
            imagePicker.allowsEditing = true
        } else {
            imagePicker.allowsEditing = false
        }
        imagePicker.sourceType = .photoLibrary
        sender.present(imagePicker, animated: true, completion: nil)
    }
    
    static func fetchLastImage(completion: ( _ localIdentifier: String?) -> Void)
    {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if (fetchResult.firstObject != nil)
        {
            let lastImageAsset: PHAsset = fetchResult.firstObject!
            completion(lastImageAsset.localIdentifier)
        }
        else
        {
            completion(nil)
        }
    }
    
    
}
