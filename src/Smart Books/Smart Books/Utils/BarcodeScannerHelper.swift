//
//  BarcodeScanner.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 14.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import Foundation
import BarcodeScanner

extension BarcodeScannerHelper: BarcodeScannerCodeDelegate {
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        
        if(type == "org.gs1.EAN-13") {
            
            //Barcode is from book
            let resultBook: BookEntityDto? = BookLookUpService.shared.lookupBook(ean: code.trimmingCharacters(in: .whitespacesAndNewlines))
            
            if(resultBook == nil) {
                self.dismiss(animated: true, completion: {
                    self.delegate?.barcodeToBookFailure(msg: "Leider konnte kein Buch gefunden werden.")
                })
            }
            else {
                self.dismiss(animated: true, completion: {
                    self.delegate?.barcodeToBookSuccess(dto: resultBook!)
                })
                
            }
            
        }
        else {
            
            //Barcode is not from a book
            self.dismiss(animated: true, completion: {
                self.delegate?.barcodeToBookFailure(msg: "Bitte scannen Sie einen Barcode von einem Buch.")
            })
        }
        
    }
}

extension BarcodeScannerHelper: BarcodeScannerErrorDelegate {
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        
        AlertHelper.showError(msg: "Beim Scannen des Barcodes ist ein Fehler aufgetreten: \n\n\(error.localizedDescription)", viewController: self)
        self.dismiss(animated: true, completion: nil)
    }
}

extension BarcodeScannerHelper: BarcodeScannerDismissalDelegate {
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        
        controller.dismiss(animated: true, completion: nil)
    }
}

protocol BarcodeScannerHelperDelegate {
    
    func barcodeToBookSuccess(dto: BookEntityDto)
    func barcodeToBookFailure(msg: String)
    
}

class BarcodeScannerHelper: BarcodeScannerViewController {
    
    var delegate: BarcodeScannerHelperDelegate?
    
}
