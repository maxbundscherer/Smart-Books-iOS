//
//  NetworkService.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 16.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {
        
    }
    
    /// Process get request
    ///
    /// - Parameters:
    ///   - targetUrl: Url example google.de
    ///   - headerParams: [Key: Value]
    ///   - completion: (0. = data? / 1. = errorMessage?)
    func getRequest( targetUrl: String, headerParams: [String : String] = [:] , completion: @escaping (Data?, String?) -> () ) {
        
        guard let url: URL          = URL(string: targetUrl) else {
            completion(nil, "Unbekannte Anfrageadresse")
            return
        }
        
        var request = URLRequest(url: url)
        
        for (headerKey, headerValue) in headerParams {
            request.addValue(headerValue, forHTTPHeaderField: headerKey)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let responseData: Data = data, error == nil else {
                completion(nil, error?.localizedDescription)
                return
            }
            
            completion(responseData, nil)
        }
        
        task.resume()
    }
    
}
