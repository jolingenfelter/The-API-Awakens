//
//  Priceable.swift
//  TheAPIAwakens
//
//  Created by Joanna Lingenfelter on 9/13/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation

enum ConversionError: String, Error {
    case UnavailableCost = "Missing price information"
    case InvalidExchangeRate = "Invalid Exchange Rate"
}

protocol Priceable {
    var costDouble: Double? { get set }
    var costString: String? { get }
}

extension Priceable {
    
    func usdCost(exchangeRate: Double, completion: @escaping (Double) -> ()) throws {
        
        guard costString != "unknown" || costString == nil else {
            throw ConversionError.UnavailableCost
        }
        
       guard let costDouble = costDouble, exchangeRate > 0 else {
            throw ConversionError.InvalidExchangeRate
        }
            
        completion(costDouble * exchangeRate)
    
    }
}
