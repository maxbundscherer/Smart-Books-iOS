//
//  ChatTableView.swift
//  Smart Books
//
//  Created by Maximilian Bundscherer on 17.06.19.
//  Copyright © 2019 Maximilian Bundscherer. All rights reserved.
//

import UIKit
import Speech

protocol ChatViewControllerDelegate {
    
    func chatViewControllerSuccess(dto: BookEntityDto)
    
}

class ChatViewController: UIViewController, SFSpeechRecognizerDelegate, ChatTableViewDelegate {
    
    var delegate: ChatViewControllerDelegate?
    
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
            
            showErrorAlert(msg: "Bitte geben Sie die nötigen Zugriffsrechte auf Ihr Mikrofon.")
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
            showErrorAlert(msg: error.localizedDescription)
            stopSpeechRecognition()
            return
        }
        
        //Security checks
        guard let myRecognizer = self.speechRecognizer else {
            stopSpeechRecognition()
            showErrorAlert(msg: "Spracherkennung wird in Ihrer Region nicht unterstützt.")
            return
        }
        if(!myRecognizer.isAvailable) {
            stopSpeechRecognition()
            showErrorAlert(msg: "Spracherkennung ist derzeit leider nicht verfügbar.")
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
                        self.silenceTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(ConfiguratorService.shared.getSilenceDelay()), repeats: false, block: { (timer) in
                            self.toggleSpeechRecognition()
                        })
                    }
                    
                }
                
            } else if let error = error {
                self.stopSpeechRecognition()
                self.showErrorAlert(msg: "Fehler in der Spracherkennung:\n\n'\(error.localizedDescription)'")
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
            self.delegate?.chatViewControllerSuccess(dto: dto!)
            
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
