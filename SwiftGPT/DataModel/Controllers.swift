import Foundation
import CoreData

func storeHistory (array: Array<Message>) {
	let jsonEncoder = JSONEncoder()
	
	do  {
		let jsonData = try jsonEncoder.encode(array)
		let jsonString = String(data: jsonData, encoding: .utf8)
		
	} catch {
		print("Error")
	}
	
}

//func retrieveHistory () -> Array<Message> {
//
//}
