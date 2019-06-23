//
//  SearchBookView.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 13.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import UIKit

class SearchBookViewController: UIViewController {

    /*
     UI
     */
    @IBOutlet weak var textFieldSearchword: UITextField!
    
    override func viewDidLoad() {
        
        initAutoKeyboardDismiss()
        super.viewDidLoad()
    }
    
    @IBAction func buttonSearchAction(_ sender: Any) {
        
        dismissKeyboard()
        performSegue(withIdentifier: "sgShowCollection", sender: (self.textFieldSearchword.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let searchString:   String        = sender as? String else { return }
        guard let dest:     CollectionTableViewController = segue.destination as? CollectionTableViewController else { return }
        
        dest.passedEntities = StorageService.shared.queryBooks(searchString: searchString)
    }
    
}
