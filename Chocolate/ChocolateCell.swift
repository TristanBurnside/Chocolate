//
//  ChocolateCollectionViewCell.swift
//  ChocolatePuppies
//
//  Created by Tristan Burnside on 26/01/2016.
//  Copyright © 2016 Tristan Burnside. All rights reserved.
//

import UIKit

public protocol ChocolateCell {
    static func cellConfigurationOperation() -> CellConfigurationOperation
    static func cellSegueOperation() -> CellSegueOperation
}

public class CellConfigurationOperation : NSOperation {
    public var cell : UICollectionViewCell?
    public var indexPath : NSIndexPath?
    public var dataManager : ChocolateCollectionDataSource?
}

public class CellSelectionOperation: NSObject {
    public var cell : UICollectionViewCell?
    public func main () {}
}

public class CellSegueOperation: CellSelectionOperation {
    public var destinationViewController : UIViewController?
}