//
//  ImageViewController.swift
//  CHLAValet
//
//  Created by Student on 4/12/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import UIKit
import WebKit

class ImageViewController: UIViewController, WKNavigationDelegate {
    
    var selectedImage: UIImage?
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = selectedImage {
            imageView.image = image
        }
    }
}
