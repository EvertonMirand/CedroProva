//
//  LoginTableViewCell.swift
//  CedroProva
//
//  Created by Everton Miranda Vitório on 01/05/18.
//  Copyright © 2018 Everton Miranda Vitório. All rights reserved.
//

import UIKit

class LoginTableViewCell: UITableViewCell {

    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var bannerImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
