//
//  RoundedUIButton.swift
//  CHLAValet
//
//  Created by Student on 2/14/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import UIKit

@IBDesignable class RoundedUIButton: UIButton {
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
