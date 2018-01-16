//
//  ArtikelCell.swift
//  Project 1
//
//  Created by SchoolDroid on 12/14/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import UIKit

class ArtikelCell: UITableViewCell {
    @IBOutlet weak var judulLabel: UILabel!
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var lampiranPenulisLabel: UILabel!
    @IBOutlet weak var jlhViewLabel: UILabel!
    @IBOutlet weak var jlhLikeLabel: UILabel!
    @IBOutlet weak var tanggalLabel: UILabel!
    @IBOutlet weak var belumTerbitLabel: UILabel!
    @IBOutlet weak var viewlikeView: UIView!
    @IBOutlet weak var imageLampiran: UIImageView!
    @IBOutlet weak var isiLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        belumTerbitLabel.layer.cornerRadius = belumTerbitLabel.frame.height / 2
    }

  

}
