//
//  Configurator.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 09.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import Foundation
import UIKit

class Configurator {
    
    static let shared   = Configurator()
    
    private let network         = Network.shared
    private let jsonConverter   = JsonConverter.shared
    
    private init() {
    }
    
    func getExampleData() -> [BookEntity] {
        
        let bookOne: BookEntity = BookEntity(
            title: "Haha",
            isbn: "1234",
            publisher: "MB Books",
            tags: ["tag1", "tag2"],
            coverImage: UIImage(named: "exampleCoverOne"))
        
        let bookTwo: BookEntity = BookEntity(
            title: "Haha",
            isbn: "1234",
            publisher: "MB Books",
            tags: ["tag1", "tag2"],
            coverImage: UIImage(named: "exampleCoverTwo"))
        
        let bookThree: BookEntity = BookEntity(
            title: "Haha",
            isbn: "1234",
            publisher: "MB Books",
            tags: ["tag1", "tag2"],
            coverImage: UIImage(named: "exampleCoverThree"))
        
        return [bookOne, bookTwo, bookThree]
    }
    
}
