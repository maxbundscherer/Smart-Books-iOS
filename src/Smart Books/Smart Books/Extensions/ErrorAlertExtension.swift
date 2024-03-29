//
//  ErrorShower.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 14.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showErrorAlert(msg: String) {
        
        let alert = UIAlertController(title: "Fehler", message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
