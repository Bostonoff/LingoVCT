//
//  TapMeView.swift
//  LingoVCT
//
//  Created by Mukhammad Bustonov on 10/12/24.
//

import SwiftUI
import AVFoundation

struct TapMeView: View {
    //    @State private var isTapped = false
    @State private var showButtons = false
    @State private var textScale: CGFloat = 1.0
    @State private var showCamera = false
    @State private var image: UIImage?
    @State private var hasPermission = false
    @State private var recognizedText: String = ""
    var body: some View {
        NavigationStack {
            ZStack {
                //background changes when i tapped from black to blue
                Color(.blue)
                    .edgesIgnoringSafeArea(.all)
                
                //                if !isTapped {
                //                    //                click button
                //                    Text("Click")
                //                        .font(.largeTitle)
                //                        .foregroundColor(.white)
                //                        .scaleEffect(textScale)
                //                    // using size text to increase
                //                        .padding(30)
                //                        .background(Circle().fill(Color.red)
                //                            .frame(width: 250,height: 250))
                //                        .onTapGesture {
                //                            withAnimation(.easeInOut(duration: 0.6)) {
                //                                textScale = 0.1
                //                                // text size changing
                //                                isTapped.toggle()
                //                                // switch in switch off
                //                            }
                //                        }
                //                }
                //                else {
                
                VStack {
                    Spacer()
                    NavigationLink {
                        MicrophoneView()
                    } label: {
                        Image(systemName: "mic")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Circle().fill(Color.white))
                            .frame(width: 100, height: 100)
                            .offset(y: showButtons ? 0 : -200)
                            .opacity(showButtons ? 1 : 0)
                            .animation(.easeOut(duration: 2).delay(2), value: showButtons)
                    }
                    
                    Spacer().frame(height: 0)
                    HStack {
                        // Camera button
                        Button(action: {
                            checkCameraPermission()
                            if hasPermission {
                                showCamera = true
                            }
                        }) {
                            Image(systemName: "camera")
                                .font(.largeTitle)
                                .foregroundColor(.blue)
                                .padding()
                                .background(Circle().fill(Color.white))
                                .frame(width: 100, height: 100)
                                .offset(x: showButtons ? 0 : -200)
                                .opacity(showButtons ? 1 : 0)
                                .animation(.easeOut(duration:0.7).delay(1), value: showButtons)
                        }
                        
                        // TextView button
                        NavigationLink(destination: TextView()) {
                            Image(systemName: "textformat.size")
                                .font(.largeTitle)
                                .foregroundColor(.blue)
                                .padding()
                                .background(Circle().fill(Color.white))
                                .frame(width: 100, height: 100)
                                .offset(x: showButtons ? 0 : 200)
                                .opacity(showButtons ? 1 : 0)
                                .animation(.easeOut(duration: 1.5).delay(1.5), value: showButtons)
                        }
                    }
                    Spacer()
                }
//                .transition(.scale)
                
                
                
                
            }.onAppear {
                withAnimation {
                    showButtons = true
                }
            }
            .sheet(isPresented: $showCamera) {
                CameraPicker(image: $image).edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            hasPermission = true
        case .denied, .restricted:
            hasPermission = false
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { response in
                DispatchQueue.main.async {
                    self.hasPermission = response
                }
            }
        @unknown default:
            hasPermission = false
        }
    }
}

#Preview {
    TapMeView()
}

