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
    
    func createBook(dto: BookEntityDto) -> BookEntity? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            
            NSLog("Error: Save failure 'appDelegate'")
            return nil
        }
        
        let managementContext = appDelegate.persistentContainer.viewContext
        
        let entity = BookEntity(context: managementContext)
        
        mapDtoToEntity(dto: dto, entity: entity)
        
        do {
            try managementContext.save()
            return entity
        } catch let error as NSError {
            NSLog("Error: Save failure '\(error)'")
            return nil
        }
        
    }
    
    func deleteBook(entity: BookEntity?) -> Bool {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            
            NSLog("Error: Delete failure 'appDelegate'")
            return false
        }
        
        let managementContext = appDelegate.persistentContainer.viewContext
        
        guard let entity: BookEntity = entity else { return false }
        
        managementContext.delete(entity)
        
        do {
            try managementContext.save()
            return true
        } catch let error as NSError {
            NSLog("Error: Delete failure '\(error)'")
            return false
        }
        
    }
    
    func updateBook(entity: BookEntity, dto: BookEntityDto) -> Bool {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            
            NSLog("Error: Update failure 'appDelegate'")
            return false
        }
        
        let managementContext = appDelegate.persistentContainer.viewContext
        
        mapDtoToEntity(dto: dto, entity: entity)
        
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
        
        for book in unfilteredResults {
            
            if(
                (book.headline ?? "")   .lowercased().contains(preparedSearchString) ||
                (book.isbn ?? "")       .lowercased().contains(preparedSearchString) ||
                (book.publisher ?? "")  .lowercased().contains(preparedSearchString) ||
                (book.author ?? "")  .lowercased().contains(preparedSearchString) ||
                (book.tags ?? [])       .contains(preparedSearchString)
                ) { filteredResults.insert(book) }
            
        }
        
        return Array(filteredResults)
    }
    
    private func mapDtoToEntity(dto: BookEntityDto, entity: BookEntity) {
        
        entity.headline     = dto.headline
        entity.isbn         = dto.isbn
        entity.publisher    = dto.publisher
        entity.author       = dto.author
        entity.tags         = dto.tags
        entity.coverImage   = dto.coverImage?.pngData()
        
    }
    
}
