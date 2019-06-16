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
        
    }
    
    func loadExampleData() {
        
        if(StorageService.shared.getAllBooks().isEmpty) {
            
            let entityOne = BookEntityDto(headline: "Der Struwwelpeter",
                                          isbn: "978-3-937467-78-8",
                                          publisher: "Edition Tintenfaß",
                                          tags: ["kinderbuch", "erinnerung"],
                                          coverImage: UIImage(named: "exampleCoverOne"))
            
            let entityTwo = BookEntityDto(headline: "Peter Pan",
                                          isbn: "978-3-401-05546-6",
                                          publisher: "Arena Verlag GmbH",
                                          tags: ["kinderbuch", "favorit"],
                                          coverImage: UIImage(named: "exampleCoverTwo"))
            
            let entityThree = BookEntityDto(headline: "Die Bibel",
                                            isbn: "978-3-7306-0273-7",
                                            publisher: "Anaconda Verlag",
                                            tags: ["religion", "langweilig"],
                                            coverImage: UIImage(named: "exampleCoverThree"))
            
            _ = StorageService.shared.createBook(value: entityOne)
            _ = StorageService.shared.createBook(value: entityTwo)
            _ = StorageService.shared.createBook(value: entityThree)
        }
        
    }
    
    //TODO: Implement token
    func getTokenForBookLookup() -> String { return "" }
    
}
