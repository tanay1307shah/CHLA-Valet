//
//  LogInViewController.swift
//  CHLAValet
//
//  Created by Student on 2/10/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import UIKit
import SwiftyJSON

class LogInViewController: UIViewController {

    @IBOutlet weak var employeeIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Actions
    @IBAction func unwindToLogInPage(sender: UIStoryboardSegue) {
        // Logged Out
        let cars = ValetEntryModel.shared
        cars.clear()
    }
    
    @IBAction func enterButtonDidPressed(_ sender: UIButton) {
        // Verify valid info
        performSegue(withIdentifier: "logIn", sender: sender)
    }
    
    func loadData() {
        let cars = ValetEntryModel.shared
        let valet1 = ValetEntry(name: "Nathan Scoglio", phoneNumber: "6263470607", ticketNumber: "1", licensePlate: "1ABC234", color: "Blue", type: "Elantra", make: "Hyundai", image: UIImage(named: "edit")!, requested: false, paid: false, ready: false)
        cars.append(valet1)
    }
}

