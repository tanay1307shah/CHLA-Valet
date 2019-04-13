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

class ValetViewController: UIViewController, UITableViewDataSource{
    
    var tableView: UITableView!
    var filterButton: UIBarButtonItem!
    var refreshButton: UIBarButtonItem!
    
    var filterType = 0
    var filterNames = ["All", "Patients", "Employees"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(ValetViewController.loadData))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    //MARK: Actions
    @IBAction func unwindToValetList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddEditViewController, let valet = sourceViewController.valet {
            SwiftSpinner.show("Adding Car...")
            APIManager.shared.addCar(valetEntry: valet, onSuccess: {
                print("Success!")
                self.loadData()
            }, onFailure: {e in
                print(e.localizedDescription)
            })
        }
    }
    
    @objc func loadData() {
        SwiftSpinner.show("Retrieving Cars...")
        
        // Loading all cars succeeded
        let onSuccessHandlerAll: (JSON) -> (Void) = { obj in
            ValetEntryModel.shared.valetEntries.removeAll()
            ValetEntryModel.shared.patientEntries.removeAll()
            ValetEntryModel.shared.employeeEntries.removeAll()
            for (_,subJson):(String, JSON) in obj {
                let valet = ValetEntry(obj: subJson)
                ValetEntryModel.shared.valetEntries.append(valet)
                if valet.customerType.lowercased() == "patient" {
                    ValetEntryModel.shared.patientEntries.append(valet)
                } else {
                    ValetEntryModel.shared.employeeEntries.append(valet)
                }
            }
            ValetEntryModel.shared.valetEntries.sort{
                $0.ticketNumber < $1.ticketNumber
            }
            ValetEntryModel.shared.patientEntries.sort{
                $0.ticketNumber < $1.ticketNumber
            }
            ValetEntryModel.shared.employeeEntries.sort{
                $0.ticketNumber < $1.ticketNumber
            }
            
            // Loading requested cars succeeded
            let onSuccessHandlerReq: (JSON) -> (Void) = { obj in
                ValetEntryModel.shared.requestedEntries.removeAll()
                for (_,subJson):(String, JSON) in obj {
                    let valet = ValetEntry(obj: subJson)
                    ValetEntryModel.shared.requestedEntries.append(valet)
                }
                ValetEntryModel.shared.requestedEntries.sort{
                    $0.ticketNumber < $1.ticketNumber
                }
                if let tabItems = self.tabBarController?.tabBar.items {
                    let tabItem = tabItems[1]
                    if ValetEntryModel.shared.requestedEntries.count == 0 {
                        tabItem.badgeValue = nil
                    } else {
                        tabItem.badgeValue = "\(ValetEntryModel.shared.requestedEntries.count)"
                    }
                }
                SwiftSpinner.hide()
                UIView.transition(with: self.tableView,
                                  duration: 0.50,
                                  options: .transitionCrossDissolve,
                                  animations: { self.tableView.reloadData() })
            }
            
            // Loading requested cars failed
            let onFailureHandlerReq: (Error) ->(Void) = { e in
                // TODO: Add alert to show error
                SwiftSpinner.hide()
                print(e.localizedDescription)
            }
            SwiftSpinner.show("Checking for requests...")
            APIManager.shared.getRequestedCars(onSuccess: onSuccessHandlerReq, onFailure: onFailureHandlerReq)
        }
        
        // Loading all cars failed
        let onFailureHandlerAll: (Error) ->(Void) = { e in
            // TODO: Add alert to show error
            SwiftSpinner.hide()
            print(e.localizedDescription)
            let alertController = UIAlertController(title: "Error Retrieving Car List",
                                                    message: "Please try again.",
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        APIManager.shared.getAllCars(onSuccess: onSuccessHandlerAll, onFailure: onFailureHandlerAll)
    }
    
    @objc func nextFilter() {
        filterType += 1
        if filterType > 2 {
            filterType = 0
        }
        filterButton.title = filterNames[filterType]
        UIView.transition(with: self.tableView,
                          duration: 0.50,
                          options: .transitionCrossDissolve,
                          animations: { self.tableView.reloadData() })
    }

}
