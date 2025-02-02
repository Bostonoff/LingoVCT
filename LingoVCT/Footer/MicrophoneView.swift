//
//  Microphone.swift
//  LingoVCT
//
//  Created by Mukhammad Bustonov on 10/12/24.
//

import SwiftUI
import Speech
import AVFoundation

struct MicrophoneView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()
    //    //
    //    @State private var recognizedText: String = ""
    //    //
    @State private var isRecording = false
    @State private var showText = false
    
    @State private var showCamera = false
    
    @State private var lineWidth: CGFloat = 0
    @State private var audioLevel: CGFloat = 0.0
    @State private var dividerHeight: CGFloat = 3
    @State private var dividerColor: Color = .white
    
    //    private let audioRecorder = AudioRecorder()

    @State private var selectedImage: UIImage? = nil
    
    @State private var translatedText = ""
    @State private var isLoading = false
    @State private var targetLanguage = "it-IT"
    let languages = [
        "en-US": "English",
        "it-IT": "Italian",
        "uz-UZ": "Uzbek",
        "tr-TR": "Turkish",
        "ru-RU": "Russian"
    ]
    
    var body: some View {
        ZStack{
            // Animation
            Rectangle()
                .fill(Color.black)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Microphone section")
                    .font(.title)
                    .foregroundColor(.white)
                
                //                                .padding()
                //                                .background(Color.gray.opacity(0.3))
                //                                .cornerRadius(12)
                Button(action: {
                    speechRecognizer.resetText()
                    translatedText = ""
                }) {
                    HStack{
                        Image(systemName: "gobackward.minus")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 75, height: 75)
                            .background(Color.black)
                            .cornerRadius(60)
//                            .offset(y:15)
                            .shadow(color: .red, radius: 5,x: 0,y: 0 )
                    }
                }
                Spacer()
                
                VStack{
                    Picker("Language", selection: $speechRecognizer.selectedLanguage) {
                        ForEach(languages.keys.sorted(), id: \.self) { key in
                            Text(languages[key] ?? key)
                                .foregroundColor(.white)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: speechRecognizer.selectedLanguage) { _ in
                        speechRecognizer.updateRecognizer()
                    }
                    
                    ScrollView {
                        Text(speechRecognizer.recognizedText)
                            .font(.body)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .frame(height: 150)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(12)
                    
                }
                
                Divider()
                    .frame(height: dividerHeight)
                    .background(dividerColor)
                    .padding(.vertical)
                    .shadow(color: dividerColor == .red ? .red.opacity(1) : .clear, radius: 2, x: 0, y: 0)
                    
                
                VStack{
                    Picker("Target Language", selection: $targetLanguage) {
                        ForEach(languages.keys.sorted(), id: \.self) { key in
                            Text(languages[key] ?? key)
                                .foregroundColor(.white)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    ScrollView {
                        Text(translatedText)
                            .font(.body)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .frame(height: 150)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(12)
                    
                }
                
                Spacer()
                FooterView(
                    onCameraSelection: {
                        showCamera = true
                    },
                    onTextSelection: {
                        showText = true
                    },
                    onMicrophoneToggle: {
                        if speechRecognizer.isRecording {
                            speechRecognizer.stopRecording()
                            stopRecordingAnimation()
                            callOpenAIAPI()
                        } else {
                            speechRecognizer.startRecording()
                            startRecordingAnimation()
                        }
                    },
                    isRecording: $speechRecognizer.isRecording
                )
            }
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.7).edgesIgnoringSafeArea(.all))
            }
        }
        
        .background(Color.red.edgesIgnoringSafeArea(.all))
        .onAppear {
            SFSpeechRecognizer.requestAuthorization { status in
                if status != .authorized {
                    print("Speech recognition not authorized 404")
                }
            }
        }
        .sheet(isPresented: $showCamera) {
            CameraPicker(image: $selectedImage)
        }
        .navigationDestination(isPresented: $showText) {
            TextView()
        }
        .navigationBarBackButtonHidden()
        .interactiveDismissDisabled(true)
        .onChange(of: speechRecognizer.recognizedText) { _ in
            dividerColor = isRecording ? .red : .white
        }
    }
    
    private func startRecordingAnimation() {
        lineWidth = UIScreen.main.bounds.width
        dividerHeight = 2
        dividerColor = .red
        
    }
    
    private func stopRecordingAnimation() {
        lineWidth = 0
        dividerHeight = 2
        dividerColor = .white
    }
    
    func callOpenAIAPI() {
        isLoading = true
        let apiKey = "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"
        let endpoint = "https://api.openai.com/v1/chat/completions"
        let requestBody: [String: Any] = [
            "model": "gpt-4",
            "messages": [
                ["role": "system", "content": "You are a helpful assistant who translates text from \(languages[speechRecognizer.selectedLanguage] ?? "Unknown") to \(languages[targetLanguage] ?? "Unknown")."],
                ["role": "user", "content": speechRecognizer.recognizedText]
            ]
        ]
        
        guard let url = URL(string: endpoint),
              let httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: []) else {
            print("Invalid URL or request body")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    translatedText = "Error occurred!"
                    isLoading = false
                }
                return
            }
            
            guard let data = data,
                  let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let choices = responseJSON["choices"] as? [[String: Any]],
                  let message = choices.first?["message"] as? [String: Any],
                  let translatedText = message["content"] as? String else {
                DispatchQueue.main.async {
                    self.translatedText = "Failed to parse response!"
                    isLoading = false
                }
                return
            }
            
            DispatchQueue.main.async {
                self.translatedText = translatedText
                isLoading = false
            }
        }
        task.resume()
    }
    
}

// voice signature
//class AudioRecorder: NSObject, ObservableObject {
//    private var audioRecorder: AVAudioRecorder?
//    private var timer: Timer?
//
//    func requestPermission() {
//        AVAudioSession.sharedInstance().requestRecordPermission { granted in
//            if !granted {
//                print("Permission to record audio was denied.")
//            }
//        }
//    }
//
//    func startRecording(levelUpdate: @escaping (Float) -> Void) {
//        let audioSession = AVAudioSession.sharedInstance()
//        try? audioSession.setCategory(.playAndRecord, mode: .measurement, options: .defaultToSpeaker)
//        try? audioSession.setActive(true)
//
//        let url = URL(fileURLWithPath: "/dev/null")
//        let settings: [String: Any] = [
//            AVFormatIDKey: Int(kAudioFormatAppleIMA4),
//            AVSampleRateKey: 44100.0,
//            AVNumberOfChannelsKey: 1,
//            AVEncoderBitRateKey: 12800,
//            AVLinearPCMBitDepthKey: 16,
//            AVLinearPCMIsBigEndianKey: false,
//            AVLinearPCMIsFloatKey: false
//        ]
//
//        audioRecorder = try? AVAudioRecorder(url: url, settings: settings)
//        audioRecorder?.isMeteringEnabled = true
//        audioRecorder?.record()
//
//        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
//            self.audioRecorder?.updateMeters()
//            let level = self.audioRecorder?.averagePower(forChannel: 0) ?? -160
//            let normalizedLevel = self.normalizeSoundLevel(level)
//            levelUpdate(normalizedLevel)
//        }
//    }
//
//    func stopRecording() {
//        audioRecorder?.stop()
////        timer?.invalidate()
//    }
//
//    private func normalizeSoundLevel(_ level: Float) -> Float {
//        let minLevel: Float = -80
//        let maxLevel: Float = 0
//        return max(0.0, (level - minLevel) / (maxLevel - minLevel))
//    }
//}
#Preview {
    MicrophoneView()
}
