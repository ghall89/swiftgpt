import Foundation
import ChatGPTSwift

func handleOpenAI (apiKey: String, prompt: String) async -> MessageWithID {
	let api = ChatGPTAPI(apiKey: apiKey)
	
	do {
		let response = try await api.sendMessage(text: prompt)
		return MessageWithID(id: UUID(), content: response, role: "assistant")
		
	} catch {
		print(error.localizedDescription)
		return MessageWithID(id: UUID(), content: error.localizedDescription, role: "system")
	}
	
}

func restoreHistory(data: Data) {
	let decoder = JSONDecoder()
	if let storedKey = UserDefaults.standard.string(forKey: "api_key") {
		let api = ChatGPTAPI(apiKey: storedKey)
		do {
			// create array of messages without id and write to ChatGPTSwift history
			let history = try decoder.decode([Message].self, from: data)
			api.replaceHistoryList(with: history)
		} catch {
			print(error.localizedDescription)
		}
		
	} else {
		print("No API key")
	}
}


func handleButton (apiKey: String, chatArray: inout Array<MessageWithID>, prompt: String) async {
	
	let response = await handleOpenAI(apiKey: apiKey, prompt: prompt)
	chatArray.append(response)
	storeJSON(chatHistory: chatArray)
	
}
