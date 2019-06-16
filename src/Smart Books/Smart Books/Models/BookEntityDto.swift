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
    var tags:           [String]?
    var coverImage:     UIImage?
    
    init(headline: String?, isbn: String?, publisher: String?, tags: [String], coverImage: UIImage?) {
        self.headline       = headline
        self.isbn           = isbn
        self.publisher      = publisher
        self.tags           = tags
        self.coverImage     = coverImage
    }
    
    init(isbn: String?) {
        self.headline       = nil
        self.isbn           = isbn
        self.publisher      = nil
        self.tags           = []
        self.coverImage     = nil
    }
    
    init(headline: String?, publisher: String?) {
        self.headline       = headline
        self.isbn           = nil
        self.publisher      = publisher
        self.tags           = []
        self.coverImage     = nil
    }
    
    //TODO: Refactor nil
    
    init(coreDataEntity: BookEntity) {
        self.headline       = coreDataEntity.headline
        self.isbn           = coreDataEntity.isbn
        self.publisher      = coreDataEntity.publisher
        self.tags           = coreDataEntity.tags
        self.coverImage     = UIImage(data: coreDataEntity.coverImage ?? Data())
    }
    
    init() {
        self.headline       = nil
        self.isbn           = nil
        self.publisher      = nil
        self.tags           = []
        self.coverImage     = nil
    }
    
}
