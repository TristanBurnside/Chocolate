//
//  ViewController.swift
//  ChocolatePuppies
//
//  Created by Tristan Burnside on 31/10/2015.
//  Copyright © 2015 Tristan Burnside. All rights reserved.
//

import UIKit

public class ChocolateViewController: UIViewController, ConfigurableViewController {

    private let operationQueue = NSOperationQueue()
    
    /// This property is designed to allow other view controllers to pass data in to this view controller
    public var configurationData : AnyObject?

    @IBOutlet private var configureDataOperation : ChocolateConfigureDataOperation?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        if let configureDataOperation = configureDataOperation {
            configureDataOperation.configurationData = configurationData
            operationQueue.addOperation(NSBlockOperation(block: { () -> Void in
                configureDataOperation.main()
            }));
        }
    }

}

public protocol ConfigurableViewController {
    var configurationData : AnyObject?{get set}
}