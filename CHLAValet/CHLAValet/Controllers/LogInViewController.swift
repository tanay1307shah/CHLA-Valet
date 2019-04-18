//
//  LogInViewController.swift
//  CHLAValet
//
//  Created by Student on 2/10/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner

class LogInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var enterButton: RoundedUIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        APIManager.shared.logIn(username: "", password: "", onSuccess: { () in }) { (String) in }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateEnterButtonState()
    }
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Enter button while editing.
        enterButton.isEnabled = false
        enterButton.alpha = 0.5
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateEnterButtonState()
    }

    // MARK: Actions
    @IBAction func unwindToLogInPage(sender: UIStoryboardSegue) {
        // Logged Out
        passwordTextField.text = ""
        updateEnterButtonState()
    }
    
    @IBAction func backgroundDidPressed(_ sender: UITapGestureRecognizer) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func enterButtonDidPressed(_ sender: UIButton) {
        // Verify valid info
        let onSuccessHandler: () -> (Void) = {
            self.performSegue(withIdentifier: "logIn", sender: sender)
        }
        let onFailureHandler: (String) -> (Void) = { e in
            let alertController = UIAlertController(title: "Error Logging In",
                                                    message: e,
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            SwiftSpinner.hide()
        }
        SwiftSpinner.show("Logging In")
        APIManager.shared.logIn(username: usernameTextField.text!, password: passwordTextField.text!, onSuccess: onSuccessHandler, onFailure: onFailureHandler)
    }
    
    private func updateEnterButtonState() {
        // Disable the Enter button if the any text fields are empty.
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        enterButton.isEnabled = !username.isEmpty && !password.isEmpty
        if enterButton.isEnabled {
            enterButton.alpha = 1.0
        } else {
            enterButton.alpha = 0.5
        }
    }
    
}

