//
//  CircleView.swift
//  CHLAValet
//
//  Created by Student on 2/14/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import UIKit

@IBDesignable public class CircleView: UIView {
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        //hard-coded this since it's always round
        layer.cornerRadius = 0.5 * bounds.size.width
    }
}
