//
//  RequestsTableViewController.swift
//  CHLAValet
//
//  Created by Student on 2/21/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import UIKit

class RequestTableViewController: ValetTableViewController{
    
    @IBOutlet var requestsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = requestsTableView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        requestsTableView.reloadData()
    }
    
    //MARK: Actions
    @IBAction func payButtonDidPressed(_ sender: UIButton) {
        guard let selectedCarCell = sender.superview?.superview as? ValetTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        
        guard let indexPath = tableView.indexPath(for: selectedCarCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        cars.getCarAt(indexPath.row).paid = !cars.getCarAt(indexPath.row).paid
        if cars.getCarAt(indexPath.row).paid {
            sender.alpha = 0.5
        } else {
            sender.alpha = 1.0
        }
    }
    
    @IBAction func readyButtonDidPressed(_ sender: UIButton) {
        guard let selectedCarCell = sender.superview?.superview as? ValetTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        
        guard let indexPath = tableView.indexPath(for: selectedCarCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        // TODO: Code to send ready text
        cars.getCarAt(indexPath.row).ready = !cars.getCarAt(indexPath.row).ready
        if cars.getCarAt(indexPath.row).ready {
            sender.alpha = 0.5
        } else {
            sender.alpha = 1.0
        }
        
    }
}
