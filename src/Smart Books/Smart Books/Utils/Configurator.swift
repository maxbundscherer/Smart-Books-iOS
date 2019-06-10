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
    
    private let networkService  = NetworkService.shared
    private let jsonService     = JsonService.shared
    
    private init() {
        
        //TODO: Remove create example data
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
        
        
        let entity = BookEntityDto(title: "Buchtitel \(getAllBooks().count)",
                                   isbn: "1234",
                                   publisher: "MB Books",
                                   tags: ["tag1", "tag2"],
                                   coverImage: UIImage(named: coverFileName))
        
        _ = createBook(value: entity)
    }

    func createBook(value: BookEntityDto) -> Bool {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            
            NSLog("Error: Save failure 'appDelegate'")
            return false
        }
        
        let managementContext = appDelegate.persistentContainer.viewContext
        
        value.saveToCoreData(context: managementContext)
        
        do {
            try managementContext.save()
            return true
        } catch let error as NSError {
            NSLog("Error: Save failure '\(error)'")
            return false
        }
        
    }
    
    func deleteBook(value: BookEntity?) -> Bool {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            
            NSLog("Error: Delete failure 'appDelegate'")
            return false
        }
        
        let managementContext = appDelegate.persistentContainer.viewContext
        
        guard let entity: BookEntity = value else { return false }
        
        managementContext.delete(entity)
        
        do {
            try managementContext.save()
            return true
        } catch let error as NSError {
            NSLog("Error: Delete failure '\(error)'")
            return false
        }
        
    }
    
    func getAllBooks() -> [BookEntity] {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            
            NSLog("Error: Fetch failure 'appDelegate'")
            return []
        }
        
        let managementContext = appDelegate.persistentContainer.viewContext
    
        do {
            return try managementContext.fetch(BookEntity.fetchRequest())
        } catch let error as NSError {
            NSLog("Error: Fetch failure '\(error)'")
            return []
        }
        
    }
    
}
