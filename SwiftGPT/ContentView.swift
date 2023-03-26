//
//  ContentView.swift
//  SwiftGPT
//
//  Created by Graham Hall on 3/25/23.
//

import SwiftUI

func chatColor(role: String) -> Color {
	switch role {
		case "user":
			return Color.gray
		case "assistant":
			return Color.blue
		default:
			return Color.gray
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
						let response = text.trimmingCharacters(in: .whitespacesAndNewlines)
						chatArray.append(Message(message: response, role: "assistant"))
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
				ZStack(alignment: .leading) {
					RoundedRectangle(cornerRadius: 5).foregroundColor(chatColor(role: item.role)).shadow(radius: 10)
					Text(item.message).textSelection(.enabled).padding(8).foregroundColor(.white)
				}
			}
			HStack {
				TextField("Prompt", text: $prompt)
				Button("Send") {
					handleButton()
				}.keyboardShortcut(.defaultAction)
			}.padding()
		}.toolbar {
			ToolbarItemGroup(placement: .primaryAction) {
				Button(action: {
					showDialog = true
				}) {
					Image(systemName: "key.fill")
				}.sheet(isPresented: $showDialog) {
					DialogView(showDialog: $showDialog, apiKey: $apiKey)
				}
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

