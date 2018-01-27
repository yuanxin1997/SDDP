//
//  SpeechViewController.swift
//  FoodIn
//
//  Created by Yuanxin Li on 21/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation
import ApiAI

class SpeechViewController: UIViewController, AVAudioPlayerDelegate, SpeechServiceDelegate, UITableViewDataSource, UITableViewDelegate, AVSpeechSynthesizerDelegate {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var microphone: UIImageView!
    @IBOutlet weak var hintLabel: UILabel!
    
    var timer = Timer()
    var callBackSpeech = false
    var player: AVAudioPlayer?
    var isHolding = false
    var messageArray: [String] = ["What food do you want me to inspect ?"]
    var speechQueueArray: [String] = []
    let speechSynthesizer = AVSpeechSynthesizer()
    var fService = FoodService()
    
    let nlpService = NLPService()
    
    private lazy var speechService: SpeechRecognitionService = {
        let speechService = SpeechRecognitionService()
        speechService.delegate = self
        return speechService
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speechService.checkAuthorization()
        initTable()
        speechSynthesizer.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupCustomNavStatusBar(setting: [.hideStatusBar])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageCell
        
        
        cell.lblMessage.text = messageArray[indexPath.section]
        cell.lblMessage.font = Fonts.Regular.of(size: 28)
        cell.lblMessage.textColor = Colors.darkgrey
        cell.lblMessage.sizeToFit()
        cell.lblMessage.numberOfLines = 0
        return cell
    }
    
    func initTable() {
        table.tableFooterView = UIView()
    }
    
    @IBAction func handleLongPress(recognizer:UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began, .changed:
            if !isHolding {
                
                // Holding...
                isHolding = true
                
                // Play sound and vibration
                playSound(name: "hold")
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                
                // Start animation
                startTimer()
                
                // Fade out hint label
                UIView.animate(withDuration: 0.5, animations: {
                    self.hintLabel.alpha = 0
                })
                
                // Start listening
                messageArray = ["I'm listening..."]
                let cell = getTopLabelCell()
                cell.lblMessage.textAlignment = .left
                table.reloadData()
                
            }
        case .ended:
            if isHolding {
                
                // Realeasing...
                isHolding = false
                print("release")
                
                // Stop speech
                self.speechService.stopRecording()
                
                // Play sound and vibration
                playSound(name: "release")
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                
                // Start animation
                stopTimer()
                
                // fade in hint Label
                UIView.animate(withDuration: 1.5, animations: {
                    self.hintLabel.alpha = 1
                })
                
                // Stop listening
                if messageArray[0] == "I'm listening..." {
                    messageArray[0] = "What food do you want me to inspect ?"
                    table.reloadData()
                }
                
            }
        default:
            break
        }
    }
    
    @IBAction func dismissBtnDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func startTimer() {
        self.addPulse()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            self.addPulse()
        }
    }
    
    // Add effect to microphone
    func addPulse(){
        let pulse = Pulsing(numberOfPulses: 1, radius: 80, position: microphone.center)
        pulse.animationDuration = 1.5
        pulse.backgroundColor = Colors.pink.cgColor
        self.view.layer.insertSublayer(pulse, below: microphone.layer)
    }
    
    func playSound(name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true, with: .notifyOthersOnDeactivation)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            player?.delegate = self
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
            if isHolding {
                do {
                    try self.speechService.startRecording()
                    print("start")
                } catch {
                    print("Could not begin recording")
                }
            } else {
                print("stop")
            }

    }
    
    func speechService(_ speechService: SpeechRecognitionService, onRecogniseText text: String) {
        DispatchQueue.main.async {
            print(text)
            self.messageArray[0] = text
            let cell = self.getTopLabelCell()
            cell.lblMessage.textAlignment = .right
            self.table.reloadData()
        }
    }
    
    func speechService(_ speechService: SpeechRecognitionService, didRecogniseText text: String) {
        nlpService.sendMessage(text: text, completion: { (response: AIResponse?) in
            DispatchQueue.main.async {
                if let response = response {
                    if let textResponse = response.result.fulfillment.speech {
                        self.messageArray.append(textResponse)
                        self.speechQueueArray.append(textResponse)
                    }
                    
                    if response.result.action == "Inspect" {
                        if let parameters = (response.result.parameters as? [String: AIResponseParameter]) {
                            if let value = parameters["food"]?.stringValue {
                                self.inspectFood(name: value)
                                self.callBackSpeech = true
                            }
                        }
                    }
                    
                    self.executeSpeechFromQueue()
                }
            }
        })
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if callBackSpeech == true {
            callBackSpeech = false
            self.executeSpeechFromQueue()
        }
    }
    
    func speechAndText(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        speechUtterance.pitchMultiplier = 0.85
        speechUtterance.rate = 0.45
        speechSynthesizer.speak(speechUtterance)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
        }, completion: nil)
    }
    
    func getTopLabelCell() -> MessageCell {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.table.cellForRow(at: indexPath) as! MessageCell
        return cell
    }
    
    func getBottomLabelCell() -> MessageCell {
        let indexPath = IndexPath(row: 0, section: messageArray.count-1)
        let cell = self.table.cellForRow(at: indexPath) as! MessageCell
        return cell
    }
    
    func inspectFood(name: String){
        fService.getFoodDetails(foodName: name, completion: { (result: Food?) in
            DispatchQueue.main.async {
                if let result = result {
                    print("retrieved food \(result)")
                    FoodDetailsController.selectedFood = result
                    if result.sodium < 1500 {
                        self.messageArray.append("You are safe to eat \(name), as the sodium level will not hit your limit")
                        self.speechQueueArray.append("You are safe to eat \(name), as the sodium level will not hit your limit")
                    } else {
                        self.messageArray.append("You should avoid eating \(name), as the sodium level will hit your limit")
                        self.speechQueueArray.append("You should avoid eating \(name), as the sodium level will hit your limit")
                    }
                } else {
                    print("Empty or error")
                }
            }
        })
    }
    
    func executeSpeechFromQueue() {
        print(speechQueueArray.count)
        if speechQueueArray.count > 0 {
            self.speechAndText(text: speechQueueArray.removeFirst())
            print(speechQueueArray.count)
            
            self.table.reloadData()
            let cell = self.getBottomLabelCell()
            cell.alpha = 0
            UIView.animate(withDuration: 1) {
                let cell = self.getBottomLabelCell()
                cell.alpha = 1
                cell.lblMessage.textColor = Colors.lightgrey
            }
        }
    }
    
}

