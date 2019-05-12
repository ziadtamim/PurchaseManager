//
//  ISPurchase.swift
//  Cize
//
//  Created by Ziad Tamim on 5/2/16.
//  Copyright © 2016 Intensify Studio. All rights reserved.
//

import Foundation
import StoreKit
import BoltsSwift

public typealias ISPurchaseProductObservationBlock = (_ transaction : SKPaymentTransaction?) -> Void
public typealias ISPurchaseBuyProductResultBlock = (_ error : NSError?) -> Void

public class Purchase
{
    
    ///--------------------------------------
    // MARK - Public
    ///--------------------------------------
    
    public class func addObserverForProduct(_ productIdentifier: String, block: @escaping ISPurchaseProductObservationBlock)
    {
        purchaseController.transactionObserver.handle(productIdentifier, block: block)
    }
    
    public class func findProducts(_ productIdentifiers: Set<String>, completion: @escaping (_ finished: Bool) -> ())
    {
        purchaseController.findProductsAsyncWithIdentifiers(productIdentifiers, completion: completion)
    }
    
    public class func priceProduct(_ productIdentifier: String) -> String?
    {
        return purchaseController.findPriceProduct(productIdentifier)
    }
    
    public class func buyproduct(_ productIdentifier: String, block: ISPurchaseBuyProductResultBlock?)
    {
        purchaseController.buyProductAsyncWithIdentifier(productIdentifier).continueWith { task  in
            block?(task.error as NSError?)
        }
    }
    
    public class func restore()
    {
        purchaseController.paymentQueue.restoreCompletedTransactions()
    }
    
    ///--------------------------------------
    // MARK - Purchase Controller
    ///--------------------------------------
    
    static let purchaseController: PurchaseController = {
        return PurchaseController()
    }()
}
