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
    
    init(title: String?, isbn: String?, publisher: String?, tags: [String], coverImage: UIImage?) {
        self.headline       = title
        self.isbn           = isbn
        self.publisher      = publisher
        self.tags           = tags
        self.coverImage     = coverImage
    }
    
    init(coreDataEntity: BookEntity) {
        self.headline       = coreDataEntity.headline
        self.isbn           = coreDataEntity.isbn
        self.publisher      = coreDataEntity.publisher
        self.tags           = coreDataEntity.tags
        self.coverImage     = UIImage(data: coreDataEntity.coverImage ?? Data())
    }
    
    func saveToCoreData(context: NSManagedObjectContext) -> BookEntity {
        
        let entity = BookEntity(context: context)
        
        entity.headline     = self.headline
        entity.isbn         = self.isbn
        entity.publisher    = self.publisher
        entity.tags         = self.tags
        entity.coverImage   = self.coverImage?.pngData()
        
        return entity
    }
    
}
