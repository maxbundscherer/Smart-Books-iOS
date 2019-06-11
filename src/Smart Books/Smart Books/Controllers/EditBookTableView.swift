//
//  EditBookTableView.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 10.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import UIKit

class Attribute {
    
    let sortKey: Int
    let key: String
    let value: String
    
    init(sortKey: Int, key: String, value: String) {
        self.sortKey = sortKey
        self.key = key
        self.value = value
    }
}

extension UIImage: UIImageOrientationFix {}

class EditBookTableView: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var passedEntity: BookEntity?
    
    private var attributes: [Attribute] = []
    
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        
        reloadData()
        self.imagePicker.delegate = self
        super.viewDidLoad()
    }
    
    private func reloadData() {
        
        guard let entity: BookEntity = self.passedEntity else { return }
        let book: BookEntityDto = BookEntityDto(coreDataEntity: entity)
        
        self.attributes = [
            Attribute(sortKey: 0, key: "Titel", value: book.headline ?? ""),
            Attribute(sortKey: 1, key: "ISBN", value: book.isbn ?? ""),
            Attribute(sortKey: 2, key: "Verlag", value: book.publisher ?? ""),
            Attribute(sortKey: 3, key: "Tags", value: (book.tags ?? []).joined(separator: "; ")),
            Attribute(sortKey: 4, key: "Cover", value: "")
            ]
            .sorted(by: { $0.sortKey < $1.sortKey })
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
        
        cell.textLabel?.text        = self.attributes[indexPath.row].key
        cell.detailTextLabel?.text  = self.attributes[indexPath.row].value
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let sortKey: Int    = self.attributes[indexPath.row].sortKey
        let key: String     = self.attributes[indexPath.row].key
        var value: String   = self.attributes[indexPath.row].value
        
        if(sortKey == 4) {
            
            //Editing 'Cover'
            triggerCamera()
        }
        else {
            
            //Editing anything else than 'Cover'
            var message: String = ""
            
            if(sortKey == 3) {
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
                
                self.updateEntity(sortKey: sortKey, newValue: newValue)
            }))
            
            alert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    private func updateEntity(sortKey: Int, newValue: String) {
        
        guard let entity: BookEntity = self.passedEntity else { return }
        
        switch sortKey {
            
            case 0:
                //Editing 'Headline'
                entity.headline = newValue
            
            case 1:
                //Editing 'ISBN'
                entity.isbn = newValue
            
            case 2:
                //Editing 'Publisher'
                entity.publisher = newValue
            
            case 3:
                //Editing 'Tags'
                entity.tags = newValue.split(separator: ";").map({ (subString) in String(subString) })
            
            default:
                return
        }
    
        _ = Configurator.shared.saveUpdates()
        
        reloadData()
        self.tableView.reloadData()
    }
    
    private func triggerCamera() {
        
        //TODO: Check access rights
        if (UIImagePickerController.isSourceTypeAvailable(.camera) == true) {
            
            self.imagePicker.allowsEditing           = false
            self.imagePicker.sourceType              = .camera
            self.imagePicker.cameraCaptureMode       = .photo
            self.imagePicker.modalPresentationStyle  = .fullScreen
            
            present(self.imagePicker, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Fehler", message: "Ihr Gerät hat keine Kamera oder die Anwendung hat keine Berechtigung um auf die Kamera zuzugreifen", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let entity: BookEntity = self.passedEntity else { return }
        
        DispatchQueue.main.async {
            
            guard let chosenImage: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            
            entity.coverImage = (chosenImage.fixedOrientation() ?? UIImage()).pngData()
            
            _ = Configurator.shared.saveUpdates()
        }
        
        dismiss(animated:true, completion: nil)
    }

}
