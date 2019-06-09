//
//  StringConverters.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 09.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import Foundation

class StringConverters {
    
    static func convertBookEntityToDescription(value: BookEntity) -> String {
        
        return "ISBN:\t\(value.title ?? "")\nVerlag:\t\(value.publisher ?? "")\nTags:\t\(value.tags.joined(separator: "; "))"
    }
    
}
