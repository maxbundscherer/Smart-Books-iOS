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
            
            //Barcode is from a book
            let resultLookup: (BookEntityDto, String?) = BookLookUpService.shared.lookupBook(ean13: code.trimmingCharacters(in: .whitespacesAndNewlines))
            
            if(resultLookup.1 != nil) {
                //Book wasnt found
                self.dismiss(animated: true, completion: {
                    self.delegate?.barcodeToBookFailure(dto: resultLookup.0, errorMessage: resultLookup.1!)
                })
            }
            else {
                //Book was found
                self.dismiss(animated: true, completion: {
                    self.delegate?.barcodeToBookSuccess(dto: resultLookup.0)
                })
                
            }
            
        }
        else {
            
            //Barcode is not from a book
            self.dismiss(animated: true, completion: {
                self.delegate?.barcodeToBookFailure(dto: nil, errorMessage: "Bitte scannen Sie einen Barcode von einem Buch.")
            })
        }
        
    }
}

extension BarcodeScannerHelper: BarcodeScannerErrorDelegate {
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        
        self.dismiss(animated: true, completion: {
            self.delegate?.barcodeToBookFailure(dto: nil, errorMessage: "Beim Scannen des Barcodes ist ein Fehler aufgetreten: \n\n\(error.localizedDescription)")
        })
    }
}

extension BarcodeScannerHelper: BarcodeScannerDismissalDelegate {
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        
        controller.dismiss(animated: true, completion: nil)
    }
}

protocol BarcodeScannerHelperDelegate {
    
    func barcodeToBookSuccess(dto: BookEntityDto)
    func barcodeToBookFailure(dto: BookEntityDto?, errorMessage: String)
    
}

class BarcodeScannerHelper: BarcodeScannerViewController {
    
    var delegate: BarcodeScannerHelperDelegate?
    
}
