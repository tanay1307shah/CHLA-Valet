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

class InfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var valet: ValetEntry?
    var images: [UIImage?] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var ticketNumberLabel: UILabel!
    @IBOutlet weak var licencePlateNumber: UILabel!
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var customerTypeLabel: UILabel!
    @IBOutlet weak var updateButton: RoundedUIButton!
    
    var updateDisabled: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if updateDisabled ?? false {
            updateButton.isHidden = true
        } else {
            updateButton.isHidden = false
        }
        for _ in 0..<(valet?.imageURLs.count)!{
            images.append(nil)
        }
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
            editViewController.images = images
        case "showImageFromInfo":
            let viewController = segue.destination as! ImageViewController
            let index = collectionView.indexPathsForSelectedItems!.first!
            viewController.selectedImage = images[index.row]
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    // MARK: Collection view delegates
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = images[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.height - 10
        return CGSize(width: height, height: height)
    }
    
    // MARK: Actions
    @IBAction func unwindToInfoPage(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? AddEditViewController, let editValet = sourceViewController.valet {
            valet = editValet
            let images = sourceViewController.images
            SwiftSpinner.show("Loading...")
            APIManager.shared.updateInfo(valetEntry: valet!, images: images, onSuccess: {
                SwiftSpinner.hide()
                self.loadInfo()
                ValetViewController.edited = true
            }, onFailure: {e in
                print(e)
                SwiftSpinner.hide()
            })
        } else {
            os_log("The data was not passed back", log: OSLog.default, type: .debug)
        }
    }
    
    func loadInfo() {
        if valet?.location == "" {
            navigationItem.title = "No Location"
        } else {
            navigationItem.title = valet?.location
        }
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
            downloadImage(from: url!, index: i)
        }
    }
    
    func downloadImage(from url: URL, index: Int) {
        print("Download Started")
        print(url)
        images[index] = UIImage(named: "loading")
        self.collectionView.reloadData()
        getData(from: url) { data, response, error in
            guard let data = data, error == nil
                else {
                    self.images[index] = UIImage(named: "sadCloud")
                    self.collectionView.reloadData()
                    return
            }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.images[index] = UIImage(data: data)
                self.collectionView.reloadData()
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

