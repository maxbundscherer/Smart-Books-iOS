//
//  JsonConverter.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 09.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import Foundation

class JsonService {
    
    private struct JSONBookResultEntity: Decodable {
        let title: String
        let publisher: String
    }
    
    private struct JSONBookResult: Decodable {
        let book: JSONBookResultEntity
    }
    
    static let shared = JsonService()
    
    private init() {
        
    }
    
    /// Convert JSON Result to Book
    ///
    /// - Parameter data: JSON Result
    /// - Returns: (Left = BookEntityDto?, errorMessage?)
    func convertJSONResultToBook(data: Data) -> ( BookEntityDto?, String? ) {
        
        do {
            
            let result: JSONBookResult = try JSONDecoder().decode(JSONBookResult.self, from: data)
            let book: BookEntityDto = BookEntityDto(title: result.book.title.trimmingCharacters(in: .whitespacesAndNewlines), publisher: result.book.publisher.trimmingCharacters(in: .whitespacesAndNewlines))
            
            return(book, nil)
        }
        catch {
            
            return (nil, "Es konnte kein Buch gefunden werden.")
        }
        
    }
    
}
