import Foundation
import ChatGPTSwift

func storeJSON(chatHistory: Array<MessageWithID>) {
	print("Storing JSON...")
	let encoder = JSONEncoder()
	let jsonData = try! encoder.encode(chatHistory)
	
	print(jsonData)
	
	let fileManager = FileManager.default
	let documentsDirectory = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
	let fileURL = documentsDirectory.appendingPathComponent("swiftgpt_history.json")
	
	do {
		try fileManager.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
		fileManager.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
		try jsonData.write(to: fileURL, options: .atomic)
	} catch {
		print(error)
	}
}


func readJSON() -> Array<MessageWithID> {
	 if let fileURL = try? FileManager.default
		.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
		.appendingPathComponent("swiftgpt_history.json") {
		 do {
			 let jsonData = try Data(contentsOf: fileURL)
			 let decoder = JSONDecoder()
			 
//			 // create array of messages without id and write to ChatGPTSwift history
//			 let messagesWithoutId = try decoder.decode([Message].self, from: jsonData)
//			 restoreHistory(history: messagesWithoutId)
			 
			 // create array of messages with id to display in list view
			 let messagesWithId = try decoder.decode([MessageWithID].self, from: jsonData)
			 return messagesWithId
		 } catch {
			 print(error)
		 }
	 }
	
	return []
}
