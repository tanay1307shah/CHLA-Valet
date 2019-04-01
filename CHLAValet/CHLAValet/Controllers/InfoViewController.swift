//
//  InfoViewController.swift
//  CHLAValet
//
//  Created by Student on 2/17/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import UIKit
import os.log
import SwiftSpinner

class InfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var valet: ValetEntry?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var ticketNumberLabel: UILabel!
    @IBOutlet weak var licencePlateNumber: UILabel!
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var customerTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInfo()
    }
    
    // MARK: Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "editValet":
            guard let navViewController = segue.destination as? UINavigationController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let editViewController = navViewController.children[0] as? AddEditViewController else {
                fatalError("Unexpected controller: \(navViewController.children[0])")
            }
            editViewController.valet = valet
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    // MARK: Collection view delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return valet?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = valet?.images[indexPath.row]
        return cell
    }
    
    // MARK: Actions
    @IBAction func unwindToInfoPage(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddEditViewController, let editValet = sourceViewController.valet {
            valet = editValet
            SwiftSpinner.show("Loading...")
            APIManager.shared.updateInfo(valetEntry: valet!, onSuccess: {
                SwiftSpinner.hide()
                
            }, onFailure: {e in
                print(e.localizedDescription)
                SwiftSpinner.hide()
            })
            loadInfo()
        } else {
            os_log("The data was not passed back", log: OSLog.default, type: .debug)
        }
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        // Remove car from database : TODO
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func loadInfo() {
        nameLabel.text = valet?.name.uppercased()
        phoneNumberLabel.text = valet?.phoneNumber
        ticketNumberLabel.text = valet?.ticketNumber
        licencePlateNumber.text = valet?.licensePlate
        makeLabel.text = valet?.make.capitalized
        typeLabel.text = valet?.type.capitalized
        colorLabel.text = valet?.color.capitalized
        customerTypeLabel.text = valet?.customerType.capitalized
        for i in 0 ..< (valet?.imageURLs.count)! {
            let url = valet?.imageURLs[i]
            if url == nil {
                continue
            }
            if let data = try? Data(contentsOf: url!){ //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                valet?.images[i] = UIImage(data: data)
            } else {
                valet?.images[i] = UIImage(named: "sadCloud")
            }
        }
        collectionView.reloadData()
    }
}

