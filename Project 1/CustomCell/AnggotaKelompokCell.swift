//
//  AnggotaKelompokCell.swift
//  Project 1
//
//  Created by SchoolDroid on 12/18/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import UIKit

class AnggotaKelompokCell: UITableViewCell {
    
    @IBOutlet weak var anggotaImage: UIImageView!
    @IBOutlet weak var namaAnggotaLabel: UILabel!
    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var likeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        anggotaImage.layer.cornerRadius = anggotaImage.frame.height / 2
    }

}
