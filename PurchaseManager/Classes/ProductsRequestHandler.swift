//
//  ITSProductsRequestHandler.swift
//  Cize
//
//  Created by Ziad Tamim on 5/3/16.
//  Copyright © 2016 Intensify Studio. All rights reserved.
//

import Foundation
import StoreKit

typealias ITSProductsRequestHandlerBlock = (_ result: ProductsRequestResult?, _ error : NSError?) -> Void

class ProductsRequestResult: NSObject
{
    var validProducts: Set<SKProduct>!
    var invalidProductIdentifiers: Set<String>!
    
    init(response: SKProductsResponse)
    {
        super.init()
        validProducts = Set(response.products)
        invalidProductIdentifiers = Set(response.invalidProductIdentifiers)
    }
}

class ITSProductsRequestHandler: NSObject, SKProductsRequestDelegate
{
    var productsRequest: SKProductsRequest!
    
    var handler: ITSProductsRequestHandlerBlock?
    
    ///--------------------------------------
    // MARK - Init
    ///--------------------------------------
    
    init(request: SKProductsRequest)
    {
        super.init()
        productsRequest = request
        productsRequest.delegate = self
    }
    
    deinit
    {
        productsRequest.delegate = nil
    }
    
    ///--------------------------------------
    // MARK - Find
    ///--------------------------------------
    
    func findProductsAsync(handler: @escaping ITSProductsRequestHandlerBlock)
    {
        self.handler = handler
        
        productsRequest.start()
    }
    
    ///--------------------------------------
    // MARK - SKProductsRequestDelegate
    ///--------------------------------------
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse)
    {
        productsRequest.delegate = nil
        
        let result = ProductsRequestResult(response: response)
        handler?(result, nil)
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error)
    {
        handler?(nil, error as NSError?)
        
        productsRequest.delegate = nil
    }
    
    func requestDidFinish(_ request: SKRequest)
    {
        productsRequest.delegate = nil
    }
}
