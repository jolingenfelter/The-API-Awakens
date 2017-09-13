//
//  Starship.swift
//  TheAPIAwakens
//
//  Created by Joanna Lingenfelter on 9/11/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation

struct Starship: Priceable {
    
    let name: String?
    let model: String?
    internal var costString: String?
    let lengthString: String?
    let starshipClass: String?
    let crew: String?
    
    var costDouble: Double?
    let lengthDouble: Double?
    
}

extension Starship: JSONDecodable {
    
    init?(JSON: [String : AnyObject]) {
        name = JSON["name"] as? String
        model = JSON["model"] as? String
        costString = JSON["cost_in_credits"] as? String
        lengthString = JSON["length"] as? String
        starshipClass = JSON["starship_class"] as? String
        crew = JSON["crew"] as? String
        
        if let starshipLength = self.lengthString {
            self.lengthDouble = Double(starshipLength)
        } else {
            self.lengthDouble = 0
        }
        
        if let starshipCost = self.costString {
            self.costDouble = Double(starshipCost)
        } else {
            self.costDouble = 0
        }
    }
}
