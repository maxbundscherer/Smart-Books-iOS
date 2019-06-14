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
        
        reloadData()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadData()
    }
    
    private func reloadData() {
        
        guard let entity: BookEntity = self.passedEntity else { return }
        let book: BookEntityDto = BookEntityDto(coreDataEntity: entity)
        
        self.headline.text  = book.headline
        self.cover.image    = book.coverImage
        self.desc.text      = StringHelper.convertBookToDescription(book: book)
    }
    
    @IBAction func buttonRemoveAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Warnung", message: "Möchten Sie dieses Buch wirklich aus Ihrer Sammlung entfernen?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Löschen", style: .destructive, handler: { (_) in
            
            switch StorageService.shared.deleteBook(value: self.passedEntity) {
                
                case true:
                    self.navigationController?.popViewController(animated: true)
                
                default:
                    return
                
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel))
        
        self.present(alert, animated: true, completion: nil)
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
