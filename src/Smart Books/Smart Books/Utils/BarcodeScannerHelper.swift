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
                AlertHelper.showError(msg: "Leider konnte kein Buch gefunden werden.", viewController: self)
                self.dismiss(animated: true, completion: nil)
            }
            else {
                //TODO: Implement wire
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        else {
            
            //Barcode is not from a book
            AlertHelper.showError(msg: "Bitte scannen Sie einen Barcode von einem Buch.", viewController: self)
            self.dismiss(animated: true, completion: nil)
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

class BarcodeScannerHelper: BarcodeScannerViewController {
    
}
