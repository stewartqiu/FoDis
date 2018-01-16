//
//  ListContactTCell.swift
//  Project 1
//
//  Created by SchoolDroid on 12/15/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import UIKit

class ListContactTCell: UITableViewCell {

    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactNumberLabel: UILabel!
    @IBOutlet weak var jadikanAdminButton: UIButton!
    @IBOutlet weak var removeAdminView: UIView!
    @IBOutlet weak var removeAdminButton: UIButton!
    @IBOutlet weak var ketuaLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
