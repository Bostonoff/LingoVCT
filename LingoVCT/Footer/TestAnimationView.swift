////
////  TestAnimationView.swift
////  LingoVCT
////
////  Created by Mukhammad Bustonov on 15/12/24.
////
//
//import SwiftUI
//import AVFoundation
//
//struct TestAudioView: View {
//    @State private var audioLevel: CGFloat = 0.0
//    @State private var isRecording = false
//    private let audioRecorder = AudioRecorder()
//
//    var body: some View {
//        VStack(spacing: 40) {
//            Text("Audio Level Test")
//                .font(.title)
//                .padding()
//
//            // Линия для пульсации
//            Rectangle()
//                .fill(Color.blue)
//                .frame(width: 200, height: 10)
//                .scaleEffect(x: 1, y: audioLevel, anchor: .center)
//                .animation(.easeInOut(duration: 0.1), value: audioLevel)
//
//            // Кнопка записи
//            Button(action: {
//                toggleRecording()
//            }) {
//                Text(isRecording ? "Stop Recording" : "Start Recording")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(isRecording ? Color.red : Color.green)
//                    .cornerRadius(10)
//            }
//        }
//        .onAppear {
//            audioRecorder.requestPermission()
//        }
//        .padding()
//    }
//
//    private func toggleRecording() {
//        if isRecording {
//            audioRecorder.stopRecording()
//            isRecording = false
//            audioLevel = 0.0
//        } else {
//            audioRecorder.startRecording { level in
//                audioLevel = max(0.1, CGFloat(level) * 10) // Масштабируем уровень звука
//            }
//            isRecording = true
//        }
//    }
//}
//
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
//        timer?.invalidate()
//    }
//
//    private func normalizeSoundLevel(_ level: Float) -> Float {
//        let minLevel: Float = -80
//        let maxLevel: Float = 0
//        return max(0.0, (level - minLevel) / (maxLevel - minLevel))
//    }
//}
//
//#Preview {
//    TestAudioView()
//}
