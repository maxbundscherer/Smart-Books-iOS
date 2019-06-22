//
//  ChatService.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 18.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import Foundation

class ChatService {
    
    private let chatQuestions: [Int : String]
    
    private var dto: BookEntityDto
    private var actQuestion: Int
    
    init() {
        
        self.dto            = BookEntityDto()
        self.actQuestion    = 0
        
        self.chatQuestions  = [
            0: "Wie lautet der Titel des Buches?",
            1: "Alles klar! Wie lautet die ISBN-Nummer des Buches?",
            2: "Übernommen! Wie heißt der Verlag des Buches?",
            3: "Super. Nun die letzte Frage! Unter welchen Schlagwörtern möchten Sie das Buch finden?",
        ]
        
    }
    
    
    /// Get next question
    ///
    /// - Returns: String? (if there is an question available)
    func getNextQuestion() -> String? {
        
        let ret: String? = self.chatQuestions[self.actQuestion]
        self.actQuestion = self.actQuestion + 1
        
        return ret
    }
    
    
    /// Process response to actual question
    ///
    /// - Parameter response: Response to actual question
    /// - Returns: dto? (if there is already an dto available)
    func processResponse(response: String) -> BookEntityDto? {
        
        switch self.actQuestion {
            
            case 1:
                //Editing 'Headline'
                self.dto.headline = response
                return nil
            
            case 2:
                //Editing 'ISBN'
                self.dto.isbn = response
                return nil
            
            case 3:
                //Editing 'Publisher'
                self.dto.publisher = response
                return nil
            
            case 4:
                //Editing 'Tags'
                self.dto.tags = response.split(separator: " ").map({ (subString) in String(subString) })
                return self.dto
            
            default:
                return nil
            
        }
        
    }
    
}
