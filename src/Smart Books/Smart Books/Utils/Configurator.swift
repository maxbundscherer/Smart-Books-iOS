//
//  Configurator.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 09.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Configurator {
    
    static let shared   = Configurator()
    
    private init() {
        
        if(StorageService.shared.getAllBooks().isEmpty) {
            
            var coverFileName: String = ""
            
            switch Int.random(in: 0..<3) {
                case 0:
                    coverFileName = "exampleCoverOne"
                case 1:
                    coverFileName = "exampleCoverTwo"
                case 2:
                    coverFileName = "exampleCoverThree"
                default:
                    coverFileName = "exampleCoverOne"
            }
            
            let entity = BookEntityDto(title: "Beispielsbuch",
                isbn: "123456789",
                publisher: "Beispielverlag",
                tags: ["tag1", "tag2"],
                coverImage: UIImage(named: coverFileName))
            
            _ = StorageService.shared.createBook(value: entity)
        }
        
    }
    
}
