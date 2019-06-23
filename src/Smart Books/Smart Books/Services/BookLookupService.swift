//
//  BookLookupService.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 14.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import Foundation

class BookLookupService {
    
    static let shared = BookLookupService()
    
    private init() {
        
    }
    
    /// Lookup book by ean in isbn database
    ///
    /// - Parameters:
    ///   - ean: ean
    ///   - completion: (0 = dto? / 1 = errorMessage? / 2 = isbn)
    func lookupBookByEan(ean: String, completion: @escaping (BookEntityDto?, String?, String) -> ()) {
        
        var isbn: String = ean
        
        isbn.insert("-", at: isbn.index(isbn.startIndex, offsetBy: 3))
        isbn.insert("-", at: isbn.index(isbn.startIndex, offsetBy: 5))
        isbn.insert("-", at: isbn.index(isbn.startIndex, offsetBy: 8))
        isbn.insert("-", at: isbn.index(isbn.startIndex, offsetBy: 15))
        
        processIsbnToBook(isbn: isbn) { (dto, errorMessage) in
            completion(dto, errorMessage, isbn)
        }
    }
    
    /// Process isbn to book
    ///
    /// - Parameters:
    ///   - isbn: isbn
    ///   - completion: (0. = dto? / 1. = errorMessage?)
    private func processIsbnToBook(isbn: String, completion: @escaping (BookEntityDto?, String?) -> ()) {
        
        NetworkService.shared.getRequest(
            targetUrl: "https://api2.isbndb.com/book/\(isbn))",
            headerParams: ["Authorization": ConfiguratorService.shared.getTokenForBookLookup()]
        ) {
            
            (dataFromNetworkReq, errorFromNetworkReq) in
            
            if(dataFromNetworkReq != nil && errorFromNetworkReq == nil) {
                
                //Network success
                self.convertDataToBook(data: dataFromNetworkReq!, isbn: isbn, completion: { (dtoFromConverter, errorFromConverter) in
                    completion(dtoFromConverter, errorFromConverter)
                })
                
            }
            else {
                
                //Network error
                completion(nil, "Es ist ein Netzwerkfehler aufgetreten '\(errorFromNetworkReq ?? "Unbekannter Fehler")'.")
            }
            
        }
    
    }
    
    /// Convert data to book
    ///
    /// - Parameters:
    ///   - data: Data from network
    ///   - isbn: isbn
    ///   - completion: (0. = dto? / 1. = errorMessage?)
    private func convertDataToBook(data: Data, isbn: String, completion: @escaping (BookEntityDto?, String?) -> ()) {
        
        let dtoFromConverter: BookEntityDto? = JsonService.shared.convertDataToBook(data: data)
        
        if(dtoFromConverter != nil) {
            
            //Book was found
            dtoFromConverter?.isbn = isbn
            completion(dtoFromConverter!, nil)
            
        }
        else {
            
            //Book was not found
            completion(nil, "Das Buch konnte leider nicht gefunden werden.")
            
        }
        
    }
    
}
