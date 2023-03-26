//
//  ContentView.swift
//  SwiftGPT
//
//  Created by Graham Hall on 3/25/23.
//

import SwiftUI

func retrieveKey() -> String {
	let storedKey: String? = UserDefaults.standard.string(forKey: "api_key")
	
	if storedKey != nil {
		return storedKey!
	} else {
		return ""
	}
	
}

struct ContentView: View {
	@State var showDialog: Bool = false
	@State var apiKey: String = retrieveKey()
	@State var prompt: String = ""
	@State var chatArray: Array = [Message]()
	
	func handleButton () {
		chatArray.append(Message(message: prompt, role: "User"))
		if apiKey != "" {
			generateText(prompt: prompt, key: apiKey, chat: chatArray) { result in
				switch result {
					case .success(let text):
						print(text)
						chatArray.append(Message(message: text, role: "assistant"))
					case .failure(let error):
						print(error.localizedDescription)
						chatArray.append(Message(message: error.localizedDescription, role: "system"))
				}
			}
		} else {
			showDialog = true
		}
		
	}
	
	var body: some View {
		VStack {
			List(chatArray) { item in
				Text(item.message)
			}
			Divider()
			HStack {
				Button(action: {
		
					showDialog = true
				}) {
					Image(systemName: "gear")
				}.sheet(isPresented: $showDialog) {
					VStack{
						TextField("API Key", text: $apiKey)
						Button("Ok") {
							UserDefaults.standard.set(apiKey, forKey: "api_key")
							showDialog = false
						}
					}.frame(width: 300).padding()
				}
				TextField("Prompt", text: $prompt)
				Button("Send") {
					handleButton()
				}
			}.frame(height: 20).padding()
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

