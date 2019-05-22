//
//  ParkedTableViewController.swift
//  CHLAValet
//
//  Created by Student on 2/21/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner

class ParkedViewController: ValetViewController{
    
    @IBOutlet var parkedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        filterButton = UIBarButtonItem(title: filterNames[filterType], style: .plain, target: self, action: #selector(ValetViewController.nextFilter))
        parent?.navigationItem.rightBarButtonItems?.append(filterButton)
        parent?.navigationItem.leftBarButtonItems?.append(refreshButton)
        tableView = parkedTableView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(ValetViewController.loadData), userInfo: nil, repeats: true)
        parent?.navigationItem.rightBarButtonItems?[1].isEnabled = true
        parent?.navigationItem.rightBarButtonItems?[1].title = filterNames[filterType]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer?.invalidate()
    }
    
    // MARK: Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "showInfo":
            guard let infoViewController = segue.destination as? InfoViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCarCell = sender as? ValetTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCarCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedCar = ValetEntryModel.shared.valetEntries[indexPath.row]
            infoViewController.valet = selectedCar
            if(ValetEntryModel.shared.requestedEntries.contains(where: { $0.ticketNumber == selectedCar.ticketNumber })){
                infoViewController.updateDisabled = true
            } else {
                infoViewController.updateDisabled = false
            }
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch filterType {
        case 1:
            return ValetEntryModel.shared.patientEntries.count
        case 2:
            return ValetEntryModel.shared.employeeEntries.count
        default:
            return ValetEntryModel.shared.valetEntries.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "valetCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ValetTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ValetTableViewCell.")
        }
        // Configure the cell...
        var entries: [ValetEntry]
        switch filterType {
        case 1:
            entries = ValetEntryModel.shared.patientEntries
        case 2:
            entries = ValetEntryModel.shared.employeeEntries
        default:
            entries = ValetEntryModel.shared.valetEntries
        }
        let car = entries[indexPath.row]
        cell.ticketNumberLabel.text = car.ticketNumber
        cell.colorLabel.text = car.color.uppercased()
        cell.carLabel.text = car.make.uppercased() + " " + car.type.uppercased()
        cell.nameLabel.text = car.name.uppercased()
        if car.customerType.lowercased() == "employee" {
            cell.requestButton.setTitle("Picked Up", for: .normal)
        } else {
            cell.requestButton.setTitle("Request", for: .normal)
        }
        if(ValetEntryModel.shared.requestedEntries.contains(where: { $0.ticketNumber == entries[indexPath.row].ticketNumber })){
            cell.requestButton.alpha = 0.5
            cell.requestButton.isEnabled = false
        } else {
            cell.requestButton.alpha = 1.0
            cell.requestButton.isEnabled = true
        }
        return cell
    }
    
    @IBAction func requestDidPressed(_ sender: UIButton) {
        guard let selectedCarCell = sender.superview?.superview as? ValetTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        
        guard let indexPath = tableView.indexPath(for: selectedCarCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        var entries: [ValetEntry]
        switch filterType {
        case 1:
            entries = ValetEntryModel.shared.patientEntries
        case 2:
            entries = ValetEntryModel.shared.employeeEntries
        default:
            entries = ValetEntryModel.shared.valetEntries
        }
        
        if entries[indexPath.row].customerType.lowercased() == "employee" {
            SwiftSpinner.show("Removing Car...")
            APIManager.shared.requestCar(ticketNumber: entries[indexPath.row].ticketNumber, onSuccess: {
                print("Success!")
                APIManager.shared.removeCar(ticketNumber: entries[indexPath.row].ticketNumber, onSuccess: {
                    self.loadData()
                }, onFailure: {e in
                    self.loadData()
                })
            }, onFailure: {e in
                SwiftSpinner.hide()
                let alertController = UIAlertController(title: "Error Requesting Car",
                                                        message: e,
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            })
        } else {
            SwiftSpinner.show("Requesting Car...")
            APIManager.shared.requestCar(ticketNumber: entries[indexPath.row].ticketNumber, onSuccess: {
                print("Success!")
                self.loadData()
            }, onFailure: {e in
                SwiftSpinner.hide()
                let alertController = UIAlertController(title: "Error Requesting Car",
                                                        message: e,
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
}
