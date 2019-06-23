//
//  CollectionTableViewController.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 09.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import UIKit

class PrototypeCellBook: UITableViewCell {
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var headline: UILabel!
    @IBOutlet weak var desc: UITextView!
}

class CollectionTableView: UITableViewController {
    
    var passedEntities: [BookEntity]?
    
    private var entities: [BookEntity] = []

    override func viewDidLoad() {
        reloadData()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadData()
        self.tableView.reloadData()
    }
    
    private func reloadData() {
        if(self.passedEntities == nil) {
            self.entities = StorageService.shared.getAllBooks()
        }
        else {
            self.entities = self.passedEntities!
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entities.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView
            .dequeueReusableCell(withIdentifier: "PrototypeCellBook", for: indexPath) as! PrototypeCellBook

        let book: BookEntityDto = BookEntityDto(coreDataEntity: self.entities[indexPath.row])
        
        cell.cover.image    = book.coverImage
        cell.headline.text  = book.headline
        cell.desc.text      = StringConverterService.shared.convertBookToDescription(book: book)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let entity: BookEntity = self.entities[indexPath.row]

        performSegue(withIdentifier: "sgShowBook", sender: entity)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let entity:   BookEntity      = sender as? BookEntity else { return }
        guard let dest:     SingleBookView  = segue.destination as? SingleBookView else { return }
    
        dest.passedEntity = entity
    }

}
