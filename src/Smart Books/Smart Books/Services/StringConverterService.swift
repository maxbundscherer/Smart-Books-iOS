//
//  StringConverters.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 09.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import Foundation

class StringConverterService {
    
    static let shared = StringConverterService()
    
    private init() {
        
    }
    
    func convertBookToDescription(book: BookEntityDto) -> String {
        
        return "ISBN:\t\(book.isbn ?? "")\nVerlag:\t\(book.publisher ?? "")\nTags:\t\((book.tags ?? []).joined(separator: "; "))"
    }
    
}