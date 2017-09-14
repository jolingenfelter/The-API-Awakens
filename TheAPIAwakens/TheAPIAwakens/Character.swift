//
//  Character.swift
//  TheAPIAwakens
//
//  Created by Joanna Lingenfelter on 9/11/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation

struct Character {
    
    let name: String?
    let yearOfBirth: String?
    let heightString: String?
    let eyeColor: String?
    let hairColor: String?
    let homeURL: String?
    let vehicles: [String]?
    
    let heightDouble: Double?
    
}

extension Character: JSONDecodable {
    
    init?(JSON: [String : AnyObject]) {
        name = JSON["name"] as? String
        yearOfBirth = JSON["birth_year"] as? String
        heightString = JSON["height"] as? String
        eyeColor = JSON["eye_color"] as? String
        hairColor = JSON["hair_color"] as? String
        homeURL = JSON["homeworld"] as? String
        vehicles = JSON["vehicles"] as? [String]
        
        if let characterHeight = self.heightString {
            self.heightDouble = Double(characterHeight)
        } else {
            self.heightDouble = 0
        }
    }
}
