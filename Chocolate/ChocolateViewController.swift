//
//  ViewController.swift
//  ChocolatePuppies
//
//  Created by Tristan Burnside on 31/10/2015.
//  Copyright © 2015 Tristan Burnside. All rights reserved.
//

import UIKit

public class ChocolateViewController: UIViewController {

    private let operationQueue = NSOperationQueue()
    
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

