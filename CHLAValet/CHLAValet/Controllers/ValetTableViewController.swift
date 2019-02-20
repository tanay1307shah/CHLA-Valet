//
//  ValetTableViewController.swift
//  CHLAValet
//
//  Created by Student on 2/18/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import UIKit

class ValetTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    // MARK: - Table view data source
    var cars = [ValetEntry]()
    
    func loadData() {
        let valet1 = ValetEntry(name: "Nathan Scoglio", phoneNumber: "6263470607", ticketNumber: "1", licensePlate: "1ABC234", color: "Blue", type: "Elantra", make: "Hyundai", image: UIImage(named: "edit")!, requested: false, paid: false)
        cars += [valet1]
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "valetCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ValetTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ValetTableViewCell.")
        }
        // Configure the cell...
        let car = cars[indexPath.row]
        cell.ticketNumberLabel.text = car.ticketNumber
        cell.colorLabel.text = car.color.uppercased()
        cell.carLabel.text = car.make.uppercased() + " " + car.type.uppercased()
        cell.nameLabel.text = car.name.uppercased()
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
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
            
            let selectedCar = cars[indexPath.row]
            infoViewController.valet = selectedCar
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    
    //MARK: Actions
    @IBAction func unwindToValetList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddEditViewController, let valet = sourceViewController.valet {
            // Add a new car.
            let newIndexPath = IndexPath(row: cars.count, section: 0)
            cars.append(valet)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    @IBAction func requestDidPressed(_ sender: UIButton) {
        guard let selectedCarCell = sender.superview?.superview as? ValetTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        
        guard let indexPath = tableView.indexPath(for: selectedCarCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        cars[indexPath.row].requested = !cars[indexPath.row].requested
        sender.isHighlighted = !cars[indexPath.row].requested
    }
    

}
