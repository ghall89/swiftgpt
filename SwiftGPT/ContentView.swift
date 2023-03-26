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
			return Color.red
	}
	
}

struct ContentView: View {
	@State var showDialog: Bool = false
	@State var apiKey: String = retrieveKey()
	@State var prompt: String = ""
	@State var chatArray: Array = [Message]()
	
	func handleButton () {
		if apiKey != "" {
			chatArray.append(Message(message: prompt, role: "user"))
			generateText(prompt: prompt, key: apiKey, chat: chatArray) { result in
				switch result {
					case .success(let text):
						let response = text.trimmingCharacters(in: .whitespacesAndNewlines)
						chatArray.append(Message(message: response, role: "assistant"))
						prompt = ""
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
		ZStack(alignment: .bottom) {
			ChatView(chatArray: $chatArray)
			HStack {
				TextField("Prompt", text: $prompt,  axis: .vertical).lineLimit(1...5)
				Button("Send") {
					handleButton()
				}.keyboardShortcut(.defaultAction).buttonStyle(.bordered)
			}.padding().background(.thickMaterial, in: Rectangle())
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

