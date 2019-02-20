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
        
        loadInfo()
    }
    
    // MARK: Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "editValet":
            guard let editViewController = segue.destination as? AddEditViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            editViewController.valet = valet
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    // MARK: Actions
    @IBAction func unwindToInfoPage(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddEditViewController, let editValet = sourceViewController.valet {
            valet = editValet
            loadInfo()
        }
    }
    
    func loadInfo() {
        nameLabel.text = valet?.name
        phoneNumberLabel.text = valet?.phoneNumber
        ticketNumberLabel.text = valet?.ticketNumber
        licencePlateNumber.text = valet?.licensePlate
        makeLabel.text = valet?.make
        typeLabel.text = valet?.type
        colorLabel.text = valet?.color
    }
}

