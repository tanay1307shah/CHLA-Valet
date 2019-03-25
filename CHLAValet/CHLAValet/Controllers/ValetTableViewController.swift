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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    //MARK: Actions
    @IBAction func unwindToValetList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddEditViewController, let valet = sourceViewController.valet {
            APIManager.shared.addCar(valetEntry: valet, onSuccess: {
                print("Success!")
            }, onFailure: {e in
                print(e.localizedDescription)
            })
        }
    }
    
    func loadData() {
        //self.showSpinner(onView: self.view)
        SwiftSpinner.show("Loading...")
        ValetEntryModel.shared.valetEntries.removeAll()
        let onSuccessHandlerAll: (JSON) -> (Void) = { obj in
            for (_,subJson):(String, JSON) in obj {
                let valet = ValetEntry(obj: subJson)
                ValetEntryModel.shared.valetEntries.append(valet)
            }
            self.tableView.reloadData()
            SwiftSpinner.hide()
        }
        let onFailureHandlerAll: (Error) ->(Void) = { e in
            // TODO: Add error message
            SwiftSpinner.hide()
            print(e.localizedDescription)
        }
    
        APIManager.shared.getAllCars(onSuccess: onSuccessHandlerAll, onFailure: onFailureHandlerAll)
        
        ValetEntryModel.shared.requestedEntries.removeAll()
        let onSuccessHandlerReq: (JSON) -> (Void) = { obj in
            for (_,subJson):(String, JSON) in obj {
                let valet = ValetEntry(obj: subJson)
                ValetEntryModel.shared.requestedEntries.append(valet)
            }
            self.tableView.reloadData()
            if let tabItems = self.tabBarController?.tabBar.items {
                // In this case we want to modify the badge number of the third tab:
                let tabItem = tabItems[1]
                if ValetEntryModel.shared.requestedEntries.count == 0 {
                    tabItem.badgeValue = nil
                } else {
                    tabItem.badgeValue = "\(ValetEntryModel.shared.requestedEntries.count)"
                }
            }
            SwiftSpinner.hide()
        }
        let onFailureHandlerReq: (Error) ->(Void) = { e in
            // TODO: Add error message
            SwiftSpinner.hide()
            print(e.localizedDescription)
        }
        
        APIManager.shared.getRequestedCars(onSuccess: onSuccessHandlerReq, onFailure: onFailureHandlerReq)
        
    }

}
