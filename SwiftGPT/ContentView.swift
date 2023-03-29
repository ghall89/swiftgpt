//
//  ContentView.swift
//  SwiftGPT
//
//  Created by Graham Hall on 3/25/23.
//

import SwiftUI
import ChatGPTSwift

struct ContentView: View {
	@State var showDialog: Bool = false
	@State var apiKey: String = retrieveKey(key: "api_key")
	@State var prompt: String = ""
	@State var chatArray: Array = [Message]()
	
	var body: some View {
		ZStack(alignment: .bottom) {
			ChatView(chatArray: $chatArray)
			VStack {
				Divider()
				HStack {
					TextField("Prompt", text: $prompt).textFieldStyle(.plain).lineLimit(1...5)
					Button(action: {
						if apiKey != "" {
							chatArray.append(Message(message: prompt, role: "user"))
							Task {
								await handleButton(apiKey: apiKey, chatArray: &chatArray, prompt: &prompt)
							}
						} else {
							showDialog = true
						}
					}) {
						Image(systemName: "paperplane.fill")
					} .keyboardShortcut(.defaultAction).buttonStyle(PlainButtonStyle()).foregroundColor(.blue).disabled(prompt.isEmpty).padding(.horizontal, 5)
				}.padding().offset(y: -5)
			}.background(.thickMaterial, in: Rectangle())
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

