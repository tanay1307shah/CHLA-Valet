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
    }
    
    @IBAction func enterButtonDidPressed(_ sender: UIButton) {
        // Verify valid info
        
        // Test request to make sure connection exists (otherwise error occurs)
        APIManager.shared.getAllCars(onSuccess:{ obj in print(obj)
            }, onFailure: {e in print(e)})
        performSegue(withIdentifier: "logIn", sender: sender)
    }
    
}

