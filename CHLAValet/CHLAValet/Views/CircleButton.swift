//
//  CircleButton.swift
//  CHLAValet
//
//  Created by Student on 2/21/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import UIKit

@IBDesignable class CircleButton: UIButton {
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        //hard-coded this since it's always round
        layer.cornerRadius = 0.5 * bounds.size.width
    }
}
