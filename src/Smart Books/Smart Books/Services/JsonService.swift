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
    
    private struct JSONBookResultEntity: Decodable {
        let title: String
        let publisher: String
    }
    
    private struct JSONBookResult: Decodable {
        let book: JSONBookResultEntity
    }
    
    /// Convert JSON-Data to Book
    ///
    /// - Parameter data: JSON-Data
    /// - Returns: Dto?
    func convertDataToBook(data: Data) -> BookEntityDto? {
        
        do {
            
            let result: JSONBookResult = try JSONDecoder().decode(JSONBookResult.self, from: data)
            let book: BookEntityDto = BookEntityDto(title: result.book.title.trimmingCharacters(in: .whitespacesAndNewlines), publisher: result.book.publisher.trimmingCharacters(in: .whitespacesAndNewlines))
            
            return(book)
        }
        catch {
            
            return nil
        }
        
    }
    
}
