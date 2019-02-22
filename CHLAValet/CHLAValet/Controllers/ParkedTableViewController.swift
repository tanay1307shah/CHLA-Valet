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
        parkedTableView.reloadData()
    }
    
    @IBAction func requestDidPressed(_ sender: UIButton) {
        guard let selectedCarCell = sender.superview?.superview as? ValetTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        
        guard let indexPath = tableView.indexPath(for: selectedCarCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        cars.getCarAt(indexPath.row).requested = !cars.getCarAt(indexPath.row).requested
        if cars.getCarAt(indexPath.row).requested {
            sender.alpha = 0.5
        } else {
            sender.alpha = 1.0
        }
    }
}
