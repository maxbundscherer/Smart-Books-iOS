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
        
        //TODO: Implement
        print("-\(code)- -\(type)-")
        self.dismiss(animated: true, completion: nil)
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