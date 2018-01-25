//
//  SpeechRecognitionService.swift
//  FoodIn
//
//  Created by Yuanxin Li on 22/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import Foundation
import Speech

/// The class used to control speech recognition sessions.
class SpeechRecognitionService {
    private static let inputNodeBus: AVAudioNodeBus = 0
    
    // The speech recogniser used by the service to record the user's speech.
    private let speechRecogniser = SFSpeechRecognizer(locale: Locale(identifier: "en-SG"))!
    
    // The current speech recognition request. Created when the user wants to begin speech recognition.
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    // The current speech recognition task. Created when the user wants to begin speech recognition.
    private var recognitionTask: SFSpeechRecognitionTask?
    
    // The audio engine used to record input from the microphone.
    private let audioEngine = AVAudioEngine()
    
    // The delegate of the receiver.
    var delegate: SpeechServiceDelegate?
    
    // Begins a new speech recording session.
    // - Throws: Errors thrown by the creation of the speech recognition session
    func startRecording() throws {
        guard speechRecogniser.isAvailable else {
            // Speech recognition is unavailable, so do not attempt to start.
            return
        }
        if let recognitionTask = recognitionTask {
            // We have a recognition task still running, so cancel it before starting a new one.
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            throw SpeechServiceError.noAudioInput
        }
        
        recognitionTask = speechRecogniser.recognitionTask(with: recognitionRequest) { [unowned self] result, error in
            
            if let result = result {
                self.delegate?.speechService(self, onRecogniseText: result.bestTranscription.formattedString)
            }
            
            if result?.isFinal ?? (error != nil) {
                if let result = result {
                    self.delegate?.speechService(self, didRecogniseText: result.bestTranscription.formattedString)
                }
                inputNode.removeTap(onBus: SpeechRecognitionService.inputNodeBus)
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: SpeechRecognitionService.inputNodeBus)
        inputNode.installTap(onBus: SpeechRecognitionService.inputNodeBus, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    // Ends the current speech recording session.
    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try audioSession.setMode(AVAudioSessionModeDefault)
            try audioSession.setActive(false, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
    }
    
    func checkAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    break
                case .denied:
                    break
                case .restricted:
                    break
                case .notDetermined:
                    break
                }
            }
        }
    }
    
}

// The protocol to conform to for delegates of `speechService`.
protocol SpeechServiceDelegate {
    
    // The message sent when the user's speech has been transcribed. Will be called with partial results of the current recording session.
    //
    // - Parameters:
    //   - speechService: The service sending the message.
    //   - text: The text transcribed from the user's speech.
    func speechService(_ speechService: SpeechRecognitionService, didRecogniseText text: String)
    func speechService(_ speechService: SpeechRecognitionService, onRecogniseText text: String)
}

// The error types vended by `speechService` if it cannot create an audio recording session.
//
// - noAudioInput: No audio input connection could be created.
enum SpeechServiceError: Error {
    case noAudioInput
}




