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

class ConfiguratorService {
    
    static let shared   = ConfiguratorService()
    
    private init() {
        
    }
    
    func prepareDatabase() {
        
        if(StorageService.shared.getAllBooks().isEmpty) {
            
            let entityOne = BookEntityDto(headline: "Der Struwwelpeter",
                                          isbn: "978-3-937467-78-8",
                                          publisher: "Edition Tintenfaß",
                                          tags: ["korrekteSchreibweise"],
                                          coverImage: UIImage(named: "exampleCoverOne"))
            
            let entityTwo = BookEntityDto(headline: "Peter Pan",
                                          isbn: "978-3-401-05546-6",
                                          publisher: "Arena Verlag GmbH",
                                          tags: ["kinderbuch", "favorit"],
                                          coverImage: UIImage(named: "exampleCoverTwo"))
            
            let entityThree = BookEntityDto(headline: "Die Bibel",
                                            isbn: "978-3-7306-0273-7",
                                            publisher: "Anaconda Verlag",
                                            tags: ["religion"],
                                            coverImage: UIImage(named: "exampleCoverThree"))
            
            _ = StorageService.shared.createBook(dto: entityOne)
            _ = StorageService.shared.createBook(dto: entityTwo)
            _ = StorageService.shared.createBook(dto: entityThree)
        }
        
    }
    
    func prepareUI() {
        
        UINavigationBar.appearance().barTintColor           = #colorLiteral(red: 0.009652188979, green: 0.5029947162, blue: 0.7534247041, alpha: 1)
        UINavigationBar.appearance().tintColor              = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes    = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        UINavigationBar.appearance().isTranslucent          = false
        
    }
    
    func getBarcodeEANTypeString()      -> String   { return "org.gs1.EAN-13" }
    
    func getSynthesisVoiceLanguage()    -> String   { return  "de-DE" }
    
    func getSilenceDelay()              -> Double   { return 2 }
    
    //TODO: Put token isbn database in here
    func getTokenForBookLookup()        -> String { return "" }
    
}
