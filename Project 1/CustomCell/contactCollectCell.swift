//
//  contactCollectCell.swift
//  Project 1
//
//  Created by SchoolDroid on 12/7/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import UIKit

class contactCollectCell: UICollectionViewCell {
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var deletebtn: UIButton!
    
    var controller : BuatKelompokController?
    var anggotaToDelete : Anggota?
    
    @IBAction func deleteAction(_ sender: Any) {
        controller?.deleteAnggota(anggota: anggotaToDelete!)
    }
    
}
