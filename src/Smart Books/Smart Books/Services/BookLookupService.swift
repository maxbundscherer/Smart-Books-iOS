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
    
    /// Lookup Book by EAN (ISBN 13 = EAN without '-')
    ///
    /// - Parameter ean: EAN
    /// - Returns: (Left = BookEntityDto / Right = Optional errorMessage)
    func lookupBook(ean: String) -> (BookEntityDto, String?) {
        
        var isbn13: String = ean
        isbn13.insert("-", at: isbn13.index(isbn13.startIndex, offsetBy: 3))
        isbn13.insert("-", at: isbn13.index(isbn13.startIndex, offsetBy: 5))
        isbn13.insert("-", at: isbn13.index(isbn13.startIndex, offsetBy: 8))
        isbn13.insert("-", at: isbn13.index(isbn13.startIndex, offsetBy: 15))
        
        //TODO: Implement lookup
        
        let t = BookEntityDto()
        t.isbn = isbn13
        
        return (t, "Diese Funktion ist noch nicht implementiert.")
    }
    
}
