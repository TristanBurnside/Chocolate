//
//  LoadDataOperation.swift
//  ChocolatePuppies
//
//  Created by Tristan Burnside on 26/01/2016.
//  Copyright © 2016 Tristan Burnside. All rights reserved.
//

import Foundation

class LoadDataOperation : NSOperation {
    
    private let dataManager : ChocolateCellDataSource
    
    init(dataManager:ChocolateCellDataSource) {
        self.dataManager = dataManager
        super.init()
    }
    
    override func main() {
        dataManager.loadDataForItems()
    }
}