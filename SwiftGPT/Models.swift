import Foundation

struct MessageWithID: Hashable, Codable {
	let id: UUID
	let content: String
	let role: String
}
