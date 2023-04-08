import Foundation

struct MessageWithID: Hashable, Codable {
	let id: UUID
	let message: String
	let role: String
}
