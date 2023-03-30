import Foundation

struct Message: Hashable, Encodable {
	let id = UUID()
	let message: String
	let role: String
}
