//
//  ContentView.swift
//  SwiftGPT
//
//  Created by Graham Hall on 3/25/23.
//

import SwiftUI
import Foundation

struct Message: Identifiable {
	let id = UUID()
	let message: String
}

struct ContentView: View {
	@State var showDialog = false
	@State var apiKey = ""
	@State var prompt = ""
	@State var chatArray = [Message]()
	
	func handleButton () {
		chatArray.append(Message(message: prompt))
		if apiKey != "" {
			generateText(prompt: prompt, key: apiKey, engine: "curie") { result in

				print(apiKey)
				switch result {
					case .success(let text):
						print(text)
						chatArray.append(Message(message: text))
					case .failure(let error):
						print(error.localizedDescription)
				}
			}
		} else {
			chatArray.append(Message(message: "Please provide API key"))
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

