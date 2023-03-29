//
//  OpenAIHandler.swift
//  SwiftGPT
//
//  Created by Graham Hall on 3/25/23.
//

import Foundation
import ChatGPTSwift

func handleOpenAI (apiKey: String, prompt: String) async -> Message {
	let api = ChatGPTAPI(apiKey: apiKey)
	
	do {
		let response = try await api.sendMessage(text: prompt)
		return Message(message: response, role: "assistant")
	} catch {
		print(error.localizedDescription)
		return Message(message: error.localizedDescription, role: "system")
	}
}


func handleButton (apiKey: String, chatArray: inout Array<Message>, prompt: inout String) async {
	
	let input = prompt
	prompt = ""
	let response = await handleOpenAI(apiKey: apiKey, prompt: input)
	chatArray.append(response)

}
