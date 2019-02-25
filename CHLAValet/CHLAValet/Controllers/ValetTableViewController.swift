//
//  ValetTableViewController.swift
//  CHLAValet
//
//  Created by Student on 2/18/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner

class ValetTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(cars.count() == 0){
            loadData()
        }
    }

    // MARK: - Table view data source
    var cars = ValetEntryModel.shared

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "valetCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ValetTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ValetTableViewCell.")
        }
        // Configure the cell...
        let car = cars.getCarAt(indexPath.row)
        cell.ticketNumberLabel.text = car.ticketNumber
        cell.colorLabel.text = car.color.uppercased()
        cell.carLabel.text = car.make.uppercased() + " " + car.type.uppercased()
        cell.nameLabel.text = car.name.uppercased()
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
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
            
            let selectedCar = cars.getCarAt(indexPath.row)
            infoViewController.valet = selectedCar
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    
    //MARK: Actions
    @IBAction func unwindToValetList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddEditViewController, let valet = sourceViewController.valet {
            SwiftSpinner.show("Loading...")
            APIManager.shared.addCar(valetEntry: valet, onSuccess: {
                self.loadData()
                
            }, onFailure: {e in
                print(e.localizedDescription)
                SwiftSpinner.hide()
            })
        }
    }
    
    func loadData() {
        //self.showSpinner(onView: self.view)
        SwiftSpinner.show("Loading...")
        ValetEntryModel.shared.clear()
        let onSuccessHandler: (JSON) -> (Void) = { obj in
            for (_,subJson):(String, JSON) in obj {
                let valet = ValetEntry(obj: subJson)
                self.cars.append(valet)
            }
            self.tableView.reloadData()
            SwiftSpinner.hide()
        }
        let onFailureHandler: (Error) ->(Void) = { e in
            // TODO: Add error message
            SwiftSpinner.hide()
            print(e.localizedDescription)
        }
    
        APIManager.shared.getAllCars(onSuccess: onSuccessHandler, onFailure: onFailureHandler)
    }

}
