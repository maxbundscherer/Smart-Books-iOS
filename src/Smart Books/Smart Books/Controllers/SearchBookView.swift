//
//  SearchBookView.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 13.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import UIKit

class SearchBookView: UIViewController {

    @IBOutlet weak var searchword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonSearchAction(_ sender: Any) {
        
        performSegue(withIdentifier: "sgShowCollection", sender: (self.searchword.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let searchString:   String        = sender as? String else { return }
        guard let dest:     CollectionTableView = segue.destination as? CollectionTableView else { return }
        
        dest.passedEntities = StorageService.shared.queryBooks(searchString: searchString)
    }
    
}
