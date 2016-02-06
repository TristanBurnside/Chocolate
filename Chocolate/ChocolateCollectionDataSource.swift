//
//  ChocolateCollectionDataSource.swift
//  ChocolatePuppies
//
//  Created by Tristan Burnside on 24/01/2016.
//  Copyright © 2016 Tristan Burnside. All rights reserved.
//

/**
*  This protocol is used by ChocolateCollectionViewController to gather data to display in the cells
*/
public protocol ChocolateCollectionDataSource {
    /**
     Should return the number of sections in the collection view
     
     - returns: The number of sections in the collection view
     */
    func numberOfSections() -> Int
    
    /**
     Should return the number of items in the given section
     
     - parameter section: The section currently being populated
     
     - returns: The number of items in the given section
     */
    func numberOfItemsInSection(section: Int) -> Int
    
    /**
     This method gives the data source a chance to do any initial or pre-loading work
     */
    func loadDataForItems()
    
    /**
     This method is used to provide the view models for the items in the data source.
     
     This method can and should return nil if the view model type provided is not supported as this indicates a mismatch between the data source and the cell class.
     
     This abstraction allows a data source to support multiple cell types.
     
     - parameter section: The section of the item
     - parameter item:    The index of the item in the given section
     
     - returns: The view model object that the cell can use to configure itself
     */
    func dataForItem<T>(section : Int, item : Int) -> T?
}