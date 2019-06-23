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

class ChatView: UIViewController, SFSpeechRecognizerDelegate, ChatTableViewDelegate {
    
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
    private let audioEngine             = AVAudioEngine()
    private let speechRecognizer        = SFSpeechRecognizer()
    private let audioRequest            = SFSpeechAudioBufferRecognitionRequest()
    private var recognitionTask         : SFSpeechRecognitionTask?
    private var silenceTimer            : Timer?
    
    /*
     Flags
     */
    private var flagProcessInput                        : Bool = false
    private var flagHasMicAccess                        : Bool = false
    private var flagAutoStartSpeechRecognizer           : Bool = false
    private var flagWaitingForAutoStartSpeechRecognizer : Bool = false
    private var flagChatHasStarted                      : Bool = false
    
    override func viewDidLoad() {
        
        initAutoKeyboardDismiss()
        
        self.chat.delegate              = self.chatTableView
        self.chat.dataSource            = self.chatTableView
        
        self.chatTableView.tableView    = self.chat
        self.chatTableView.delegate     = self
        
        /*
         Question: Speech output enabled?
        */
        let alert = UIAlertController(title: "Frage", message: "Möchten Sie die Sprachausgabe aktivieren? Bitte schalten Sie dazu auch Ihr Geräut auf 'Laut'.", preferredStyle: .alert)
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        SFSpeechRecognizer.requestAuthorization { [unowned self] authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    self.flagHasMicAccess = true
                } else {
                    self.flagHasMicAccess = false
                }
            }
        }
        
    }
    
    @IBAction func buttonSendTextAction(_ sender: Any) {
        
        dismissKeyboard()
        
        if(!self.flagProcessInput) { return }
        
        processInput()
        
    }
    
    @IBAction func buttonUseLangAction(_ sender: Any) {
        
        dismissKeyboard()
        
        if(self.recognitionTask == nil) {
            
            //No active recognition
            self.flagAutoStartSpeechRecognizer = true
            
        }
        else {
            
            //Active recognition
            self.flagAutoStartSpeechRecognizer = false
            
        }
        
        toggleSpeechRecognition()
    }
    
    private func toggleSpeechRecognition() {
        
        if(!self.flagHasMicAccess) {
            
            AlertHelper.showError(msg: "Bitte geben Sie die nötigen Zugriffsrechte auf Ihr Mikrofon.", viewController: self)
            return
        }
        
        if(self.recognitionTask == nil) {
            
            //No active recognition
            if(!self.flagProcessInput) { return }
            startSpeechRecognition()
            
        }
        else {
            
            //Active recognition
            stopSpeechRecognition()
            processInput()
            
        }
        
    }
    
    private func startSpeechRecognition() {
        
        self.useLang.setTitle("[Spracheingabe läuft... Jetzt abschließen]", for: .normal)
        self.myMessage.text = ""
        
        self.silenceTimer       = nil
        self.flagProcessInput   = false
        
        //Setup inputNode with buffer
        let inNode = audioEngine.inputNode
        
        let format = inNode.outputFormat(forBus: 0)
        
        inNode.installTap(onBus: 0, bufferSize: 1024, format: format, block: { buffer, _ in
            self.audioRequest.append(buffer)
        })
        
        //Try to start audio engine
        self.audioEngine.prepare()
        do {
            try self.audioEngine.start()
        }
        catch {
            AlertHelper.showError(msg: error.localizedDescription, viewController: self)
            stopSpeechRecognition()
            return
        }
        
        //Security checks
        guard let myRecognizer = self.speechRecognizer else {
            stopSpeechRecognition()
            AlertHelper.showError(msg: "Spracherkennung wird in Ihrer Region nicht unterstützt.", viewController: self)
            return
        }
        if(!myRecognizer.isAvailable) {
            stopSpeechRecognition()
            AlertHelper.showError(msg: "Spracherkennung ist derzeit leider nicht verfügbar.", viewController: self)
            return
        }
        
        //Create Task with handler
        self.recognitionTask = self.speechRecognizer?.recognitionTask(with: self.audioRequest, resultHandler: { result, error in
            
            //TODO: Improve global error handling (this way)
            if let result = result {
                
                if(result.isFinal) {
                    
                    //End recognition
                    self.myMessage.text = ""
                    
                    //Silence timer (auto abort after time of silence)
                    self.silenceTimer?.invalidate()
                    self.silenceTimer = nil
                    
                } else {
                    
                    //In recognition
                    self.myMessage.text = result.bestTranscription.formattedString
                    
                    //Silence timer (auto abort after time of silence)
                    if let timer = self.silenceTimer, timer.isValid {
                            timer.invalidate()
                    } else {
                        self.silenceTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(Configurator.shared.getSilenceDelay()), repeats: false, block: { (timer) in
                            self.toggleSpeechRecognition()
                        })
                    }
                    
                }
                
            } else if let error = error {
                self.stopSpeechRecognition()
                AlertHelper.showError(msg: "Fehler in der Spracherkennung:\n\n'\(error.localizedDescription)'", viewController: self)
            }
            
        })
        
    }
    
    private func stopSpeechRecognition() {
        
        self.useLang.setTitle("Sprache benutzen", for: .normal)
        self.flagProcessInput = true
        
        //Finish recognition
        self.recognitionTask?.finish()
        self.recognitionTask = nil
        
        //Stop audioEngine and finish request
        self.audioEngine.inputNode.removeTap(onBus: 0)
        self.audioEngine.stop()
        self.audioRequest.endAudio()
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                
                self.chatTableView.addMessageToMe(msg: self.chatService.getNextQuestion() ?? "Fehler im Chat-Service")

                //Auto Start SpeechRecognizer in dialog after text to speech
                if(self.flagAutoStartSpeechRecognizer) { self.flagWaitingForAutoStartSpeechRecognizer = true }
            })
            
        }
        else {
            
            //Dto is ready at the moment
            self.navigationController?.popViewController(animated: true)
            self.delegate?.chatViewSuccess(dto: dto!)
            
        }
        
    }
    
    private func startChat() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0), execute: {
            self.chatTableView.addMessageToMe(msg: "Hallo, ich bin Lisa! Ich kümmere mich um Ihre Bücher!")
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            self.chatTableView.addMessageToMe(msg: "Falls ich etwas nicht korrekt verstehe: Am Ende können Sie natürlich noch Ihr Buch überarbeiten.")
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10), execute: {
            self.flagChatHasStarted = true
            self.chatTableView.addMessageToMe(msg: self.chatService.getNextQuestion() ?? "Fehler im Chat-Service")
        })
    }
    
    func didStartSpeaking() {
        
        self.flagProcessInput = false
        
    }
    
    func didFinishResponse() {
        
        if(self.flagChatHasStarted) { self.flagProcessInput = true }
        
        if(self.flagWaitingForAutoStartSpeechRecognizer) {
            self.flagWaitingForAutoStartSpeechRecognizer = false
            toggleSpeechRecognition()
        }
        
    }
    
}

class PrototypeCellMsgToMe: UITableViewCell {
    @IBOutlet weak var msg: UITextView!
}

class PrototypeCellMsgFromMe: UITableViewCell {
    @IBOutlet weak var msg: UITextView!
}

protocol ChatTableViewDelegate {
    func didStartSpeaking()
    func didFinishResponse()
}

class ChatTableView: UITableViewController, AVSpeechSynthesizerDelegate {

    var delegate: ChatTableViewDelegate?
    
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
                AlertHelper.showError(msg: "Sprachausgabe ist derzeit leider nicht verfügbar.", viewController: self)
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
            speechUtterance.voice = AVSpeechSynthesisVoice(language: Configurator.shared.getSynthesisVoiceLanguage())
            self.speechSynth.speak(speechUtterance)
        }
        else { self.delegate?.didFinishResponse() }
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
        self.delegate?.didFinishResponse()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        self.delegate?.didStartSpeaking()
    }

}
