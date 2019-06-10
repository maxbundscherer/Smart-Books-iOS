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
    
    var passedBook: BookEntityDto?
    
    override func viewDidLoad() {
        
        guard let book: BookEntityDto = self.passedBook else { return }
        
        self.headline.text  = book.headline
        self.cover.image    = book.coverImage
        self.desc.text      = StringConverters.convertBookEntityToDescription(value: book)
        
        super.viewDidLoad()
    }

}
