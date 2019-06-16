//
//  BarcodeScanner.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 14.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import Foundation
import BarcodeScanner

protocol BarcodescannerViewDelegate {
    
    func barcodescannerViewSuccess(ean: String)
    func barcodescannerViewFailure(errorMessage: String)
    func barcodescannerViewDismiss()
    
}

class BarcodescannerView: BarcodeScannerViewController {
    
    var delegate: BarcodescannerViewDelegate?
    
}

extension BarcodescannerView: BarcodeScannerCodeDelegate {
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        
        if(type == "org.gs1.EAN-13") {
            
            //Barcode is from a book
            self.dismiss(animated: true, completion: {
                self.delegate?.barcodescannerViewSuccess(ean: code)
            })
            
        }
        else {
            
            //Barcode is not from a book
            self.dismiss(animated: true, completion: {
                self.delegate?.barcodescannerViewFailure(errorMessage: "Bitte scannen Sie einen Barcode von einem Buch.")
            })
        }
        
    }
}

extension BarcodescannerView: BarcodeScannerErrorDelegate {
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        
        self.dismiss(animated: true, completion: {
            self.delegate?.barcodescannerViewFailure(errorMessage: "Beim Scannen des Barcodes ist ein Fehler aufgetreten: \n\n\(error.localizedDescription)")
        })
    }
}

extension BarcodescannerView: BarcodeScannerDismissalDelegate {
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        
        controller.dismiss(animated: true, completion: {
            self.delegate?.barcodescannerViewDismiss()
        })
    }
}
