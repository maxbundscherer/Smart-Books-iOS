//
//  SingleBookView.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 09.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import UIKit

class SingleBookView: UIViewController {

    @IBOutlet weak var headline: UILabel!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var desc: UITextView!
    
    var passedBookEntityId: UUID? {
        didSet {
            guard let uuid: UUID = self.passedBookEntityId else { return }
            self.bookEntity = Configurator.shared.exampleData[uuid]
        }
    }
    
    var bookEntity: BookEntity?
    
    override func viewDidLoad() {
        
        guard let entity: BookEntity = self.bookEntity else { return }
        
        self.headline.text  = entity.headline
        self.cover.image    = entity.coverImage
        self.desc.text      = StringConverters.convertBookEntityToDescription(value: entity)
        
        super.viewDidLoad()
    }

}
