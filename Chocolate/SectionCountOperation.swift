//
//  File.swift
//  ChocolatePuppies
//
//  Created by Tristan Burnside on 26/01/2016.
//  Copyright © 2016 Tristan Burnside. All rights reserved.
//

import Foundation

class SectionCountOperation : NSOperation {
    private let dataManager : ChocolateCellDataSource
    private let completion : (Int) -> ()
    
    init(dataManager:ChocolateCellDataSource, completion : (Int) -> ()) {
        self.dataManager = dataManager
        self.completion = completion
        super.init()
    }
    
    override func main() {
        completion(dataManager.numberOfSections())
    }
}