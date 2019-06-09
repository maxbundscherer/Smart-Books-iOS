//
//  BookEntity.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 09.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import Foundation
import UIKit

class BookEntity {
 
    var title: String?
    var isbn: String?
    var publisher: String?
    var tags: [String]
    var coverImage: UIImage?
    
    init(title: String?, isbn: String?, publisher: String?, tags: [String], coverImage: UIImage?) {
        self.title = title
        self.isbn = isbn
        self.publisher = publisher
        self.tags = tags
        self.coverImage = coverImage
    }
    
}
