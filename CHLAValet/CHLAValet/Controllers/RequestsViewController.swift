//
//  RequestsTableViewController.swift
//  CHLAValet
//
//  Created by Student on 2/21/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftSpinner

class RequestViewController: ValetViewController{
    
    @IBOutlet var requestsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = requestsTableView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(ValetViewController.loadData), userInfo: nil, repeats: true)
        parent?.navigationItem.rightBarButtonItems?[1].isEnabled = false
        parent?.navigationItem.rightBarButtonItems?[1].title = ""
        requestsTableView.reloadData()
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
            
            let selectedCar = ValetEntryModel.shared.requestedEntries[indexPath.row]
            infoViewController.valet = selectedCar
            infoViewController.updateDisabled = true
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ValetEntryModel.shared.requestedEntries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "valetCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ValetTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ValetTableViewCell.")
        }
        // Configure the cell...
        let car = ValetEntryModel.shared.requestedEntries[indexPath.row]
        cell.ticketNumberLabel.text = car.ticketNumber
        cell.colorLabel.text = car.color.uppercased()
        cell.carLabel.text = car.make.uppercased() + " " + car.type.uppercased()
        cell.nameLabel.text = car.name.uppercased()
        return cell
    }
    
    
    //MARK: Actions
    @IBAction func payButtonDidPressed(_ sender: UIButton) {
        guard let selectedCarCell = sender.superview?.superview as? ValetTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        
        guard let indexPath = tableView.indexPath(for: selectedCarCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        SwiftSpinner.show("Removing Car...")
        APIManager.shared.removeCar(ticketNumber: ValetEntryModel.shared.requestedEntries[indexPath.row].ticketNumber, onSuccess: {
            self.loadData()
        }, onFailure: {e in
            self.loadData()
            print(e)
            SwiftSpinner.hide()
        })
    }
}
