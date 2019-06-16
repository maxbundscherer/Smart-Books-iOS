//
//  Network.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 09.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {
        
    }
    
    /// Get Request (network request)
    ///
    /// - Parameters:
    ///   - targetUrl: Url (example google.de)
    ///   - headerParams: Header-Parameters [ key : value ]
    ///   - completion: (Left = Data? / Right = errorMessage?)
    func getRequest( targetUrl: String, headerParams: [String : String] = [:], completion: @escaping (Data?, String?) -> () ) {
        
        guard let url: URL          = URL(string: targetUrl) else {
            completion(nil, "Invalid url")
            return
        }
        
        var request = URLRequest(url: url)
        
        for (headerKey, headerValue) in headerParams {
            request.setValue(headerKey, forHTTPHeaderField: headerValue)
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
