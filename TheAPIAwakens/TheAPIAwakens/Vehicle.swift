//
//  Vehicle.swift
//  TheAPIAwakens
//
//  Created by Joanna Lingenfelter on 9/11/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation

struct Vehicle: Priceable {
    
    let name: String?
    let model: String?
    internal var costString: String?
    let lengthString: String?
    let vehicleClass: String?
    let crew: String?
    
    let lengthDouble: Double?
    internal var costDouble: Double?
    
}

extension Vehicle: JSONDecodable {
    
    init?(JSON: [String : AnyObject]) {
        name = JSON["name"] as? String
        model = JSON["model"] as? String
        costString = JSON["cost_in_credits"] as? String
        lengthString = JSON["length"] as? String
        vehicleClass = JSON["vehicle_class"] as? String
        crew = JSON["crew"] as? String
        
        if let vehicleLength = self.lengthString {
            self.lengthDouble = Double(vehicleLength)
        } else {
            self.lengthDouble = 0
        }
        
        if let vehicleCost = self.costString {
            self.costDouble = Double(vehicleCost)
        } else {
            self.costDouble = 0
        }
    }
}
