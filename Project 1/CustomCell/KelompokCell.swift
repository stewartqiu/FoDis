//
//  KelompokCell.swift
//  Project 1
//
//  Created by SchoolDroid on 12/7/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import UIKit

class KelompokCell: UITableViewCell {
 
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var namaKelompokLabel: UILabel!
    @IBOutlet weak var jumlahAnggotaLabel: UILabel!
    @IBOutlet weak var deskripsiLabel: UILabel!
    @IBOutlet weak var jumlahAnggotaView: UIView!
    @IBOutlet weak var jumlahAnggotaButton: UIButton!
    @IBOutlet weak var kelompokProfilButton: UIButton!
    @IBOutlet weak var tanggalKelompok: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImage.layer.cornerRadius = iconImage.frame.height / 2
    }

}
