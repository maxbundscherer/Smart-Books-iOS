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

class CollectionTableViewController: UITableViewController {
    
    private let books: [BookEntityDto] = Configurator.shared.getAllBooks()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView
            .dequeueReusableCell(withIdentifier: "PrototypeCellBook", for: indexPath) as! PrototypeCellBook

        let book: BookEntityDto = self.books[indexPath.row]
        
        cell.cover.image    = book.coverImage
        cell.headline.text  = book.headline
        cell.desc.text      = StringConverters.convertBookEntityToDescription(value: book)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let book: BookEntityDto = self.books[indexPath.row]

        performSegue(withIdentifier: "sgShowBook", sender: book)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let book: BookEntityDto   = sender as? BookEntityDto else { return }
        guard let dest: SingleBookView  = segue.destination as? SingleBookView else { return }
    
        dest.passedBook = book
    }

}
