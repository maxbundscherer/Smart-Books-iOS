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
    
    func convertBookToDescription(dto: BookEntityDto) -> String {
        
        return "ISBN:\t\(dto.isbn ?? "")\nVerlag:\t\(dto.publisher ?? "")\nTags:\t\((dto.tags ?? []).joined(separator: "; "))"
    }
    
}
