//
//  EditBookTableView.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 10.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import UIKit

class Attribute {
    
    let sortKey: Int
    let key: String
    let value: String
    
    init(sortKey: Int, key: String, value: String) {
        self.sortKey = sortKey
        self.key = key
        self.value = value
    }
}

class EditBookTableView: UITableViewController {

    var passedEntity: BookEntity?
    
    var attributes: [Attribute] = []
    
    override func viewDidLoad() {
        
        remapTableCells()
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        
        remapTableCells()
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView
            .dequeueReusableCell(withIdentifier: "PrototypeCellAttribute", for: indexPath)
        
        cell.textLabel?.text        = self.attributes[indexPath.row].key
        cell.detailTextLabel?.text  = self.attributes[indexPath.row].value
        
        return cell
    }
    
    func remapTableCells() {
        
        guard let entity: BookEntity = self.passedEntity else { return }
        let book: BookEntityDto = BookEntityDto(coreDataEntity: entity)
        
        self.attributes = [
            Attribute(sortKey: 0, key: "Titel", value: book.headline ?? ""),
            Attribute(sortKey: 1, key: "ISBN", value: book.isbn ?? ""),
            Attribute(sortKey: 2, key: "Verlag", value: book.publisher ?? ""),
            Attribute(sortKey: 3, key: "Tags", value: (book.tags ?? []).joined(separator: ", ")),
            Attribute(sortKey: 4, key: "Cover", value: "TODO")
            ]
            .sorted(by: { $0.sortKey < $1.sortKey })
    }

}
