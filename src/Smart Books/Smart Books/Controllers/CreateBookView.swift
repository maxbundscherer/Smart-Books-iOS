//
//  CreateBookView.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 13.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import UIKit

class CreateBookView: UIViewController, BarcodescannerViewDelegate {

    private var storedLoadingIndicator: UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonManInputAction(_ sender: Any) {
        
        performSegue(withIdentifier: "sgEditBook", sender: nil)
    }
    
    @IBAction func buttonCameraAction(_ sender: Any) {
        
        let barcodescannerView  = BarcodescannerView()
        
        barcodescannerView.delegate            = self
        barcodescannerView.codeDelegate        = barcodescannerView
        barcodescannerView.errorDelegate       = barcodescannerView
        barcodescannerView.dismissalDelegate   = barcodescannerView
        
        present(barcodescannerView, animated: true, completion: {self.showLoadingIndicator()})
    }
    
    @IBAction func buttonChatAction(_ sender: Any) {
        
        //TODO: Implement conversation
    }
    
    func barcodescannerViewSuccess(ean: String) {
        
        BookLookupService.shared.lookupBookByEan(ean: ean) { (dto, errorMessage, isbn) in
            
            if(errorMessage == nil && dto != nil) {
                
                //Lookup success
                DispatchQueue.main.async {
                    self.hideLoadingIndicator()
                    self.performSegue(withIdentifier: "sgEditBook", sender: dto)
                }
            }
            else {
                
                //Lookup failure
                DispatchQueue.main.async {
                    self.hideLoadingIndicator()
                    let alert = UIAlertController(title: "Hinweis", message: (errorMessage ?? "Unbekannter Fehler") + "\n\n Die ISBN-Nummer konnte trotzdem übernommen werden.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (_) in
                            self.performSegue(withIdentifier: "sgEditBook", sender: BookEntityDto(isbn: isbn))
                        }
                    ))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }
        
    }
    
    func barcodescannerViewFailure(errorMessage: String) {
        self.hideLoadingIndicator()
        AlertHelper.showError(msg: errorMessage, viewController: self)
    }
    
    func barcodescannerViewDismiss() {
        self.hideLoadingIndicator()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let dto:      BookEntityDto       = sender as? BookEntityDto else { return }
        guard let dest:     EditBookTableView   = segue.destination as? EditBookTableView else { return }
        
        dest.passedDto = dto
    }
    
    private func showLoadingIndicator() {
        
        //Please see - http://brainwashinc.com/2017/07/21/loading-activity-indicator-ios-swift/
        
        let spinnerView = UIView.init(frame: self.view.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            self.view.addSubview(spinnerView)
        }
        
        self.storedLoadingIndicator = spinnerView
    }
    
    private func hideLoadingIndicator() {
        
        //Please see - http://brainwashinc.com/2017/07/21/loading-activity-indicator-ios-swift/
        
        DispatchQueue.main.async {
            self.storedLoadingIndicator?.removeFromSuperview()
            self.storedLoadingIndicator = nil
        }
    }
    
}
