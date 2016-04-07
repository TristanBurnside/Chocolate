//
//  ChocolateCollectionViewController.swift
//  ChocolatePuppies
//
//  Created by Tristan Burnside on 31/10/2015.
//  Copyright © 2015 Tristan Burnside. All rights reserved.
//

import UIKit

public class ChocolateCollectionViewController: UICollectionViewController, ConfigurableViewController {

    //Note to self: this is AnyObject because protocol implementing properties cannot be @IBOutlet
    @IBOutlet private var dataSource : AnyObject?
    private var chocolateDataSource : ChocolateCellDataSource?
    private let cellOperationQueue = NSOperationQueue()
    private var dataLoadOperation : NSOperation?
    @IBOutlet private var cellSelectionOperation : CellSelectionOperation?
    @IBOutlet private var cellSegueOperation : CellSegueOperation?
    
    /// The reuseIdentifier for the cells in the collection view. Must match the reuseIdentifier for the 
    /// Prototype cells in the storyboard
    @IBInspectable public var reuseIdentifier : String!
    @IBOutlet private var configureDataOperation : ChocolateConfigureDataOperation?
    
    /// This property is designed to allow other view controllers to pass data in to this view controller
    public var configurationData : AnyObject? {
        didSet {
            if let configureDataOperationCopy = configureDataOperation?.copy() as? ChocolateConfigureDataOperation {
                configureDataOperationCopy.configurationData = configurationData
                let refreshOperation = NSBlockOperation(block: { () -> Void in
                    self.refreshDataIfNeeded()
                })
                refreshOperation.addDependency(configureDataOperationCopy)
                cellOperationQueue.addOperations([configureDataOperationCopy, refreshOperation], waitUntilFinished: false)
            }
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        chocolateDataSource = dataSource as? ChocolateCellDataSource
        
        if let chocolateDataSource = chocolateDataSource {
            
            dataLoadOperation = LoadDataOperation(dataManager: chocolateDataSource)
        
            cellOperationQueue.addOperation(dataLoadOperation!)
            
        }
        
    }

    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshDataIfNeeded()
    }
    
    private func refreshDataIfNeeded() {
        if var chocolateDataSource = chocolateDataSource,
           let collectionView = collectionView {
                    
            if chocolateDataSource.needsReload {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    collectionView.reloadData()
                })
                chocolateDataSource.needsReload = false
            }
        }
    }
    
    // MARK: - Navigation
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if cellSegueOperation == nil {
            if let selectedChocolateCell = sender as? ChocolateCell {
                cellSegueOperation = selectedChocolateCell.dynamicType.cellSegueOperation()
            }
        }
        if let cellSegueOperation = cellSegueOperation,
               selectedCollectionViewCell = sender as? ChocolateCell {
            cellSegueOperation.cell = selectedCollectionViewCell
            cellSegueOperation.destinationViewController = segue.destinationViewController
        }
        if let cellSegueOperation = cellSegueOperation {
            cellOperationQueue.addOperation(cellSegueOperation)
        }
    }

    @IBAction func prepareForUnwind(segue : UIStoryboardSegue) {
        
    }
    
    // MARK: UICollectionViewDataSource

    override public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        var sectionCount : Int = 0
        if let chocolateDataSource = chocolateDataSource{
            let sectionsOp = SectionCountOperation(dataManager: chocolateDataSource){ (number :Int) in
                sectionCount = number
            }
            if let dataLoadOperation = dataLoadOperation {
                sectionsOp.addDependency(dataLoadOperation)
            }
            cellOperationQueue.addOperation(sectionsOp)
            cellOperationQueue.waitUntilAllOperationsAreFinished()
        }
        return sectionCount
    }

    override public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemCount : Int = 0
        if let chocolateDataSource = chocolateDataSource {
            let itemsOp = ItemCountOperation(dataManager: chocolateDataSource, section : section) { (number :Int) in
                itemCount = number
            }
            if let dataLoadOperation = dataLoadOperation {
                itemsOp.addDependency(dataLoadOperation)
            }
            cellOperationQueue.addOperation(itemsOp)
            cellOperationQueue.waitUntilAllOperationsAreFinished()
        }
        return itemCount
    }

    override public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        if let cellClass = cell.dynamicType as? ChocolateCell.Type {
            let cellConfigOpType = cellClass.cellConfigurationOperation()
            let cellConfigOp : CellConfigurationOperation
        
            if let cell = cell as? ChocolateCell,
                   chocolateDataSource = chocolateDataSource {
                cellConfigOp = cellConfigOpType.init(cell: cell, indexPath: indexPath, dataManager: chocolateDataSource)
                
                cellOperationQueue.addOperation(cellConfigOp);
            }
        }
        return cell
    }

    // MARK: UICollectionViewDelegate

    override public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as? ChocolateCell

        if let cellSelectionOperation = cellSelectionOperation,
            selectedCollectionViewCell = selectedCell {
                cellSelectionOperation.cell = selectedCollectionViewCell
        }
        
        if let cellSelectionOperation = cellSelectionOperation {
            cellOperationQueue.addOperation(cellSelectionOperation)
        }
        
    }

}
