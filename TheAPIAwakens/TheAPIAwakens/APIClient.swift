 //
//  APIClient.swift
//  TheAPIAwakens
//
//  Created by Joanna Lingenfelter on 9/30/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import Foundation

public let TRENetworkingErrorDomain = "com.jolingenfelter.APIAwakens.NetworkingError"
public let MissingHTTPResponseError: Int = 10
public let UnexpectedResponseError: Int = 20
 public let AbnormalError: Int = 30

typealias JSON = [String : AnyObject]
typealias JSONTaskCompletion = (JSON?, HTTPURLResponse?, NSError?) -> Void
typealias JSONTask = URLSessionDataTask

enum APIResult<T> {
    case success(T)
    case failure(Error)
}


protocol JSONDecodable {
    init?(JSON: [String: AnyObject])
}

protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var request: URLRequest { get }
}

protocol APIClient {
    var configuration: URLSessionConfiguration { get }
    var session: URLSession { get }
    
    init(configuration: URLSessionConfiguration)
}

extension APIClient {
    func JSONTaskWithRequest(_ request: URLRequest, completion: @escaping JSONTaskCompletion) -> JSONTask {
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            guard let HTTPURLResponse = response as? HTTPURLResponse else {
                let userInfo = [
                    NSLocalizedDescriptionKey: NSLocalizedString("MissingHTTPResponse", comment: "")]
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ConnectionError"), object: nil)
                
                let error = NSError(domain: TRENetworkingErrorDomain, code: MissingHTTPResponseError, userInfo: userInfo)
                
                completion(nil, nil, error)
                return
            }
            
            if data == nil {
                if let error = error {
                    completion(nil, HTTPURLResponse, error as NSError?)
                }
            } else {
                switch HTTPURLResponse.statusCode {
                case 200 :
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : AnyObject]
                        completion(json, HTTPURLResponse, nil)
                    } catch let error as NSError {
                        completion(nil, HTTPURLResponse, error)
                    }
                default: print("Received HTTPResponse: \(HTTPURLResponse.statusCode) - not handled")
                }
            }
            
        })
        
        return task
    }
    
    func fetch<T>(_ request: URLRequest, parse: @escaping (JSON) -> T?, completion: @escaping (APIResult<T>) -> Void) {
        let task = JSONTaskWithRequest(request) { json, response, error in
            
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        let error = NSError(domain: TRENetworkingErrorDomain, code: AbnormalError, userInfo: nil)
                        completion(.failure(error))
                    }
                    
                    return
                }
                
                if let value = parse(json) {
                    completion(.success(value))
                } else {
                    let error = NSError(domain: TRENetworkingErrorDomain, code: UnexpectedResponseError, userInfo: nil)
                    completion(.failure(error))
                }
            }
            
        }
        
        task.resume()
    }
    
}
