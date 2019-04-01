//
//  AddViewController.swift
//  CHLAValet
//
//  Created by Student on 2/17/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import UIKit
import os.log

class AddEditViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var valet: ValetEntry?
    var images: [UIImage?] = []
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var licencePlateNumberTextField: UITextField!
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var makeTextField: UITextField!
    @IBOutlet weak var saveButton: RoundedUIButton!
    @IBOutlet weak var saveChangesButton: RoundedUIButton!
    @IBOutlet weak var customerSegControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.        
        nameTextField.delegate = self
        phoneNumberTextField.delegate = self
        locationTextField.delegate = self
        licencePlateNumberTextField.delegate = self
        colorTextField.delegate = self
        typeTextField.delegate = self
        makeTextField.delegate = self
        saveChangesButton.isHidden = true
        saveButton.isHidden = false
        
        // Set up views if editing an existing car.
        if let valet = valet {
            saveChangesButton.isHidden = false
            saveButton.isHidden = true
            nameTextField.text = valet.name
            phoneNumberTextField.text = valet.phoneNumber
            licencePlateNumberTextField.text = valet.licensePlate
            colorTextField.text = valet.color
            typeTextField.text = valet.type
            makeTextField.text = valet.make
            locationTextField.text = valet.location
            if(valet.customerType.lowercased() == "employee")
            {
                customerSegControl.selectedSegmentIndex = 1
            }
            images = valet.images
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let originalImage = info[.originalImage] as! UIImage
        images.append(originalImage)
        collectionView.reloadData()
        print("original Image\(originalImage)")
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Collection view delegates
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = images[indexPath.row]
        return cell
    }
    
    //MARK: Navigation
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIButton, button === saveButton || button === saveChangesButton else{
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        createValetEntry()
    }
    
    //MARK: Actions
    @IBAction func cancelDidPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backgroundDidPressed(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        phoneNumberTextField.resignFirstResponder()
        locationTextField.resignFirstResponder()
        licencePlateNumberTextField.resignFirstResponder()
        colorTextField.resignFirstResponder()
        typeTextField.resignFirstResponder()
        makeTextField.resignFirstResponder()
    }
    
    @IBAction func getImagePickerDidSelect(_ sender: UIButton){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonDidPressed(_ sender: UIButton) {
        guard let selectedCollectionCell = sender.superview?.superview as? ImageCollectionViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        
        guard let indexPath = collectionView.indexPath(for: selectedCollectionCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        images.remove(at: indexPath.row)
        collectionView.reloadData()
    }
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
        saveChangesButton.isEnabled = false
        saveButton.alpha = 0.5
        saveChangesButton.alpha = 0.5
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the any text fields are empty.
        let name = nameTextField.text ?? ""
        let phoneNumber = phoneNumberTextField.text ?? ""
        let licensePlateNumber = licencePlateNumberTextField.text ?? ""
        let color = colorTextField.text ?? ""
        let type = typeTextField.text ?? ""
        let make = makeTextField.text ?? ""
        saveButton.isEnabled = !name.isEmpty && !phoneNumber.isEmpty && !licensePlateNumber.isEmpty && !color.isEmpty && !type.isEmpty && !make.isEmpty
        saveChangesButton.isEnabled = !name.isEmpty && !phoneNumber.isEmpty && !licensePlateNumber.isEmpty && !color.isEmpty && !type.isEmpty && !make.isEmpty
        if saveButton.isEnabled {
            saveButton.alpha = 1.0
        } else {
            saveButton.alpha = 0.5
        }
        if saveChangesButton.isEnabled {
            saveChangesButton.alpha = 1.0
        } else {
            saveChangesButton.alpha = 0.5
        }
    }
    
    private func createValetEntry() {
        let name = nameTextField.text ?? ""
        let phoneNumber = phoneNumberTextField.text ?? ""
        let ticketNumber = valet?.ticketNumber
        let licensePlateNumber = licencePlateNumberTextField.text ?? ""
        let color = colorTextField.text ?? ""
        let type = typeTextField.text ?? ""
        let make = makeTextField.text ?? ""
        let location = locationTextField.text ?? ""
        let customerType = customerSegControl.titleForSegment(at: customerSegControl.selectedSegmentIndex) ?? ""
        valet = ValetEntry(name: name, phoneNumber: phoneNumber, ticketNumber: ticketNumber ?? "", licensePlate: licensePlateNumber, color: color, type: type, make: make, images: images, customerType: customerType, location: location)
    }
}
