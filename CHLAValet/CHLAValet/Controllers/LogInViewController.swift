//
//  LogInViewController.swift
//  CHLAValet
//
//  Created by Student on 2/10/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var employeeIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK: Actions
    @IBAction func unwindToLogInPage(sender: UIStoryboardSegue) {
        // Logged Out
    }
    
    @IBAction func enterButtonDidPressed(_ sender: UIButton) {
        // Verify valid info
        performSegue(withIdentifier: "logIn", sender: sender)
    }
}

