//
//  Text.swift
//  LingoVCT
//
//  Created by Mukhammad Bustonov on 10/12/24.
//

import SwiftUI

struct TextView: View {
    @State private var sourceLanguageIndex = 0
    @State private var targetLanguageIndex = 1
    @State private var inpurtText = ""
    @State private var outpuText = ""
    @State private var inputCharacterCount = 0
    @State private var outputCharacterCount = 0
    @State private var isInputCopied = false
    @State private var isOutputCopied = false
    
    let language = ["English", "Italian","Uzbek","Turkish","Russian"]
    let maxCharacter = 500
    
    var body: some View {
        VStack{
            ZStack{
                Color.black.edgesIgnoringSafeArea(.all)
                VStack(spacing:0){
                    HStack{
                        Text("Text Translation")
                            .font(.system(size:25))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        //                            .padding()
                        
                        Spacer()
                        Image(systemName: "bell.badge").frame(width: 45,height: 45).foregroundColor(.white)
                    }
                    VStack{
                        Rectangle().foregroundColor(.clear)
                            .frame(width:373,height: 1)
                            .background(.white.opacity(0.33))
                    }
                    HStack{
                        Picker("Source Language", selection:
                                $sourceLanguageIndex){
                            ForEach(0..<language.count, id: \.self){
                                index in Text(language[index])
                            }
                        }
                                .pickerStyle(MenuPickerStyle()).padding()
                        Button(action: swapLanguages) {
                            Image(systemName: "arrow.left.arrow.right")
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                        }
                        Picker("Target Language", selection:
                                $targetLanguageIndex){
                            ForEach(0..<language.count, id: \.self){
                                index in Text(language[index])
                            }
                        }
                                .pickerStyle(MenuPickerStyle()).padding()
                    }
                    ScrollView {
                        VStack{
                            Text("Translation From \(language[sourceLanguageIndex])")
                                .font(Font.custom("Inter",size: 17).weight(.light)).foregroundColor(.white.opacity(0.43)).padding()
                                .offset(x:-80)
                            ZStack{
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 373,height: 208)
                                    .background(Color(red:0.14,green:0.15,blue:0.15)).cornerRadius(22)
                                VStack{
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width:373,height: 1)
                                        .background(.white.opacity(0.33))
                                        .offset(y:55)
                                    
                                    HStack{
                                        Text("\(inputCharacterCount)/\(maxCharacter)")
                                            .font(Font.custom("Inter",size: 20)).foregroundColor(.white.opacity(0.43))
                                            .offset(x:-103,y:60)
                                        Button(action: {
                                            copyToClipboard(text: inpurtText, isInput: true)
//                                            print("cliiick")
                                        }) {
                                            Image(systemName: isInputCopied ? "checkmark.circle.fill" : "doc.on.doc").frame(width: 18,height: 18).foregroundColor(.white).offset(x:90,y:60)
                                            
                                            Rectangle().foregroundColor(.clear)
                                                .frame(width: 1,height: 18.02776)
                                                .background(.white.opacity(0.43))
                                                .offset(x:90,y:60)
                                            
                                            Image(systemName: "speaker.wave.2.fill").frame(width: 18,height: 18).foregroundColor(.white).offset(x:100,y:60)
                                        }
                                    }
                                    
                                    TextField("Enter Text", text: $inpurtText)
                                        .font(.title2)
                                        .offset(x: 25, y:-85)
                                        .foregroundColor(Color.white)
                                        .onChange(of: inpurtText) { newValue in
                                            isInputCopied = false
                                            updateCharacterCount(newValue)
                                        }
                                    
                                }
                            }
                           
                        }
                        Button("Translation", action: translationText)
                            .padding()
                        VStack{
                            Text("Translation From \(language[targetLanguageIndex])")
                                .font(Font.custom("Inter",size: 17).weight(.light)).foregroundColor(.white.opacity(0.43)).padding()
                                .offset(x:-80)
                            ZStack{
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 373,height: 208)
                                    .background(Color(red:0.14,green:0.15,blue:0.15)).cornerRadius(22)
                                VStack{
                                    Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width:373,height: 1)
                                        .background(.white.opacity(0.33))
                                        .offset(y:55)
                                    
                                    HStack{
                                        Text("\(outputCharacterCount)/\(maxCharacter)")
                                            .font(Font.custom("Inter",size: 20)).foregroundColor(.white.opacity(0.43))
                                            .offset(x:-103,y:60)
                                        Button(action:{
                                            copyToClipboard(text: outpuText, isInput: false)
                                        }){
                                            Image(systemName: isOutputCopied ? "checkmark.circle.fill" : "doc.on.doc").frame(width: 18,height: 18).foregroundColor(.white).offset(x:90,y:60)
                                            
                                            
                                            Rectangle().foregroundColor(.clear)
                                                .frame(width: 1,height: 18.02776)
                                                .background(.white.opacity(0.43))
                                                .offset(x:90,y:60)
                                            
                                            Image(systemName: "speaker.wave.2.fill").frame(width: 18,height: 18).foregroundColor(.white).offset(x:100,y:60)
                                        }
                                    }
                                    TextField("Output Text", text: $outpuText)                                  .font(.title2)
                                        .offset(x: 25, y:-85)
                                        .foregroundColor(Color.white)
                                        .disabled(true)
                                    
                                }
                            }
                            
                        }
                        
                    }
                }
                .padding()
            }
            
        }
    }
    func translationText(){
        let sourceLanguage = language[sourceLanguageIndex]
        let targetLanguage = language[targetLanguageIndex]
        
        translationWithAPI(inputText: inpurtText, sourceLanguage: sourceLanguage, targetLanguage: targetLanguage)
    }
    func translationWithAPI(inputText:String, sourceLanguage:String, targetLanguage:String) {
        
        let translations = [
            "Hello":[
                "Italian":"Ciao"
            ],
            "How are you":[
                "Italian":"Come stai"
            ],
        ]
        let lowercasedText = inputText.lowercased()
                if let translation = translations[lowercasedText]?[targetLanguage] {
                    outpuText = translation
                } else {
                    callOpenAIAPI(inputText: inputText, sourceLanguage: sourceLanguage, targetLanguage: targetLanguage)
                }
                outputCharacterCount = outpuText.count
            }
    
    func callOpenAIAPI(inputText: String, sourceLanguage: String, targetLanguage: String) {
            let apiKey = "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"
            let endpoint = "https://api.openai.com/v1/chat/completions"
            let requestBody: [String: Any] = [
                "model": "gpt-4",
                "messages": [
                    ["role": "system", "content": "You are a helpful assistant who translates \(sourceLanguage) words to \(targetLanguage)."],
                    ["role": "user", "content": inputText]
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
                        outpuText = "Error occurred!"
                    }
                    return
                }
                
                guard let data = data,
                      let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let choices = responseJSON["choices"] as? [[String: Any]],
                      let message = choices.first?["message"] as? [String: Any],
                      let translatedText = message["content"] as? String else {
                    DispatchQueue.main.async {
                        outpuText = "Failed to parse response!"
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    outpuText = translatedText
                    outputCharacterCount = translatedText.count
                }
            }
            task.resume()
        }
    
    func swapLanguages() {
        let temp = sourceLanguageIndex
        sourceLanguageIndex = targetLanguageIndex
        targetLanguageIndex = temp
        translationText()
    }
    func updateCharacterCount(_ newValue: String) {
        if newValue.count > maxCharacter {
            inpurtText = String(newValue.prefix(maxCharacter))
        }
        inputCharacterCount = inpurtText.count
    }
    func copyToClipboard(text: String, isInput: Bool) {
        if !text.isEmpty {
            UIPasteboard.general.string = text
            
            DispatchQueue.main.async {
                if isInput {
                    isInputCopied = true
                } else {
                    isOutputCopied = true
                }
            }

           
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if isInput {
                    isInputCopied = false
                } else {
                    isOutputCopied = false
                }
            }
        } else {
            print(isInput ? "Input text is empty" : "Output text is empty")
        }
    }
}

struct TextView_Previews:PreviewProvider{
    static var previews: some View{
        TextView().preferredColorScheme(.dark)
    }
}
