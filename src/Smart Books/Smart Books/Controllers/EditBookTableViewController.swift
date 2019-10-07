//
//  EditBookTableView.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 10.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import UIKit
import AVKit

class EditBookTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var passedEntity: BookEntity?
    var passedDto: BookEntityDto?
    
    private var storedDto: BookEntityDto?
    private var attributes: [Int : Attribute] = [:]
    
    private var flagHasCameraAccess: Bool   = false
    private let imagePicker                 = UIImagePickerController()
    
    private struct Attribute {
        let key: String
        let value: String
    }
    
    override func viewDidLoad() {
        
        if(self.passedEntity == nil) {
            
            /*
             Add-Mode
            */
            if(self.passedDto == nil) {
                
                //No dto passed
                self.storedDto = BookEntityDto()
            }
            else {
                
                //Dto passed
                self.storedDto = self.passedDto!
            }
        }
        else {
            
            /*
             Edit-Mode
             */
            self.storedDto = BookEntityDto(coreDataEntity: self.passedEntity!)
        }
        
        reloadData()
        self.imagePicker.delegate = self
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            self.flagHasCameraAccess = response
        }
        
    }
    
    private func reloadData() {
        
        guard let dto: BookEntityDto = self.storedDto else { return }
        
        var coverString: String
        
        if(dto.coverImage == nil || dto.coverImage == UIImage()) {
            coverString = "[kein Cover hinterlegt]"
        }
        else {
            coverString = "[Cover hinterlegt]"
        }
        
        self.attributes = [
            0: Attribute(key: "Titel", value: dto.headline ?? ""),
            1: Attribute(key: "ISBN", value: dto.isbn ?? ""),
            2: Attribute(key: "Verlag", value: dto.publisher ?? ""),
            3: Attribute(key: "Autor", value: dto.author ?? ""),
            4: Attribute(key: "Tags", value: (dto.tags ?? []).joined(separator: "; ")),
            5: Attribute(key: "Cover", value: coverString)
            ]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView
            .dequeueReusableCell(withIdentifier: "PrototypeCellAttribute", for: indexPath)
        
        cell.textLabel?.text        = self.attributes[indexPath.row]?.key
        cell.detailTextLabel?.text  = self.attributes[indexPath.row]?.value
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let indexKey: Int       = indexPath.row
        let key: String         = self.attributes[indexPath.row]?.key ?? ""
        var value: String       = self.attributes[indexPath.row]?.value ?? ""
        
        if(indexKey == 5) {
            
            //Editing 'Cover'
            triggerCamera()
        }
        else {
            
            //Editing anything else than 'Cover'
            var message: String = ""
            
            if(indexKey == 4) {
                //Editing 'Tags'
                message += "Bitte durch ; getrennt ohne Leerzeichen eingeben."
                value = value.replacingOccurrences(of: " ", with: "")
            }
            
            let alert = UIAlertController(title: key, message: message, preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.text = value.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
            alert.addAction(UIAlertAction(title: "Übernehmen", style: .default, handler: { [weak alert] (_) in
                
                let newValue: String = (alert?.textFields?[0].text ?? value).trimmingCharacters(in: .whitespacesAndNewlines)
                
                self.writeChangesToDto(indexKey: indexKey, newValue: newValue)
            }))
            
            alert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    private func writeChangesToDto(indexKey: Int, newValue: String) {
        
        guard let dto: BookEntityDto = self.storedDto else { return }
        
        switch indexKey {
            
            case 0:
                //Editing 'Headline'
                dto.headline = newValue
            
            case 1:
                //Editing 'ISBN'
                dto.isbn = newValue
            
            case 2:
                //Editing 'Publisher'
                dto.publisher = newValue
            
            case 3:
                //Editing 'Author'
                dto.author = newValue
            
            case 4:
                //Editing 'Tags'
                dto.tags = newValue.split(separator: ";").map({ (subString) in String(subString) })
            
            default:
                return
        }
        
        reloadData()
        self.tableView.reloadData()
    }
    
    private func triggerCamera() {
        
        let cameraAvailableFlag : Bool = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        let accessFlag: Bool = (self.flagHasCameraAccess && cameraAvailableFlag)
        
        switch accessFlag {
            
            case true:
                
                self.imagePicker.allowsEditing           = false
                self.imagePicker.sourceType              = .camera
                self.imagePicker.cameraCaptureMode       = .photo
                self.imagePicker.modalPresentationStyle  = .fullScreen
                
                self.present(self.imagePicker, animated: true, completion: nil)
            
            default:
                
                showErrorAlert(msg: "Ihr Gerät hat keine Kamera oder die Anwendung hat keine Berechtigung um auf die Kamera zuzugreifen.")
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let dto: BookEntityDto = self.storedDto else { return }
        
        dismiss(animated:true, completion: {
        
            guard let chosenImage: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            
            dto.coverImage = chosenImage.fixedOrientation() ?? UIImage()
            self.reloadData()
            self.tableView.reloadData()
        
        })
    }
    
    
    @IBAction func barButtonSaveAction(_ sender: Any) {
        
        guard let dto: BookEntityDto = self.storedDto else { return }
        
        var result: Bool = false
        
        if(self.passedEntity == nil) {
            
            //Add-Mode
            if(StorageService.shared.createBook(dto: dto) != nil) { result = true }
        }
        else {
            
            //Edit-Mode
            result = StorageService.shared.updateBook(entity: self.passedEntity!, dto: dto)
        }
        
        if(result) {
            
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
}
