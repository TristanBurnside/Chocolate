//
//  ChocolateConfigureDataOperation.swift
//  ChocolatePuppies
//
//  Created by Tristan Burnside on 26/01/2016.
//  Copyright © 2016 Tristan Burnside. All rights reserved.
//
import Foundation

/// Base class for an operation that configures a Chocolate view contoller with any data that was passed to it when it was created or during a segue
public class ChocolateConfigureDataOperation : NSOperation, NSCopying {
    
    public override init() {
        super.init()
    }
    
    public required init(_ operation:ChocolateConfigureDataOperation) {
        configurationData = operation.configurationData
    }
    
    /// The data received by the ChocolateViewController if any
    public var configurationData : AnyObject?
    
    public func copyWithZone(zone: NSZone) -> AnyObject {
        return self.dynamicType.init(self)
    }
}