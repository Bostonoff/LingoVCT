//
//  SpeechRecognizer.swift
//  LingoVCT
//
//  Created by Mukhammad Bustonov on 15/12/24.
//
import Foundation
import Speech

class SpeechRecognizer: ObservableObject {
    private var audioEngine = AVAudioEngine()
    private var request = SFSpeechAudioBufferRecognitionRequest()
    private var recognitionTask: SFSpeechRecognitionTask?
//    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognizer: SFSpeechRecognizer?
    
    @Published var recognizedText = ""
    @Published var isRecording: Bool = false
    @Published var selectedLanguage: String = "en-US"

    func updateRecognizer() {
            recognizer = SFSpeechRecognizer(locale: Locale(identifier: selectedLanguage))
        }

    func startRecording() {
        stopRecording()
        request = SFSpeechAudioBufferRecognitionRequest()
        updateRecognizer()
        guard let recognizer = recognizer, recognizer.isAvailable else {
            recognizedText = "Speech recognition is not available."
            return
        }
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
                self.request.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            
            recognitionTask = recognizer.recognitionTask(with: request) { result, error in
                if let result = result {
                    DispatchQueue.main.async {
                        let text = result.bestTranscription.formattedString
                        if !text.isEmpty {
                            self.recognizedText = text
                        }
                    }
                }
                
                if error != nil {
                    self.stopRecording()
                }
            }
            
            isRecording = true
        } catch {
            recognizedText = "Error starting recording: \(error.localizedDescription)"
            stopRecording()
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionTask?.cancel()
        recognitionTask = nil 
        isRecording = false
    }
//    restart
    func resetText() {
          recognizedText = ""
      }
}
