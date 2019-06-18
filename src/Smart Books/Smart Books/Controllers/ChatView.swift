//
//  ChatTableView.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 17.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import UIKit

protocol ChatViewDelegate {
    
    func chatViewSuccess(dto: BookEntityDto)
    
}

class ChatView: UIViewController {
    
    var delegate: ChatViewDelegate?
    
    @IBOutlet weak var chat: UITableView!
    @IBOutlet weak var myMessage: UITextField!
    
    private let chatService     = ChatService()
    private var chatTableView   = ChatTableView()
    
    private var flagProcessInput: Bool = false
    
    override func viewDidLoad() {
        
        initAutoKeyboardDismiss()
        
        self.chat.delegate              = self.chatTableView
        self.chat.dataSource            = self.chatTableView
        self.chatTableView.tableView    = self.chat
        
        self.chatTableView.initChat()
        startChat()
        
        super.viewDidLoad()
    }
    
    @IBAction func buttonSendTextAction(_ sender: Any) {
        
        if(!self.flagProcessInput) { return }
        
        dismissKeyboard()
        
        //Get msg
        let msg = (myMessage.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Show msg in chat and clear chatInput
        self.chatTableView.addMessageFromMe(msg: msg)
        self.myMessage.text = ""
        
        if(msg != "") {
            processInput(input: msg)
        }
        else {
            self.chatTableView.addMessageToMe(msg: "Bitte reden Sie mit mir!")
        }
        
    }
    
    @IBAction func buttonUseLangAction(_ sender: Any) {
        
        dismissKeyboard()
        
        //TODO: Implement
        let msg = "Diese Funktion ist noch nicht implementiert."
        self.chatTableView.addMessageToMe(msg: msg)
    }
    
    private func processInput(input: String) {
        
        //Process through chat-service
        let dto: BookEntityDto? = self.chatService.processResponse(response: input)
        
        if( dto == nil ) {
            
            //Dto is not ready at the moment
            self.flagProcessInput = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                self.chatTableView.addMessageToMe(msg: self.chatService.getNextQuestion() ?? "Fehler im Chat-Service")
                self.flagProcessInput = true
            })
            
        }
        else {
            
            //Dto is ready at the moment
            self.navigationController?.popViewController(animated: true)
            self.delegate?.chatViewSuccess(dto: dto!)
            
        }
        
    }
    
    private func startChat() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.chatTableView.addMessageToMe(msg: "Hallo, ich bin Ihr interaktiver Assistent!")
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            self.chatTableView.addMessageToMe(msg: "Keine Sorge, falls ich etwas falsch verstehe. Am Ende können Sie Ihr Buch natürlich noch überarbeiten.")
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(8), execute: {
            self.chatTableView.addMessageToMe(msg: self.chatService.getNextQuestion() ?? "Fehler im Chat-Service")
            self.flagProcessInput = true
        })
    }
    
}

class PrototypeCellMsgToMe: UITableViewCell {
    @IBOutlet weak var msg: UITextView!
}

class PrototypeCellMsgFromMe: UITableViewCell {
    @IBOutlet weak var msg: UITextView!
}

class ChatTableView: UITableViewController {
    
    private var chatMessages: [ChatMessage] = []
    
    private struct ChatMessage {
        let timestamp: Double
        let msgFromMe: Bool
        let msg: String
    }
    
    func initChat() {
        
        reloadData()
    }
    
    func addMessageFromMe(msg: String) {
        
        if(msg == "") { return }
        
        self.chatMessages.insert(ChatMessage(timestamp: NSDate().timeIntervalSince1970, msgFromMe: true, msg: msg), at: self.chatMessages.count)
        reloadData()
    }
    
    func addMessageToMe(msg: String) {
        
        if(msg == "") { return }
        
        self.chatMessages.insert(ChatMessage(timestamp: NSDate().timeIntervalSince1970, msgFromMe: false, msg: msg), at: self.chatMessages.count)
        reloadData()
    }
    
    private func reloadData() {
        
        self.tableView.reloadData()
        
        //Scroll to the bottom
        DispatchQueue.main.async {
            if(!self.chatMessages.isEmpty) {
                let indexPath = IndexPath(row: self.chatMessages.count-1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatMessages.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let chatMessage = self.chatMessages[indexPath.row]
        
        switch chatMessage.msgFromMe {
            
        case true:
            
            //Message is from me
            let cell = tableView
                .dequeueReusableCell(withIdentifier: "PrototypeCellMsgFromMe", for: indexPath) as! PrototypeCellMsgFromMe
            
            cell.msg.text = chatMessage.msg
            return cell
            
        default:
            
            //Message is not from me
            let cell = tableView
                .dequeueReusableCell(withIdentifier: "PrototypeCellMsgToMe", for: indexPath) as! PrototypeCellMsgToMe
            
            cell.msg.text = chatMessage.msg
            return cell
            
        }
        
    }

}
