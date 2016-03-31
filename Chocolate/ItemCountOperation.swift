//
//  ItemCountOperation.swift
//  ChocolatePuppies
//
//  Created by Tristan Burnside on 26/01/2016.
//  Copyright © 2016 Tristan Burnside. All rights reserved.
//

import Foundation

class ItemCountOperation : NSOperation {
    private let dataManager : ChocolateCellDataSource
    private let section : Int
    private let completion : (Int) -> ()
    init(dataManager:ChocolateCellDataSource, section: Int, completion : (Int) -> ()) {
        self.dataManager = dataManager
        self.section = section
        self.completion = completion
        super.init()
    }
    
    override func main() {
        completion(dataManager.numberOfItemsInSection(section))
    }
}