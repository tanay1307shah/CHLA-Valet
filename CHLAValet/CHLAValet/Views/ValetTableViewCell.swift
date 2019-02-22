//
//  ValetTableViewCell.swift
//  CHLAValet
//
//  Created by Student on 2/18/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import UIKit

class ValetTableViewCell : UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var ticketNumberLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var carLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
}
