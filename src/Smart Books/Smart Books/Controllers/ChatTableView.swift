//
//  ChatTableView.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 17.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import UIKit

class PrototypeCellMsgFromMe: UITableViewCell {
    @IBOutlet weak var msg: UITextView!
}

class PrototypeCellMsgToMe: UITableViewCell {
    @IBOutlet weak var msg: UITextView!
}

class ChatTableView: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

}
