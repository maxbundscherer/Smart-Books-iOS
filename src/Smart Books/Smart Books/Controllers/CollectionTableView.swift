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
    
    private let exampleData: [UUID : BookEntity] = Configurator.shared.exampleData

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exampleData.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView
            .dequeueReusableCell(withIdentifier: "PrototypeCellBook", for: indexPath) as! PrototypeCellBook

        let bookEntity: BookEntity = exampleData.map { (key, value) in value }[indexPath.row]
        
        cell.cover.image = bookEntity.coverImage
        cell.title.text  = bookEntity.title
        cell.desc.text   = "ISBN:\t\(bookEntity.title ?? "")\nVerlag:\t\(bookEntity.publisher ?? "")\nTags:\t\(bookEntity.tags.joined(separator: "; "))"

        return cell
    }

}
