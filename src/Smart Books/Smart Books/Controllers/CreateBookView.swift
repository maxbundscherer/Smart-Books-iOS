//
//  CreateBookView.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 13.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import UIKit

class CreateBookView: UIViewController, BarcodeScannerHelperDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonManInputAction(_ sender: Any) {
        
        performSegue(withIdentifier: "sgEditBook", sender: nil)
    }
    
    @IBAction func buttonCameraAction(_ sender: Any) {
        
        let barcodeScannerHelper = BarcodeScannerHelper()
        
        barcodeScannerHelper.delegate             = self
        barcodeScannerHelper.codeDelegate         = barcodeScannerHelper
        barcodeScannerHelper.errorDelegate        = barcodeScannerHelper
        barcodeScannerHelper.dismissalDelegate    = barcodeScannerHelper
        
        present(barcodeScannerHelper, animated: true, completion: nil)
    }
    
    @IBAction func buttonChatAction(_ sender: Any) {
    }
    
    func editPreparedBookDto(dto: BookEntityDto) {
        
        performSegue(withIdentifier: "sgEditBook", sender: dto)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let dto:      BookEntityDto       = sender as? BookEntityDto else { return }
        guard let dest:     EditBookTableView   = segue.destination as? EditBookTableView else { return }
        
        dest.passedDto = dto
    }
    
}
