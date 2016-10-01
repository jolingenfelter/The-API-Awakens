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
    let height: String?
    let eyeColor: String?
    let hairColor: String?
    let homeURL: String?
    
}

extension Character: JSONDecodable {
    
    init?(JSON: [String : AnyObject]) {
        name = JSON["name"] as? String
        yearOfBirth = JSON["birth_year"] as? String
        height = JSON["height"] as? String
        eyeColor = JSON["eye_color"] as? String
        hairColor = JSON["hair_color"] as? String
        homeURL = JSON["homeworld"] as? String
        }
}

// MARK: Vehicles

struct Vehicle {
    
    let name: String?
    let make: String?
    let cost: String?
    let length: String?
    let vehicleClass: String?
    let crew: String?
    
}

extension Vehicle: JSONDecodable {
    
    init?(JSON: [String : AnyObject]) {
        name = JSON["name"] as? String
        make = JSON["model"] as? String
        cost = JSON["cost_in_credits"] as? String
        length = JSON["length"] as? String
        vehicleClass = JSON["vehicle_class"] as? String
        crew = JSON["crew"] as? String
    }
    
}

// MARK: Starships


struct Starship {
    
    let name: String?
    let cost: String?
    let length: String?
    let starshipClass: String?
    let crew: String?
    
}

extension Starship: JSONDecodable {
    
    init?(JSON: [String : AnyObject]) {
        name = JSON["name"] as? String
        cost = JSON["cost_in_credits"] as? String
        length = JSON["length"] as? String
        starshipClass = JSON["starship_class"] as? String
        crew = JSON["crew"] as? String
    }
}
