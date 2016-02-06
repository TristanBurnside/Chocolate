//
//  ChocolateCollectionViewController.swift
//  ChocolatePuppies
//
//  Created by Tristan Burnside on 31/10/2015.
//  Copyright © 2015 Tristan Burnside. All rights reserved.
//

import UIKit

public class ChocolateCollectionViewController: UICollectionViewController {

    //Note to self: this is AnyObject because protocol implementing properties cannot be @IBOutlet
    @IBOutlet private var dataSource : AnyObject?
    private let cellOperationQueue = NSOperationQueue()
    private var dataLoadOperation : NSOperation?
    @IBOutlet private var cellSelectionOperation : CellSelectionOperation?
    @IBOutlet private var cellSegueOperation : CellSegueOperation?
    
    /// The reuseIdentifier for the cells in the collection view. Must match the reuseIdentifier for the 
    /// Prototype cells in the storyboard
    @IBInspectable public var reuseIdentifier : String!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        dataLoadOperation = LoadDataOperation(dataManager: dataSource as! ChocolateCollectionDataSource)
        
        cellOperationQueue.addOperation(dataLoadOperation!)
        
    }

    // MARK: - Navigation
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if cellSegueOperation == nil {
            if let selectedChocolateCell = sender as? ChocolateCell {
                cellSegueOperation = selectedChocolateCell.dynamicType.cellSegueOperation()
            }
        }
        if let cellSegueOperation = cellSegueOperation,
               selectedCollectionViewCell = sender as? UICollectionViewCell {
            cellSegueOperation.cell = selectedCollectionViewCell
            cellSegueOperation.destinationViewController = segue.destinationViewController
        }
        if let cellSegueOperation = cellSegueOperation {
            let cellSegueBlockOperation = NSBlockOperation(block: { () -> Void in
                cellSegueOperation.main();
            })
            cellOperationQueue.addOperation(cellSegueBlockOperation)
        }
    }

    @IBAction func prepareForUnwind(segue : UIStoryboardSegue) {
        assertionFailure("Not yet implemented")
    }
    
    // MARK: UICollectionViewDataSource

    override public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        var sectionCount : Int = 0
        let sectionsOp = SectionCountOperation(dataManager: dataSource as! ChocolateCollectionDataSource){ (number :Int) in
            sectionCount = number
        }
        sectionsOp.addDependency(dataLoadOperation!)
        cellOperationQueue.addOperation(sectionsOp)
        cellOperationQueue.waitUntilAllOperationsAreFinished()
        return sectionCount
    }


    override public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemCount : Int = 0
        let itemsOp = ItemCountOperation(dataManager: dataSource as! ChocolateCollectionDataSource, section : section) { (number :Int) in
            itemCount = number
        }
        itemsOp.addDependency(dataLoadOperation!)
        cellOperationQueue.addOperation(itemsOp)
        cellOperationQueue.waitUntilAllOperationsAreFinished()
        return itemCount
    }

    override public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        let cellClass = cell.dynamicType as! ChocolateCell.Type
        let cellConfigOp = cellClass.cellConfigurationOperation()
            cellConfigOp.cell = cell
            cellConfigOp.indexPath = indexPath
            cellConfigOp.dataManager = dataSource as? ChocolateCollectionDataSource
            cellOperationQueue.addOperation(cellConfigOp);
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    override public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)
        
        cellSelectionOperation?.cell = selectedCell
        
        if let cellSelectionOperation = cellSelectionOperation {
            cellOperationQueue.addOperation(NSBlockOperation(block: { () -> Void in
                cellSelectionOperation.main()
            }))
        }
        
    }

}
