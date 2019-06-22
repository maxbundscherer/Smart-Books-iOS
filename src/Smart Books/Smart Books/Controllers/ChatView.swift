//
//  ChatTableView.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 17.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import UIKit
import Speech

protocol ChatViewDelegate {
    
    func chatViewSuccess(dto: BookEntityDto)
    
}

class ChatView: UIViewController, SFSpeechRecognizerDelegate {
    
    var delegate: ChatViewDelegate?
    
    /*
     UI
     */
    @IBOutlet weak var chat: UITableView!
    @IBOutlet weak var myMessage: UITextField!
    @IBOutlet weak var useLang: UIButton!
    
    /*
    Chat Service and chat view
    */
    private let chatService     = ChatService()
    private var chatTableView   = ChatTableView()
    
    /*
     Speech
     */
    //TODO: Fix permissions bug
    private let audioEngine         = AVAudioEngine()
    private let speechRecognizer    = SFSpeechRecognizer()
    private let audioRequest        = SFSpeechAudioBufferRecognitionRequest()
    private var recognitionTask     : SFSpeechRecognitionTask?
    
    /*
     Flags
     */
    private var flagProcessInput: Bool = false
    
    override func viewDidLoad() {
        
        initAutoKeyboardDismiss()
        
        self.chat.delegate              = self.chatTableView
        self.chat.dataSource            = self.chatTableView
        self.chatTableView.tableView    = self.chat
        
        /*
         Question: Speech output enabled?
        */
        let alert = UIAlertController(title: "Frage", message: "Möchten Sie die Sprachausgabe aktivieren?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ja", style: .default, handler: { (_) in
            
            self.chatTableView.initChat(textToSpeechEnabled: true)
            self.startChat()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Nein", style: .cancel, handler: { (_) in
            
            self.chatTableView.initChat(textToSpeechEnabled: false)
            self.startChat()
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        super.viewDidLoad()
    }
    
    @IBAction func buttonSendTextAction(_ sender: Any) {
        
        if(!self.flagProcessInput) { return }
        
        dismissKeyboard()
        
        processInput()
        
    }
    
    @IBAction func buttonUseLangAction(_ sender: Any) {
        
        dismissKeyboard()
        
        if(self.recognitionTask == nil) {
            
            //No active recognition
            if(!self.flagProcessInput) { return }
            self.useLang.setTitle("[Spracheingabe beenden]", for: .normal)
            self.myMessage.text = ""
            startSpeechRecognition()
            
        }
        else {
            
            //Active recognition
            self.useLang.setTitle("Sprache benutzen", for: .normal)
            stopSpeechRecognition()
            processInput()
            
        }
        
    }
    
    private func startSpeechRecognition() {
        
        //Setup inputNode with buffer
        let inNode = audioEngine.inputNode
        
        let format = inNode.outputFormat(forBus: 0)
        
        inNode.installTap(onBus: 0, bufferSize: 1024, format: format, block: { buffer, _ in
            self.audioRequest.append(buffer)
        })
        
        //Try to start audio engine
        self.audioEngine.prepare()
        do {
            try audioEngine.start()
        }
        catch {
            AlertHelper.showError(msg: error.localizedDescription, viewController: self)
            return
        }
        
        //Security checks
        guard let myRecognizer = self.speechRecognizer else {
            AlertHelper.showError(msg: "Spracherkennung wird in Ihrer Region nicht unterstützt.", viewController: self)
            return
        }
        if(!myRecognizer.isAvailable) {
            AlertHelper.showError(msg: "Spracherkennung ist derzeit leider nicht verfügbar.", viewController: self)
            return
        }
        
        //Create Task with handler
        self.recognitionTask = self.speechRecognizer?.recognitionTask(with: self.audioRequest, resultHandler: { result, error in
            
            //TODO: Improve global error handling (this way)
            if let result = result {
                self.myMessage.text = result.bestTranscription.formattedString
                
            } else if let error = error {
                AlertHelper.showError(msg: "Fehler in der Spracherkennung:\n\n'\(error.localizedDescription)'", viewController: self)
            }
            
        })
        
    }
    
    private func stopSpeechRecognition() {
        
        //Finish recognition
        self.recognitionTask?.finish()
        self.recognitionTask = nil
        
        //Stop audioEngine
        self.audioEngine.inputNode.removeTap(onBus: 0)
        self.audioEngine.stop()
    }
    
    private func processInput() {
        
        //Get msg
        let input = (myMessage.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if(input == "") {
            self.chatTableView.addMessageToMe(msg: "Bitte reden Sie mit mir!")
            return
        }
        
        //Show msg in chat and clear chatInput
        self.chatTableView.addMessageFromMe(msg: input)
        self.myMessage.text = ""
        
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
            self.chatTableView.addMessageToMe(msg: "Hallo, ich bin Buchverwalter 3000!")
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
    
    private var flagTextToSpeech: Bool  = false
    private var speechSynth             = AVSpeechSynthesizer()
    
    private struct ChatMessage {
        let timestamp: Double
        let msgFromMe: Bool
        let msg: String
    }
    
    func initChat(textToSpeechEnabled: Bool) {
        
        self.flagTextToSpeech = textToSpeechEnabled
        
        reloadData()
    }
    
    func addMessageFromMe(msg: String) {
        
        if(msg == "") { return }
        
        self.chatMessages.insert(ChatMessage(timestamp: NSDate().timeIntervalSince1970, msgFromMe: true, msg: msg), at: self.chatMessages.count)
        reloadData()
    }
    
    func addMessageToMe(msg: String) {
        
        if(msg == "") { return }
        
        if(self.flagTextToSpeech) {
            
            let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: msg)
            speechUtterance.voice = AVSpeechSynthesisVoice(language: "de-DE")
            self.speechSynth.speak(speechUtterance)
        }
        
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
