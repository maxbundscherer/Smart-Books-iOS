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
        
        performSegue(withIdentifier: "sgEditBook", sender: nil)
    }
    
    @IBAction func buttonCameraAction(_ sender: Any) {
        
        let barcodeScannerHelper = BarcodeScannerHelper()
        
        barcodeScannerHelper.codeDelegate         = barcodeScannerHelper
        barcodeScannerHelper.errorDelegate        = barcodeScannerHelper
        barcodeScannerHelper.dismissalDelegate    = barcodeScannerHelper
        
        present(barcodeScannerHelper, animated: true, completion: nil)
    }
    
    @IBAction func buttonChatAction(_ sender: Any) {
    }
    
}
