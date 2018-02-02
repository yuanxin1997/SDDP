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
import KeychainSwift

class SpeechViewController: UIViewController, AVAudioPlayerDelegate, SpeechServiceDelegate, UITableViewDataSource, UITableViewDelegate, AVSpeechSynthesizerDelegate {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var microphone: UIImageView!
    @IBOutlet weak var hintLabel: UILabel!
    
    var timer = Timer()
    var callBackSpeech = false
    var player: AVAudioPlayer?
    var isHolding = false
    var queueSessionID: Int?
    var messageQueue: [String] = ["What food do you want me to inspect ?"]
    var textToSpeechQueue: [String] = []
    var arrayOfNutritionalOverLimit:[String] = []
    let speechSynthesizer = AVSpeechSynthesizer()
    let fService = FoodService()
    let pService = PersonService()
    let nlpService = NLPService()
    
    private lazy var speechService: SpeechRecognitionService = {
        let speechService = SpeechRecognitionService()
        speechService.delegate = self
        return speechService
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // refresh the UI of speech view controller
        updateVoiceUITheme()
        
        // Check for authorization
        speechService.checkAuthorization()
        
        // Customize table
        initTable()
        
        // Set delegate
        speechSynthesizer.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Customize Navigation and Status bar
        setupCustomNavStatusBar(setting: [.hideStatusBar])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Customize Navigation and Status bar
        setupCustomNavStatusBar(setting: [.showStatusBar])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return messageQueue.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // init
        let headerView = UIView()
        
        // clear the background of section header view
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageCell
        
        // Configure cell
        cell.lblMessage.text = messageQueue[indexPath.section]
        cell.lblMessage.font = Fonts.Regular.of(size: 28)
        cell.lblMessage.textColor = Colors.darkgrey
        
        // Switch UI theme based on user default
        cell.backgroundColor = UserDefaults.standard.string(forKey: "VoiceUITheme") == "Light" ? Colors.white : Colors.darkgrey
        
        // Auto resize the cell based on text size
        cell.lblMessage.sizeToFit()
        cell.lblMessage.numberOfLines = 0
        
        // Check if the this is the last row
        if indexPath.section == (messageQueue.count - 1){
            
            // Switch cell color based on user default
            cell.lblMessage.textColor = UserDefaults.standard.string(forKey: "VoiceUITheme") == "Light" ? Colors.darkgrey : Colors.white
            
            // Hide the cell
            cell.alpha = 0
            
            // Check if this is the only first and last row
            if messageQueue.count > 1{
                
                // Show the cell with fading effect
                UIView.animate(withDuration: 1) {
                    cell.alpha = 1
                }
            }
        } else {
            // Switch cell color based on user default
            cell.lblMessage.textColor = UserDefaults.standard.string(forKey: "VoiceUITheme") == "Light" ? Colors.lightgrey : Colors.lightgrey
        }
        
        return cell
    }
    
    func initTable() {
        
        // Remove extra empty cell
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
                
                // Get a queue session ID to start new speech session
                queueSessionID = Int(Date().timeIntervalSince1970)
                
                // Start listening
                messageQueue = ["I'm listening..."]
                arrayOfNutritionalOverLimit = []
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
                if messageQueue[0] == "I'm listening..." {
                    messageQueue[0] = "What food do you want me to inspect ?"
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
        
        // Stop the timer
        timer.invalidate()
    }
    
    func startTimer() {
        
        // Start pulsing animaiton
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
            
            // Update the first cell when there is changes
            self.messageQueue[0] = text
            
            // Customise the first cell
            let cell = self.getTopLabelCell()
            
            // Config the cell's text alignment to right
            cell.lblMessage.textAlignment = .right
            
            // Refresh the UI after configuration
            self.table.reloadData()
        }
    }
    
    func speechService(_ speechService: SpeechRecognitionService, didRecogniseText text: String) {
        
        // Send the text to dialogflow to understand the text
        nlpService.sendMessage(text: text, sessionID: queueSessionID!, completion: { (response: AIResponse?, sessionID: Int) in
            DispatchQueue.main.async {
                if let response = response {
                    
                    // Pass to handler to handle the logic
                    self.handleResponse(response: response, sessionID: sessionID)
                }
            }
        })
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        // Execute the queue again if there is a another task adding to the queue
        if callBackSpeech == true {
            callBackSpeech = false
            executeTextToSpeechQueue()
        }
    }
    
    func speak(text: String) {
        
        // Config the voice
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        speechUtterance.pitchMultiplier = 0.85
        speechUtterance.rate = 0.45
        speechSynthesizer.speak(speechUtterance)
    }
    
    func handleResponse(response: AIResponse, sessionID: Int) {
        
        // Get text response
        guard let textResponse = response.result.fulfillment.speech else { return }
        
        // Get parameters
        guard let parameters = (response.result.parameters as? [String: AIResponseParameter]) else { return }
        
        // Get intent
        guard let intent = response.result.action else { return }
        
        // Match intent to task
        matchIntent(intent: intent, parameters: parameters, textResponse: textResponse, sessionID: sessionID)
    }
    
    func matchIntent(intent: String, parameters: [String: AIResponseParameter], textResponse: String, sessionID: Int) {
        
        // Match intent to task
        if intent != "input.unknown" {
            switch intent {
            case "inspect.food":
                inspectFoodAction(intent: intent, parameters: parameters, textResponse: textResponse, sessionID: sessionID)
            case "log.food":
                logFoodAction(intent: intent, parameters: parameters, textResponse: textResponse, sessionID: sessionID)
            case "switch.theme":
                switchThemeAction(intent: intent, parameters: parameters, textResponse: textResponse, sessionID: sessionID)
            default:
                
                // If no task is match add default response to queue
                addToQueue(content: textResponse, sessionID: sessionID)
                
                // Run the queue
                executeTextToSpeechQueue()
            }
        } else {
            
            // If no task is match add default response to queue
            addToQueue(content: textResponse, sessionID: sessionID)
            
            // Run the queue
            executeTextToSpeechQueue()
        }
    }
    
    func inspectFoodAction(intent: String, parameters: [String: AIResponseParameter], textResponse: String, sessionID: Int) {
        
        // Get the value from parameters
        guard let value = parameters["food"]?.stringValue else { return }
        
        // Check if value is empty
        if value == "" {
            
            // Add response to queue
            addToQueue(content: "Sorry, I didn't get that.", sessionID: sessionID)
        } else {
            
            // Add response to queue
            addToQueue(content: textResponse, sessionID: sessionID)
            
            // Get the selected food details from web service
            fService.getFoodDetails(foodName: value, completion: { (result: Food?) in
                DispatchQueue.main.async {
                    if let result = result {
                        
                        /// Call internal methods to handle
                        self.inspectFood(food: result, value: value, sessionID: sessionID)
                    } else {
                        print("Empty or error")
                    }
                }
            })
        }
        
        // Run the queue
        executeTextToSpeechQueue()
    }
    
    func logFoodAction(intent: String, parameters: [String: AIResponseParameter], textResponse: String, sessionID: Int) {
        
        // Get the value from parameters
        guard let value = parameters["food"]?.stringValue else { return }
        
        // Check if value is empty
        if value == "" {
            addToQueue(content: "Sorry, I didn't get that.", sessionID: sessionID)
        } else {
            
            // Run the queue
            addToQueue(content: textResponse, sessionID: sessionID)
            
            // Get person ID from keychain
            guard let id = Int(KeychainSwift().get("id")!) else { return }
            
            // Get current date
            let now = UInt64(floor(Date().timeIntervalSince1970))
            
            // Send new log to web service
            pService.createFoodLogByFoodName(personId: id, foodName: value, timestamp: now,  completion: { (result: Int?) in
                DispatchQueue.main.async {
                    if let result = result {
                        
                        // Response according when successful or unsuccessful
                        var finalText = ""
                        if result == 1 {
                            finalText = "\(value) has been successfully logged"
                        } else {
                            finalText = "My apology, I've failed to log \(value)"
                        }
                        
                        // Add response to queue
                        self.addToQueue(content: finalText, sessionID: sessionID)
                        
                        // Identify a callback to be return
                        self.callBackSpeech = true
                    } else {
                        print("Empty or error")
                    }
                }
            })
        }
        
        // Run the queue
        executeTextToSpeechQueue()
    }
    
    func switchThemeAction(intent: String, parameters: [String: AIResponseParameter], textResponse: String, sessionID: Int) {
        
        // Get value from parameters
        guard let value = parameters["theme"]?.stringValue else { return }
        
        // Check if value is empty
        if value == "" {
            addToQueue(content: "Sorry, I didn't get that.", sessionID: sessionID)
        } else {
            
            // Update the user default
            UserDefaults.standard.set(value, forKey: "VoiceUITheme")
            
            // Add response to queue
            addToQueue(content: textResponse, sessionID: sessionID)
        }
        
        // Run the queue
        executeTextToSpeechQueue()
        
        // Refresh the UI of speech view controller
        updateVoiceUITheme()
    }
    
    func addToQueue(content: String, sessionID: Int) {
        
        // Check if is belong to the latest/new session
        if sessionID == queueSessionID! {
            // Add to message queue
            messageQueue.append(content)
            
            // Add to text to speech queue
            textToSpeechQueue.append(content)
        }
    }
    
    func executeTextToSpeechQueue() {
        
        // Check that the queue is not empty
        if textToSpeechQueue.count > 0 {
            
            // Remove task from queue after executing
            speak(text: textToSpeechQueue.removeFirst())
            
            // Update the UI
            table.reloadData()
        }
    }
    
    func updateVoiceUITheme() {
        
        // Switch the background color based on user default
        self.view.backgroundColor = UserDefaults.standard.string(forKey: "VoiceUITheme") == "Light" ? Colors.white : Colors.darkgrey
        table.backgroundColor = UserDefaults.standard.string(forKey: "VoiceUITheme") == "Light" ? Colors.white : Colors.darkgrey
    }
    
    func getTopLabelCell() -> MessageCell {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = self.table.cellForRow(at: indexPath) as! MessageCell
        return cell
    }
    
    func inspectFood(food: Food, value: String, sessionID: Int) {
        
        // Get the person ID from keychain
        guard let id = Int(KeychainSwift().get("id")!) else { return }
        
        // Get start date
        let to = UInt64(floor(Date().timeIntervalSince1970))
        
        // Get end date
        let from = UInt64(floor(Date().startOfDay.timeIntervalSince1970))
        
        // Get food log from web service
        pService.getFoodLog(personId: id, from: from, to: to, completion: { (result: [FoodLog]?) in
            DispatchQueue.main.async {
                if let result = result {
                    
                    // Get person illness indicator
                    let myIndicator = MyIndicatorService().getMyIndicator()
                    
                    // Using mirror to get the properties of array
                    let foodMirror = Mirror(reflecting: food)
                    for (name, value) in foodMirror.children {
                        for i in myIndicator {
                            if name == i.name {
                                let valueToMatch = value as! Double
                                
                                // Calculate the total value from today's food log
                                if self.getTotalValueFromLog(foods: result, indicatorName: i.name!, currentNutritionValue: valueToMatch) > i.maxValue {
                                    
                                    // Push nutritional that has hit the person limit to array
                                    self.arrayOfNutritionalOverLimit.append(name!)
                                }
                            }
                        }
                    }
                    var finalText = ""
                    if self.arrayOfNutritionalOverLimit.count > 0 {
                        let text = self.arrayOfNutritionalOverLimit.reduce("", { $0 == "" ? $1 : $0 + ", " + $1 })
                        finalText = "You should avoid eating \(value), as the \(text) level has hit your limit"
                    } else {
                        finalText = "You are safe to eat \(value), as all the nutrition level is below your limit"
                    }
                    
                    // Add response to queue
                    self.addToQueue(content: finalText, sessionID: sessionID)
                    
                    // Identifiy that there's a call back speech
                    self.callBackSpeech = true
                }
            }
        })
    }
    
    func getTotalValueFromLog(foods: [FoodLog], indicatorName: String, currentNutritionValue: Double) -> Double {
        var totalValue = currentNutritionValue
        for food in foods {
            let foodMirror = Mirror(reflecting: food)
            for (name, value) in foodMirror.children {
                if name == indicatorName {
                    let valueToSum = value as! Double
                    print(valueToSum)
                    totalValue += valueToSum
                    print(totalValue)
                }
            }
        }
        return totalValue
    }

}

