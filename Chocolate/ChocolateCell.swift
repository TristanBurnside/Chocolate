//
//  ChocolateCollectionViewCell.swift
//  ChocolatePuppies
//
//  Created by Tristan Burnside on 26/01/2016.
//  Copyright © 2016 Tristan Burnside. All rights reserved.
//

import UIKit

/**
 *  Defines the methods that a Cell requires to be used with either ChocolateCollectionViewController 
 *  or ChocolateTableViewController
 */
public protocol ChocolateCell {
    /**
     A class mehod to get an operation for configuring the contents of this cell type
     
     - returns: A CellConfigurationOperation object
     */
    static func cellConfigurationOperation() -> CellConfigurationOperation
    
    /**
     A class method to get an operation for applying any required changes before segueing when this cell is selected
     
     - returns: A CellSegueOperation
     */
    static func cellSegueOperation() -> CellSegueOperation
}

/// Base class for operations that configure the view content of a cell
public class CellConfigurationOperation : NSOperation {
    /// The cell to configure
    public var cell : UICollectionViewCell?
    /// The index path of the cell in the table or collection view
    public var indexPath : NSIndexPath?
    /// The data manager to query for the data to populate the cell with
    public var dataManager : ChocolateCollectionDataSource?
}

/// Base class for operations that run when a cell is selected
public class CellSelectionOperation: NSObject {
    /// The cell that was selected
    public var cell : UICollectionViewCell?
    
    public func main () {}
}

/// Base class for operations that run when a cell is selected and a segue will be performed
public class CellSegueOperation: CellSelectionOperation {
    /// The view controller that will be segued to
    public var destinationViewController : UIViewController?
}