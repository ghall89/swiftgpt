import Foundation
import ChatGPTSwift

func handleOpenAI (apiKey: String, prompt: String) async -> MessageWithID {
	let api = ChatGPTAPI(apiKey: apiKey)
	
	do {
		let response = try await api.sendMessage(text: prompt)
		print(api.historyList)
		return MessageWithID(id: UUID(), message: response, role: "assistant")
		
	} catch {
		print(error.localizedDescription)
		return MessageWithID(id: UUID(), message: error.localizedDescription, role: "system")
	}
	
}

func restoreHistory(history: Array<Message>) {
	if let storedKey = UserDefaults.standard.string(forKey: "api_key") {
		let api = ChatGPTAPI(apiKey: storedKey)
		api.replaceHistoryList(with: history)
	}
}


func handleButton (apiKey: String, chatArray: inout Array<MessageWithID>, prompt: String) async {

	let response = await handleOpenAI(apiKey: apiKey, prompt: prompt)
	chatArray.append(response)
	storeJSON(chatHistory: chatArray)
	
}
