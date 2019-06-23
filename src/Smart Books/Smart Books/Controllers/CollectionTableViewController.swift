//
//  CollectionTableViewController.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 09.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import UIKit

class PrototypeCellBook: UITableViewCell {
    @IBOutlet weak var imageViewCover: UIImageView!
    @IBOutlet weak var labelHeadline: UILabel!
    @IBOutlet weak var textViewDesc: UITextView!
}

class CollectionTableViewController: UITableViewController {
    
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
            if(self.passedEntities!.isEmpty) { showErrorAlert(msg: "Leider konnte nichts gefunden werden.") }
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
        
        cell.imageViewCover.image   = book.coverImage
        cell.labelHeadline.text     = book.headline
        cell.textViewDesc.text      = StringConverterService.shared.convertBookToDescription(dto: book)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let entity: BookEntity = self.entities[indexPath.row]

        performSegue(withIdentifier: "sgShowBook", sender: entity)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let entity:   BookEntity      = sender as? BookEntity else { return }
        guard let dest:     SingleBookViewController  = segue.destination as? SingleBookViewController else { return }
    
        dest.passedEntity = entity
    }

}
