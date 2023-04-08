import Foundation

func storeJSON(chatHistory: Array<Message>) {
	print("Storing JSON...")
	let encoder = JSONEncoder()
	let jsonData = try! encoder.encode(chatHistory)
	
	print(jsonData)
	
	let fileURL = try! FileManager.default
		.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
		.appendingPathComponent("swiftgpt_history.json")
	try! jsonData.write(to: fileURL)
}

func readJSON() {
	
}
