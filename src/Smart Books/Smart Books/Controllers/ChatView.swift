//
//  ChatTableView.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 17.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import UIKit

class ChatView: UIViewController {
    
    @IBOutlet weak var chat: UITableView!
    @IBOutlet weak var myMessage: UITextField!
    
    private var chatTableView = ChatTableView()
    
    override func viewDidLoad() {
        
        initAutoKeyboardDismiss()
        
        self.chat.delegate              = self.chatTableView
        self.chat.dataSource            = self.chatTableView
        self.chatTableView.tableView    = self.chat
        
        self.chatTableView.initChat()
        
        //TODO: Remove simulator
        simulateChat()
        
        super.viewDidLoad()
    }
    
    @IBAction func buttonSendTextAction(_ sender: Any) {
        
        dismissKeyboard()
        
        let msg = (myMessage.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        self.chatTableView.addMessageFromMe(msg: msg)
        
        self.myMessage.text = ""
    }
    
    @IBAction func buttonUseLangAction(_ sender: Any) {
        
        dismissKeyboard()
        
        //TODO: Implement
        let msg = "Diese Funktion ist noch nicht implementiert."
        self.chatTableView.addMessageToMe(msg: msg)
    }
    
    private func simulateChat() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.chatTableView.addMessageFromMe(msg: "Was machst du so?")
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            self.chatTableView.addMessageToMe(msg: "Nicht viel und du?")
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6), execute: {
            self.chatTableView.addMessageFromMe(msg: "Auch nicht!")
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(8), execute: {
            self.chatTableView.addMessageToMe(msg: "Und wie geht es dir dabei?")
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10), execute: {
            self.chatTableView.addMessageFromMe(msg: "Mir ist langweilig...")
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
        
        self.chatMessages = [
            ChatMessage(timestamp: 0, msgFromMe: false, msg: "Hallo, wie geht es dir?"),
            ChatMessage(timestamp: 1, msgFromMe: true, msg: "Gut und dir?"),
            ChatMessage(timestamp: 2, msgFromMe: false, msg: "Danke auch!")
            ].sorted(by: { $0.timestamp < $1.timestamp })
        
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
            let indexPath = IndexPath(row: self.chatMessages.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
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
