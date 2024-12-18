
//
//  Camera.swift
//  LingoVCT
//
//  Created by Mukhammad Bustonov on 10/12/24.
//

import SwiftUI

struct FooterView: View {

    var onCameraSelection: () -> Void
    var onTextSelection: () -> Void
    var onMicrophoneToggle: () -> Void
    @Binding var isRecording: Bool
    
    var body: some View {
        
        HStack {
            // Text Button
            Button(action: {
                onTextSelection()
            }) {
                Image(systemName: "textformat.size")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Circle().fill(Color.gray.opacity(0.2)))
            }
            
            Spacer()
            // Microphone Button
            Button(action: {
                onMicrophoneToggle()
            }) {
                ZStack{
                    Image(systemName: isRecording ? "stop.fill" : "mic")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(20)
                        .background(Circle().fill(Color.red))
                        .shadow(color: Color.red.opacity(0.6), radius: 10, x: 0, y: -5)
                }
            }
            .contentShape(Circle())
            Spacer()
            
            // Camera Button
            Button(action: {
                onCameraSelection()
            }) {
                Image(systemName: "camera")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Circle().fill(Color.gray.opacity(0.2)))
            }
        }
//        .padding()
        .background(Color.black)
        
    }
}

#Preview {
    FooterView(onCameraSelection: {}, onTextSelection: {},onMicrophoneToggle:{}, isRecording: .constant(true))
}
