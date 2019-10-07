//
//  BookEntity.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 09.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class BookEntityDto {
    
    var headline:       String?
    var isbn:           String?
    var publisher:      String?
    var author:         String?
    var tags:           [String]?
    var coverImage:     UIImage?
    
    init(headline: String?, isbn: String?, publisher: String?, author: String?, tags: [String], coverImage: UIImage?) {
        self.headline       = headline
        self.isbn           = isbn
        self.publisher      = publisher
        self.author         = author
        self.tags           = tags
        self.coverImage     = coverImage
    }
    
    init(isbn: String?) {
        self.headline       = nil
        self.isbn           = isbn
        self.publisher      = nil
        self.author         = nil
        self.tags           = nil
        self.coverImage     = nil
    }
    
    init(headline: String?, publisher: String?) {
        self.headline       = headline
        self.isbn           = nil
        self.publisher      = publisher
        self.author         = nil
        self.tags           = nil
        self.coverImage     = nil
    }
    
    init(coreDataEntity: BookEntity) {
        
        self.headline       = coreDataEntity.headline
        self.isbn           = coreDataEntity.isbn
        self.publisher      = coreDataEntity.publisher
        self.author         = coreDataEntity.author
        self.tags           = coreDataEntity.tags
        
        if(coreDataEntity.coverImage == nil) { self.coverImage = nil }
        else { self.coverImage = UIImage(data: coreDataEntity.coverImage!) }
    }
    
    init() {
        self.headline       = nil
        self.isbn           = nil
        self.publisher      = nil
        self.author         = nil
        self.tags           = nil
        self.coverImage     = nil
    }
    
}
