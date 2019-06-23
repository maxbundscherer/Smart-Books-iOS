//
//  ChatTableView.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 23.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import UIKit
import Speech

protocol ChatTableViewControllerDelegate {
    
    func chatTableViewControllerDidStartSpeaking()
    func chatTableViewControllerDidFinishResponse()
    
}

class PrototypeCellMsgToMe: UITableViewCell {
    @IBOutlet weak var msg: UITextView!
}

class PrototypeCellMsgFromMe: UITableViewCell {
    @IBOutlet weak var msg: UITextView!
}

class ChatTableViewController: UITableViewController, AVSpeechSynthesizerDelegate {
    
    var delegate: ChatTableViewControllerDelegate?
    
    private var chatMessages: [ChatMessage] = []
    
    private var flagTextToSpeech: Bool  = false
    private let speechSynth             = AVSpeechSynthesizer()
    
    private struct ChatMessage {
        let timestamp: Double
        let msgFromMe: Bool
        let msg: String
    }
    
    func initChat(textToSpeechEnabled: Bool) {
        
        self.flagTextToSpeech       = textToSpeechEnabled
        self.speechSynth.delegate   = self
        
        if(self.flagTextToSpeech) {
            
            //Fix synth bug (mix volume)
            do
            {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
                try AVAudioSession.sharedInstance().setMode(AVAudioSession.Mode.default)
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            }
            catch
            {
                showErrorAlert(msg: "Sprachausgabe ist derzeit leider nicht verfügbar.")
                self.flagTextToSpeech = false
            }
        }
        
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
        
        if(self.flagTextToSpeech) {
            
            let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: msg)
            speechUtterance.voice = AVSpeechSynthesisVoice(language: ConfiguratorService.shared.getSynthesisVoiceLanguage())
            self.speechSynth.speak(speechUtterance)
        }
        else { self.delegate?.chatTableViewControllerDidFinishResponse() }
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
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.delegate?.chatTableViewControllerDidFinishResponse()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        self.delegate?.chatTableViewControllerDidStartSpeaking()
    }
    
}
