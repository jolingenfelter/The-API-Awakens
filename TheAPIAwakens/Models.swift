//
//  Models.swift
//  TheAPIAwakens
//
//  Created by Joanna Lingenfelter on 9/30/16./Users/Joanna/TechDegreeProjects/TheAPIAwakens/Resources/API_Awakens_Mockups/star-wars-api-vehicles.png
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import Foundation

// MARK: Characters

struct Character {
    
    let name: String?
    let yearOfBirth: String?
    let heightString: String?
    let eyeColor: String?
    let hairColor: String?
    let homeURL: String?
    
    let heightInt: Int?
    
}

extension Character: JSONDecodable {
    
    init?(JSON: [String : AnyObject]) {
        name = JSON["name"] as? String
        yearOfBirth = JSON["birth_year"] as? String
        heightString = JSON["height"] as? String
        eyeColor = JSON["eye_color"] as? String
        hairColor = JSON["hair_color"] as? String
        homeURL = JSON["homeworld"] as? String
        
        if let characterHeight = self.heightString {
            self.heightInt = Int(characterHeight)
        } else {
            self.heightInt = 0
        }
    }
}

// MARK: Vehicles

struct Vehicle {
    
    let name: String?
    let make: String?
    let costString: String?
    let lengthString: String?
    let vehicleClass: String?
    let crew: String?
    
    let lengthInt: Int?
    let costInt: Int?
    
}

extension Vehicle: JSONDecodable {
    
    init?(JSON: [String : AnyObject]) {
        name = JSON["name"] as? String
        make = JSON["model"] as? String
        costString = JSON["cost_in_credits"] as? String
        lengthString = JSON["length"] as? String
        vehicleClass = JSON["vehicle_class"] as? String
        crew = JSON["crew"] as? String
        
        if let vehicleLength = self.lengthString {
            self.lengthInt = Int(vehicleLength)
        } else {
            self.lengthInt = 0
        }
        
        if let vehicleCost = self.costString {
            self.costInt = Int(vehicleCost)
        } else {
            self.costInt = 0
        }
    }
}

// MARK: Starships


struct Starship {
    
    let name: String?
    let costString: String?
    let lengthString: String?
    let starshipClass: String?
    let crew: String?
    
    let costInt: Int?
    let lengthInt: Int?
    
}

extension Starship: JSONDecodable {
    
    init?(JSON: [String : AnyObject]) {
        name = JSON["name"] as? String
        costString = JSON["cost_in_credits"] as? String
        lengthString = JSON["length"] as? String
        starshipClass = JSON["starship_class"] as? String
        crew = JSON["crew"] as? String
        
        if let starshipLength = self.lengthString {
            self.lengthInt = Int(starshipLength)
        } else {
            self.lengthInt = 0
        }
        
        if let starshipCost = self.costString {
            self.costInt = Int(starshipCost)
        } else {
            self.costInt = 0
        }
    }
}

// MARK: Planets

struct Planet {
    
    let name: String?
}

extension Planet: JSONDecodable {
    
    init?(JSON: [String : AnyObject]) {
        name = JSON["name"] as? String
    }
    
}
