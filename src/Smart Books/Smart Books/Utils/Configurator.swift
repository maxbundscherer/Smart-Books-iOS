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
    
    private let networkService  = NetworkService.shared
    private let jsonService     = JsonService.shared
    
    private init() {
    }
    
    let exampleData: [UUID : BookEntity] =
    
    [
    UUID(): BookEntity(
            title: "Buchtitel 1",
            isbn: "1234",
            publisher: "MB Books",
            tags: ["tag1", "tag2"],
            coverImage: UIImage(named: "exampleCoverOne")),
        
    UUID(): BookEntity(
            title: "Buchtitel 2",
            isbn: "5678",
            publisher: "TM Books",
            tags: ["tag3", "tag4"],
            coverImage: UIImage(named: "exampleCoverTwo")),
        
    UUID(): BookEntity(
            title: "Buchtitel 3",
            isbn: "9123",
            publisher: "ZW Books",
            tags: ["tag5", "tag6"],
            coverImage: UIImage(named: "exampleCoverThree"))
    ]
    
}
