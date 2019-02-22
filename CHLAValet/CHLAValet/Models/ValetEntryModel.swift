//
//  ValetEntryModel.swift
//  CHLAValet
//
//  Created by Student on 2/21/19.
//  Copyright © 2019 CSCI401. All rights reserved.
//

import Foundation

class ValetEntryModel{
    
    private var valetEntries: [ValetEntry]
    
    public static let shared = ValetEntryModel()
    
    init(){
        valetEntries = [ValetEntry]()
    }
    
    func getCarAt(_ index: Int) -> ValetEntry {
        return valetEntries[index]
    }
    
    func append(_ valetEntry: ValetEntry){
        valetEntries.append(valetEntry)
    }
    
    func set(at: Int, _ valetEntry: ValetEntry){
        valetEntries[at] = valetEntry
    }
    
    func remove(at: Int){
        valetEntries.remove(at: at)
    }
    
    func count() -> Int {
        return valetEntries.count
    }
}
