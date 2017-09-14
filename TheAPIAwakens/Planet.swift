//
//  Planet.swift
//  TheAPIAwakens
//
//  Created by Joanna Lingenfelter on 9/30/16./Users/Joanna/TechDegreeProjects/TheAPIAwakens/Resources/API_Awakens_Mockups/star-wars-api-vehicles.png
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import Foundation

struct Planet {
    
    let name: String?
}

extension Planet: JSONDecodable {
    
    init?(JSON: [String : AnyObject]) {
        name = JSON["name"] as? String
    }
    
}
