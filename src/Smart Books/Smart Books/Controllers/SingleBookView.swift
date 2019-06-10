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
    
    var passedEntity: BookEntity?
    
    override func viewDidLoad() {
        
        guard let entity: BookEntity = self.passedEntity else { return }
        let book: BookEntityDto = BookEntityDto(coreDataEntity: entity)
        
        self.headline.text  = book.headline
        self.cover.image    = book.coverImage
        self.desc.text      = StringConverters.convertBookEntityToDescription(value: book)
        
        super.viewDidLoad()
    }
    
    @IBAction func buttonRemoveAction(_ sender: Any) {
        
        switch Configurator.shared.deleteBook(value: passedEntity) {
            
            case true:
                navigationController?.popViewController(animated: true)
            
            default:
                return
            
        }
        
    }
    
    @IBAction func buttonEditAction(_ sender: Any) {
        
        performSegue(withIdentifier: "sgEditBook", sender: passedEntity)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let entity:   BookEntity          = sender as? BookEntity else { return }
        guard let dest:     EditBookTableView   = segue.destination as? EditBookTableView else { return }
        
        dest.passedEntity = entity
    }
    
}
