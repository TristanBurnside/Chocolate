//
//  ChocolateTableViewContolller.swift
//  Chocolate
//
//  Created by Tristan Burnside on 14/03/2016.
//  Copyright © 2016 Tristan Burnside. All rights reserved.
//

import UIKit

public class ChocolateTableViewContolller: UITableViewController, ConfigurableViewController {

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
    
    @IBOutlet private var configureDataOperation : ChocolateConfigureDataOperation?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        if let configureDataOperationCopy = configureDataOperation?.copy() as? ChocolateConfigureDataOperation {
            configureDataOperationCopy.configurationData = configurationData
            cellOperationQueue.addOperation(configureDataOperationCopy)
        }
        
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
            let tableView = tableView {
                
                if chocolateDataSource.needsReload {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        tableView.reloadData()
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
    
    
    @IBAction func prepareForUnwind(segue : UIStoryboardSegue) {}
    
    // MARK: UITableViewDataSource
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var sectionCount : Int = 0
        if let chocolateDataSource = chocolateDataSource {
            let sectionsOp = SectionCountOperation(dataManager: chocolateDataSource){ (number :Int) in
                sectionCount = number
            }
            if let dataLoadOperation = dataLoadOperation {
                sectionsOp.addDependency(dataLoadOperation)
            }
            cellOperationQueue.addOperation(sectionsOp)
        }

        cellOperationQueue.waitUntilAllOperationsAreFinished()
        return sectionCount
    }
    
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        if let cellClass = cell.dynamicType as? ChocolateCell.Type {
            let cellConfigOpType = cellClass.cellConfigurationOperation()
            
            if let cell = cell as? ChocolateCell,
                chocolateDataSource = chocolateDataSource {
                    let cellConfigOp = cellConfigOpType.init(cell: cell, indexPath: indexPath, dataManager: chocolateDataSource)
                    
                    cellOperationQueue.addOperation(cellConfigOp);
            }
        }

        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as? ChocolateCell
        
        if let cellSelectionOperation = cellSelectionOperation,
            selectedCollectionViewCell = selectedCell {
                cellSelectionOperation.cell = selectedCollectionViewCell
        }
        
        if let cellSelectionOperation = cellSelectionOperation {
            cellOperationQueue.addOperation(cellSelectionOperation)
        }
        
    }
    
}
