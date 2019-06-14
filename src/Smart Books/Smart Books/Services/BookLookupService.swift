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
    
    func lookupBook(ean: String) -> BookEntityDto? {
        
        //TODO: Implement lookup
        let t = BookEntityDto()
        t.headline = "Testbuch123"
        
        return t
    }
    
}
