//
//  InfoViewController.swift
//  CHLAValet
//
//  Created by Student on 2/17/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    var valet: ValetEntry?
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var ticketNumberLabel: UILabel!
    @IBOutlet weak var licencePlateNumber: UILabel!
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameLabel.text = valet?.name
        phoneNumberLabel.text = valet?.phoneNumber
        ticketNumberLabel.text = valet?.ticketNumber
        licencePlateNumber.text = valet?.licensePlate
        makeLabel.text = valet?.make
        typeLabel.text = valet?.type
        colorLabel.text = valet?.color
    }
    
    
}

