import Foundation
import ChatGPTSwift

func handleOpenAI (apiKey: String, prompt: String) async -> Message {
	let api = ChatGPTAPI(apiKey: apiKey)
	
	do {
		let response = try await api.sendMessage(text: prompt)
//		print(api.historyList)
		return Message(message: response, role: "assistant")
		
	} catch {
		print(error.localizedDescription)
		return Message(message: error.localizedDescription, role: "system")
	}
	
}


func handleButton (apiKey: String, chatArray: inout Array<Message>, prompt: String) async {

	let response = await handleOpenAI(apiKey: apiKey, prompt: prompt)
	chatArray.append(response)
//	storeHistory(array: chatArray)
	
}
