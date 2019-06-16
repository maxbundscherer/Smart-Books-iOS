//
//  BookLookupService.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 14.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import Foundation

class BookLookUpService {
    
    static let shared = BookLookUpService()
    
    private init() {
        
    }
    
    /// Request data from ISBN-Database
    ///
    /// - Parameter isbn13: ISBN13
    /// - Returns: (Left = BookEntityDto?, errorMessage?)
    private func processData(isbn13: String) -> ( BookEntityDto?, String? ) {
        
        var returnResultData: ( BookEntityDto?, String? ) = (nil, nil)
        
        NetworkService.shared.getRequest(
            targetUrl: "https://api2.isbndb.com/book/\(isbn13))",
            headerParams: ["Authorization": Configurator.shared.getTokenForBookLookup()]) { (data, errorMessage) in
            
                if(data != nil) {
                    //No network error
                    returnResultData = JsonService.shared.convertJSONResultToBook(data: data!)
                }
                else {
                    //Network error
                    returnResultData = (nil, "Es gab ein Netzwerkproblem '\(errorMessage ?? "Unbekannter Fehler")'")
                }
                
        }
        
        //TODO: Remove blocked waiting
        while ( returnResultData.0 == nil && returnResultData.1 == nil ) {
            
            NSLog("Iam waiting")
            sleep(2)
        }
        
        return returnResultData
    }
    
    /// Lookup Book by EAN (ISBN 13 = EAN without '-')
    ///
    /// - Parameter ean: EAN
    /// - Returns: (Left = BookEntityDto / Right = errorMessage?)
    func lookupBook(ean13: String) -> (BookEntityDto, String?) {
        
        var isbn13: String = ean13
        isbn13.insert("-", at: isbn13.index(isbn13.startIndex, offsetBy: 3))
        isbn13.insert("-", at: isbn13.index(isbn13.startIndex, offsetBy: 5))
        isbn13.insert("-", at: isbn13.index(isbn13.startIndex, offsetBy: 8))
        isbn13.insert("-", at: isbn13.index(isbn13.startIndex, offsetBy: 15))
        
        let result: ( BookEntityDto?, String? ) = processData(isbn13: isbn13)
        
        let preparedDto: BookEntityDto = result.0 ?? BookEntityDto()
        preparedDto.isbn = isbn13
        
        return (preparedDto, result.1)
    }
    
}
