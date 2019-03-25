//
//  ValetEntryModel.swift
//  CHLAValet
//
//  Created by Student on 2/21/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import Foundation

class ValetEntryModel{
    
    var valetEntries: [ValetEntry]
    var requestedEntries: [ValetEntry]
    
    public static let shared = ValetEntryModel()
    
    init(){
        valetEntries = [ValetEntry]()
        requestedEntries = [ValetEntry]()
    }
    
}
