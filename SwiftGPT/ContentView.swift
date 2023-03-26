//
//  ContentView.swift
//  SwiftGPT
//
//  Created by Graham Hall on 3/25/23.
//

import SwiftUI

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
				Text(item.message).textSelection(.enabled)
			}
			HStack {
				Button(action: {
					showDialog = true
				}) {
					Image(systemName: "key.fill")
				}.sheet(isPresented: $showDialog) {
					DialogView(showDialog: $showDialog, apiKey: $apiKey)
				}
				TextField("Prompt", text: $prompt)
				Button("Send") {
					handleButton()
				}.keyboardShortcut(.defaultAction)
			}.frame(height: 20).padding()
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

