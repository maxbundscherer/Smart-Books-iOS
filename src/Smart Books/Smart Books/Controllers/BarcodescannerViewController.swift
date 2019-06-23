//
//  BarcodeScanner.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 14.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import Foundation
import BarcodeScanner

protocol BarcodescannerViewControllerDelegate {
    
    func barcodescannerViewControllerSuccess(ean: String)
    func barcodescannerViewControllerFailure(errorMessage: String)
    func barcodescannerViewControllerDismiss()
    
}

class BarcodescannerViewController: BarcodeScannerViewController {
    
    var delegate: BarcodescannerViewControllerDelegate?
    
}

extension BarcodescannerViewController: BarcodeScannerCodeDelegate {
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        
        //Validate type
        if(type == ConfiguratorService.shared.getBarcodeEANTypeString()) {
            
            /*
             Barcode is from a book
             */
            self.dismiss(animated: true, completion: {
                self.delegate?.barcodescannerViewControllerSuccess(ean: code)
            })
            
        }
        else {
            
            /*
             Barcode is not from a book
             */
            self.dismiss(animated: true, completion: {
                self.delegate?.barcodescannerViewControllerFailure(errorMessage: "Bitte scannen Sie einen Barcode von einem Buch.")
            })
        }
        
    }
}

extension BarcodescannerViewController: BarcodeScannerErrorDelegate {
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        
        self.dismiss(animated: true, completion: {
            self.delegate?.barcodescannerViewControllerFailure(errorMessage: "Beim Scannen des Barcodes ist ein Fehler aufgetreten: \n\n'\(error.localizedDescription)'.")
        })
    }
}

extension BarcodescannerViewController: BarcodeScannerDismissalDelegate {
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        
        controller.dismiss(animated: true, completion: {
            self.delegate?.barcodescannerViewControllerDismiss()
        })
    }
}
