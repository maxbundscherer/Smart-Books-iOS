//
//  JsonConverter.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 09.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import Foundation

class JsonService {
    
    static let shared = JsonService()
    
    private init() {
        
    }
    
    /// Convert JSON Result to Book
    ///
    /// - Parameter data: JSON Result
    /// - Returns: (Left = BookEntityDto?, errorMessage?)
    func convertJSONResultToBook(data: Data) -> ( BookEntityDto?, String? ) {
        
        NSLog("Got json data")
        
        return (nil, "Nicht fertig!")
    }
    
}
