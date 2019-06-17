//
//  StorageService.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 13.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class StorageService {
    
    static let shared = StorageService()
    
    private init() {
        
    }
    
    func createBook(value: BookEntityDto) -> BookEntity? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            
            NSLog("Error: Save failure 'appDelegate'")
            return nil
        }
        
        let managementContext = appDelegate.persistentContainer.viewContext
        
        let entity = BookEntity(context: managementContext)
        
        writeChangesToEntity(dto: value, entity: entity)
        
        do {
            try managementContext.save()
            return entity
        } catch let error as NSError {
            NSLog("Error: Save failure '\(error)'")
            return nil
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
    
    func updateBook(entity: BookEntity, value: BookEntityDto) -> Bool {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            
            NSLog("Error: Update failure 'appDelegate'")
            return false
        }
        
        let managementContext = appDelegate.persistentContainer.viewContext
        
        writeChangesToEntity(dto: value, entity: entity)
        
        do {
            try managementContext.save()
            return true
        } catch let error as NSError {
            NSLog("Error: Update failure '\(error)'")
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
    
    func queryBooks(searchString: String) -> [BookEntity] {
        
        //I had to implement the search manually, because fetchRequest can not search in []
        
        let preparedSearchString: String = searchString.lowercased()
        let unfilteredResults: [BookEntity] = getAllBooks()
        
        var filteredResults: Set<BookEntity> = Set()
        
        //TODO: Improve search in tags
        
        for book in unfilteredResults {
            
            if(
                (book.headline ?? "")   .lowercased().contains(preparedSearchString) ||
                (book.isbn ?? "")       .lowercased().contains(preparedSearchString) ||
                (book.publisher ?? "")  .lowercased().contains(preparedSearchString) ||
                (book.tags ?? [])       .contains(preparedSearchString)
                ) { filteredResults.insert(book) }
            
        }
        
        return Array(filteredResults)
    }
    
    private func writeChangesToEntity(dto: BookEntityDto, entity: BookEntity) {
        
        entity.headline     = dto.headline
        entity.isbn         = dto.isbn
        entity.publisher    = dto.publisher
        entity.tags         = dto.tags
        entity.coverImage   = dto.coverImage?.pngData()
        
    }
    
}
