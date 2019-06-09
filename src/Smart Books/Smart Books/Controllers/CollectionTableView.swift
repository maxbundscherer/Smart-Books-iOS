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
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UITextView!
}

class CollectionTableViewController: UITableViewController {
    
    //TODO: Implement data structure
    private let bookEnitiesKeys: [UUID]         = Configurator.shared.exampleData.map { (key, value) in key }
    private let bookEnitiesValues: [BookEntity] = Configurator.shared.exampleData.map { (key, value) in value }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookEnitiesKeys.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView
            .dequeueReusableCell(withIdentifier: "PrototypeCellBook", for: indexPath) as! PrototypeCellBook

        let bookEntity: BookEntity = self.bookEnitiesValues[indexPath.row]
        
        cell.cover.image = bookEntity.coverImage
        cell.title.text  = bookEntity.title
        cell.desc.text   = StringConverters.convertBookEntityToDescription(value: bookEntity)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let bookEntityId: UUID = self.bookEnitiesKeys[indexPath.row]

        performSegue(withIdentifier: "sgShowBook", sender: bookEntityId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let bookEntityId: UUID    = sender as? UUID else { return }
        guard let dest: SingleBookView  = segue.destination as? SingleBookView else { return }
    
        dest.passedBookEntityId = bookEntityId
    }

}
