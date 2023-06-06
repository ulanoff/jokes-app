import Foundation

struct Joke: Codable {
	let type: String
	let setup: String
	let punchline: String
	let id: Int
}
