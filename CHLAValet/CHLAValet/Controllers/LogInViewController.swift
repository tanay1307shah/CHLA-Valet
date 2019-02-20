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
    var api: APIManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = APIManager()
        api.someAPICall(onSuccess: {(obj: JSON) in print(obj)}, onFailure:{ (error: Error) in print(error.localizedDescription)})
    }


    @IBAction func enterButtonDidPressed(_ sender: UIButton) {
        // Verify valid info
        performSegue(withIdentifier: "logIn", sender: sender)
    }
}

