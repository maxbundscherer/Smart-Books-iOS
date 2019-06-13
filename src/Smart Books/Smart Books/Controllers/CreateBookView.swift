//
//  CreateBookView.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 13.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import UIKit

class CreateBookView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonManInputAction(_ sender: Any) {
        
        performSegue(withIdentifier: "sgEditBook", sender: Any)
    }
    
    @IBAction func buttonCameraAction(_ sender: Any) {
    }
    
    @IBAction func buttonChatAction(_ sender: Any) {
    }
    
}
