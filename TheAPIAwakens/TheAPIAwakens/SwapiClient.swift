//
//  SwapiClient.swift
//  TheAPIAwakens
//
//  Created by Joanna Lingenfelter on 10/1/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import Foundation

enum Swapi: Endpoint {
    
    case characters
    case vehicles
    case starships
    
    var baseURL: URL {
        return URL(string: "http://swapi.co/api/")!
    }
    
    var path: String {
        switch self {
        case .characters: return "people/"
        case .vehicles: return "vehicles/"
        case .starships: return "starships/"
        }
    }
    
    var request: URLRequest {
        let url = URL(fileURLWithPath: path, relativeTo: baseURL)
        return URLRequest(url: url)
    }
}

final class SwapiClient: APIClient {
    
    let configuration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.configuration)
    }()
    
    init(configuration: URLSessionConfiguration) {
        self.configuration = configuration
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    // MARK: Fetch Characters
    
    func fetchCharacters(_ completion: @escaping (APIResult<[Character]>) -> Void) {
        
        let request = Swapi.characters.request
        
        fetch(request, parse: { json -> [Character]? in
            
            if let characters = json["results"] as? [[String : AnyObject]] {
                return characters.flatMap { characterDictionary in
                    return Character(JSON: characterDictionary)
                }
            } else {
                return nil
            }
            
            }, completion: completion)
    }
    
    // MARK: Fetch Vehicles
    
    func fetchVehicles(_ completion: @escaping (APIResult<[Vehicle]>) -> Void) {
        
        let request = Swapi.vehicles.request
        
        fetch(request, parse: { json -> [Vehicle]? in
            
            if let vehicles = json["results"] as? [[String : AnyObject]] {
                return vehicles.flatMap { vehicleDictionary in
                    return Vehicle(JSON: vehicleDictionary)
                }
            } else {
                return nil
            }
            
            }, completion: completion)
    }
    
    // MARK: Starships
    
    func fetchStarships(_ completion: @escaping (APIResult<[Starship]>) -> Void) {
        
        let request = Swapi.starships.request
        
        fetch(request, parse: { json -> [Starship]? in
            
            if let starships = json["results"] as? [[String : AnyObject]] {
                return starships.flatMap { starshipDictionary in
                    return Starship(JSON: starshipDictionary)
                }
            } else {
                return nil
            }
            
            }, completion: completion)
    }
    
    // MARK: Fetch Home
    
    func fetchCharacterHome(_ character: Character, completion: @escaping(APIResult<Planet>) -> Void) {
        
        if let url = character.homeURL {
            let url = URL(string: url)!
            let request = URLRequest(url: url)
            
            fetch(request, parse: { json -> Planet? in
                
                return Planet(JSON: json)
                
            }, completion: completion)
        }
    }

    // MARK: Fetch Vehicles for character

func fetchCharacterVehicles(_ character: Character, completion: @escaping(APIResult<[Vehicle]>) -> Void) {
   
    var vehiclesArray = [Vehicle]()

    if let vehicleURLArray = character.vehicles {
        for vehicleURL in vehicleURLArray {
            let url = URL(string: vehicleURL)!
            let request = URLRequest(url: url)

            fetch(request, parse: { json -> [Vehicle]? in
                
                let vehicle = Vehicle(JSON: json)
                if let vehicle = vehicle {
                    vehiclesArray.append(vehicle)
                }
                
                return vehiclesArray
                
                }, completion: completion)
            
            }
        }
    }
}
