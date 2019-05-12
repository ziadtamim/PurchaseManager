//
//  ITSPaymentTransactionObserver.swift
//  Cize
//
//  Created by Ziad Tamim on 5/2/16.
//  Copyright © 2016 Intensify Studio. All rights reserved.
//

import Foundation
import StoreKit

class PaymentTransactionObserver: NSObject,SKPaymentTransactionObserver
{
    
    var blocks = Dictionary<String,Any>()
    var runOnceBlocks = Dictionary<String,Any>()
    
    ///--------------------------------------
    // MARK - SKPaymentTransactionObserver
    ///--------------------------------------
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])
    {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .failed, .restored:
                completeTransation(transaction, fromPaymentQueue: queue)
                break
            case .purchasing,.deferred:
                break
            }
        }
    }
    
    ///--------------------------------------
    // MARK - ITSPaymentTransactionObserver
    ///--------------------------------------
    
    fileprivate func completeTransation(_ transaction: SKPaymentTransaction, fromPaymentQueue queue: SKPaymentQueue)
    {
        let productIdentifier = transaction.payment.productIdentifier
        
        let block  = blocks[productIdentifier] as? (SKPaymentTransaction) -> Void
        if transaction.error == nil && block != nil {
            block?(transaction)
        }
        
        if let runOnceBlock  = runOnceBlocks[productIdentifier] as? (NSError?) -> Void {
            runOnceBlock(transaction.error as NSError?)
            runOnceBlocks.removeValue(forKey: productIdentifier)
        }
        
        queue.finishTransaction(transaction)
    }
    
    ///--------------------------------------
    // MARK - Public
    ///--------------------------------------
    
    func handle(_ productIdentifier: String, block: @escaping (SKPaymentTransaction)->Void)
    {
        blocks[productIdentifier] = block
    }
    
    func handle(_ productIdentifier: String, runOnceBlock: @escaping (NSError?)->Void)
    {
        runOnceBlocks[productIdentifier] = runOnceBlock
    }
}
