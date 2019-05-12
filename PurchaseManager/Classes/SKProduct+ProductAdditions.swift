//
//  SKProduct+Addition.swift
//  Cize
//
//  Created by Ziad Tamim on 7/4/16.
//  Copyright © 2016 Intensify Studio. All rights reserved.
//

import Foundation
import StoreKit

extension SKProduct
{
    func localizedPrice() -> String
    {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
