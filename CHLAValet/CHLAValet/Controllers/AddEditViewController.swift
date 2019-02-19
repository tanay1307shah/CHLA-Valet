//
//  AddViewController.swift
//  CHLAValet
//
//  Created by Student on 2/17/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import UIKit
import os.log

class AddEditViewController: UIViewController, UITextFieldDelegate {
    
    var valet: ValetEntry?
    
    //MARK: Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var ticketNumberTextField: UITextField!
    @IBOutlet weak var licencePlateNumberTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var makeTextField: UITextField!
    @IBOutlet weak var saveButton: RoundedUIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameTextField.delegate = self
        phoneNumberTextField.delegate = self
        ticketNumberTextField.delegate = self
        licencePlateNumberTextField.delegate = self
        colorTextField.delegate = self
        typeTextField.delegate = self
        makeTextField.delegate = self
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }
    
    //MARK: Navigation
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIButton, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let phoneNumber = phoneNumberTextField.text ?? ""
        let ticketNumber = ticketNumberTextField.text ?? ""
        let licensePlateNumber = licencePlateNumberTextField.text ?? ""
        let color = colorTextField.text ?? ""
        let type = typeTextField.text ?? ""
        let make = makeTextField.text ?? ""
        valet = ValetEntry(name: name, phoneNumber: phoneNumber, ticketNumber: ticketNumber, licensePlate: licensePlateNumber, color: color, type: type, make: make, image: nil, requested: false, paid: false)
    }
    
    //MARK: Actions
    @IBAction func cancelDidPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backgroundDidPressed(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        phoneNumberTextField.resignFirstResponder()
        ticketNumberTextField.resignFirstResponder()
        licencePlateNumberTextField.resignFirstResponder()
        colorTextField.resignFirstResponder()
        typeTextField.resignFirstResponder()
        makeTextField.resignFirstResponder()
    }
    
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the any text fields are empty.
        let name = nameTextField.text ?? ""
        let phoneNumber = phoneNumberTextField.text ?? ""
        let ticketNumber = ticketNumberTextField.text ?? ""
        let licensePlateNumber = licencePlateNumberTextField.text ?? ""
        let color = colorTextField.text ?? ""
        let type = typeTextField.text ?? ""
        let make = makeTextField.text ?? ""
        saveButton.isEnabled = !name.isEmpty && !phoneNumber.isEmpty && !ticketNumber.isEmpty && !licensePlateNumber.isEmpty && !color.isEmpty && !type.isEmpty && !make.isEmpty
        saveButton.isHighlighted = !saveButton.isEnabled
    }
}
