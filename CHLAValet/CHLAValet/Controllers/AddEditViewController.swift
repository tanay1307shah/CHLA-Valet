//
//  AddViewController.swift
//  CHLAValet
//
//  Created by Student on 2/17/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import UIKit
import os.log
import SwiftyJSON

class AddEditViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var valet: ValetEntry?
    var images: [UIImage?] = []
    
    var models: [String] = []
    var makes: [String] = []
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addImageRound: RoundUIView!
    @IBOutlet weak var addImageImage: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
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
        APIManager.shared.getCarMakes { obj in
            let array = obj["Makes"]
            for (_,subJson):(String, JSON) in array {
                self.makes.append(subJson["make_display"].stringValue)
            }
        }
        // Handle the text field’s user input through delegate callbacks.        
        nameTextField.delegate = self
        phoneNumberTextField.delegate = self
        licencePlateNumberTextField.delegate = self
        
        // Loacation
        locationTextField.delegate = self
        let locationPickerView = UIPickerView()
        locationPickerView.delegate = self
        locationTextField.inputView = locationPickerView
        let locationDropDown = UIImageView(image: UIImage(named: "dropDown"))
        locationDropDown.backgroundColor = UIColor.lightGray
        locationTextField.rightView = locationDropDown
        locationTextField.rightViewMode = .always
        
        // Color
        colorTextField.delegate = self
        let colorPickerView = UIPickerView()
        colorPickerView.delegate = self
        colorTextField.inputView = colorPickerView
        let colorDropDown = UIImageView(image: UIImage(named: "dropDown"))
        colorDropDown.backgroundColor = UIColor.lightGray
        colorTextField.rightView = colorDropDown
        colorTextField.rightViewMode = .always
        
        // Make
        makeTextField.delegate = self
        let makePickerView = UIPickerView()
        makePickerView.delegate = self
        makeTextField.inputView = makePickerView
        let makeDropDown = UIImageView(image: UIImage(named: "dropDown"))
        makeDropDown.backgroundColor = UIColor.lightGray
        makeTextField.rightView = makeDropDown
        makeTextField.rightViewMode = .always
        
        // Model
        typeTextField.delegate = self
        let modelPickerView = UIPickerView()
        modelPickerView.delegate = self
        typeTextField.inputView = modelPickerView
        let typeDropDown = UIImageView(image: UIImage(named: "dropDown"))
        typeDropDown.backgroundColor = UIColor.lightGray
        typeTextField.rightView = typeDropDown
        typeTextField.rightViewMode = .always
        
        saveChangesButton.isHidden = true
        saveButton.isHidden = false
        addImageRound.isHidden = false
        addImageImage.isHidden = false
        addImageButton.isHidden = false
        
        // Set up views if editing an existing car.
        if let valet = valet {
            addImageRound.isHidden = true
            addImageImage.isHidden = true
            addImageButton.isHidden = true
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
        }
        
        // Enable the Save button only if required text fields are filled
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
        if valet != nil {
            cell.deleteButton.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.height - 10
        return CGSize(width: height, height: height)
    }
    
    // MARK: Picker View Delegates
    // Sets number of columns in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Sets the number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if makeTextField.inputView == pickerView {
            return makes.count
        } else if typeTextField.inputView == pickerView {
            return models.count
        } else if colorTextField.inputView == pickerView {
            return Constants.colors.count
        }
        return Constants.locations.count
    }
    
    // This function sets the text of the picker view to the content of the "makes" array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if makeTextField.inputView == pickerView {
            return makes[row]
        } else if typeTextField.inputView == pickerView {
            return models[row]
        } else if colorTextField.inputView == pickerView {
            return Constants.colors[row]
        }
        return Constants.locations[row]
    }
    
    // When user selects an option, this function will set the text of the text field to reflect
    // the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if makeTextField.inputView == pickerView {
            makeTextField.text = makes[row]
            APIManager.shared.getCarModelByMake(make: makes[row]) { obj in
                self.models.removeAll()
                let array = obj["Models"]
                for (_,subJson):(String, JSON) in array {
                    self.models.append(subJson["model_name"].stringValue)
                }
                let modelPicker = self.typeTextField.inputView as? UIPickerView
                modelPicker?.reloadAllComponents()
            }
        } else if typeTextField.inputView == pickerView {
            if models.count == 0 {
                typeTextField.text = ""
            }
            typeTextField.text = models[row]
        } else if colorTextField.inputView == pickerView {
            colorTextField.text = Constants.colors[row]
        } else {
            locationTextField.text = Constants.locations[row]
        }
        updateSaveButtonState()
    }
    
    //MARK: Navigation
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "showImageFromAdd" {
            print("segueing!")
            let viewController = segue.destination as! ImageViewController
            let index = collectionView.indexPathsForSelectedItems!.first!
            viewController.selectedImage = images[index.row]
            return
        }
        
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
        imagePicker.sourceType = .camera
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
        collectionView.deleteItems(at: [indexPath])
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
        valet = ValetEntry(name: name, phoneNumber: phoneNumber, ticketNumber: ticketNumber ?? "", licensePlate: licensePlateNumber, color: color, type: type, make: make, customerType: customerType, location: location)
    }
}
