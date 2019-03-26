//
//  ParkedTableViewController.swift
//  CHLAValet
//
//  Created by Student on 2/21/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import UIKit

class ParkedTableViewController: ValetTableViewController{
    
    @IBOutlet var parkedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = parkedTableView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        parkedTableView.reloadData()
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
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ValetEntryModel.shared.valetEntries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "valetCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ValetTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ValetTableViewCell.")
        }
        // Configure the cell...
        let car = ValetEntryModel.shared.valetEntries[indexPath.row]
        cell.ticketNumberLabel.text = car.ticketNumber
        cell.colorLabel.text = car.color.uppercased()
        cell.carLabel.text = car.make.uppercased() + " " + car.type.uppercased()
        cell.nameLabel.text = car.name.uppercased()
        if(ValetEntryModel.shared.requestedEntries.contains(where: { $0.ticketNumber == ValetEntryModel.shared.valetEntries[indexPath.row].ticketNumber })){
            cell.requestButton.alpha = 0.5
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
        
        APIManager.shared.requestCar(ticketNumber: ValetEntryModel.shared.valetEntries[indexPath.row].ticketNumber, onSuccess: {
            print("Success!")
        }, onFailure: {e in
            print(e.localizedDescription)
        })
    }
}
