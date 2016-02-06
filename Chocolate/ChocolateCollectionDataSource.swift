//
//  ChocolateCollectionDataSource.swift
//  ChocolatePuppies
//
//  Created by Tristan Burnside on 24/01/2016.
//  Copyright © 2016 Tristan Burnside. All rights reserved.
//

public protocol ChocolateCollectionDataSource {
    func numberOfSections() -> Int
    func numberOfItemsInSection(section: Int) -> Int
    func loadDataForItems()
    func dataForItem<T>(section : Int, item : Int) -> T?
}