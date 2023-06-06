import Foundation

struct AlertModel {
	let title: String
	let text: String
	let buttonText: String
	let completion: (() -> Void)?
	
	init(title: String, text: String, buttonText: String, completion: (() -> Void)? = nil) {
		self.title = title
		self.text = text
		self.buttonText = buttonText
		self.completion = completion
	}
}
